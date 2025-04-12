#!/bin/bash


if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "./bind_dpdk.sh DEV1 [DEV2..]"
    exit 1
fi

echo "This will remove NIC from the system!"
echo "press any key to continue or Ctrl+C to cancel"
read -n1 -s

# enable hugepage is required by DPDK
sysctl -w vm.nr_hugepages=1024 > /dev/null

# Load UIO driver
modprobe -a uio_pci_generic uio

# Bind NIC to userspace for DPDK usage
> ./devices.txt
for arg in "$@"; do
    if [ ! -d "/sys/class/net/$arg" ]; then
        echo "$arg is not a valid device"
        exit 1
    fi
    DEV="$(ethtool -i $arg | grep bus-info | awk '{ print $2 }')"
    DEV_NAME="$(lspci -s $DEV)"
    DEV_DRIVER="$(basename $(readlink "/sys/class/net/$arg/device/driver"))"
    DEV_ID="$(lspci -n -s "$DEV" | awk '{print $3}' | sed 's/:/ /')"
    
    echo "Binding: $DEV_NAME"
    echo "UUID: $DEV"
    echo "Driver: $DEV_DRIVER"
    echo "Interface, put in trex_cfg.yaml: $DEV"
    echo ""
    echo "$DEV $DEV_DRIVER" >> ./devices.txt
    echo $DEV | tee /sys/bus/pci/drivers/${DEV_DRIVER}/unbind > /dev/null
    sleep 2
    echo $DEV_ID | tee /sys/bus/pci/drivers/uio_pci_generic/new_id > /dev/null
done

exit 0

