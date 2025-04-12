#!/bin/bash


if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "./bind_dpdk.sh DEV1 [DEV2..]"
    exit 1
fi

# enable hugepage is required by DPDK
sudo sysctl -w vm.nr_hugepages=1024 > /dev/null
modprobe vfio-pci
> ./devices.txt

for arg in "$@"; do
    if [ ! -d "/sys/class/net/$arg" ]; then
        echo "$arg is not a valid device"
        exit 1
    fi
    DEV_LOCATION="$(ethtool -i $arg | grep bus-info | awk '{ print $2 }')"
    IOMMU_GROUP="$(basename $(readlink /sys/bus/pci/devices/${DEV_LOCATION}/iommu_group))"
    IOMMU_DEVS=$(ls /sys/bus/pci/devices/${DEV_LOCATION}/iommu_group/devices)

    echo "Device bind to DPDK will be REMOVED from the system!"
    echo ""
    echo "IOMMU group number: $IOMMU_GROUP"
    echo "Following devices in the same IOMMU group will be bound to DPDK:"
    echo ""
    for DEV in $IOMMU_DEVS; do
        DEV_NAME="$(lspci -s $DEV)"
        # Skip PCI bridges
        if [[ "$DEV_NAME" == *"PCI bridge"* ]]; then
            continue
        fi
        echo "$DEV_NAME"
        DEVS="$DEVS $DEV"
    done

    echo ""
    echo "press any key to continue or Ctrl+C to cancel"
    read -n1 -s

    for DEV in $DEVS; do
        DEV_NAME="$(lspci -s $DEV)"
        DEV_DRIVER="$(basename $(readlink /sys/bus/pci/devices/${DEV}/driver))"
        DEV_ID="$(lspci -n -s "$DEV" | awk '{print $3}' | sed 's/:/ /')"
        echo "Binding: $DEV_NAME"
        echo "$DEV $DEV_DRIVER" >> ./devices.txt
        echo "$DEV" > /sys/bus/pci/devices/${DEV}/driver/unbind
        sleep 2
        echo "$DEV_ID" > /sys/bus/pci/drivers/vfio-pci/new_id
    done
done

echo ""
echo "Done."
echo -n "Press 'y' to confirm within 15 seconds: "
read -t 15 -n 1 input

if [[ "${input,,}" != "y" ]]; then
    echo -e "\nTimeout or wrong input. Executing fallback..."
    ./unbind_dpdk.sh
    exit 0
fi

echo -e "\nInterface, put in trex_cfg.yaml: $DEV_LOCATION"
exit 0

