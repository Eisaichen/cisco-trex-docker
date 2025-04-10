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
sudo sysctl -w vm.nr_hugepages=1024 > /dev/null

# Load UIO driver
sudo modprobe -a uio_pci_generic uio
echo "8086 10f5" | sudo tee /sys/bus/pci/drivers/uio_pci_generic/new_id > /dev/null

# Bind NIC to userspace for DPDK usage
for arg in "$@"; do
    if [ ! -d "/sys/class/net/$arg" ]; then
        echo "$arg is not a valid device"
        exit 1
    fi
    DEV_LOCATION="$(ethtool -i $arg | grep bus-info | awk '{ print $2 }')"
    DEV_ID="$(basename $(readlink "/sys/class/net/$arg/device"))"
    DEV_DRIVER="$(basename $(readlink "/sys/class/net/$arg/device/driver"))"
    echo $arg
    echo "UUID: $DEV_ID"
    echo "Driver: $DEV_DRIVER"
    echo "Interface, put in trex_cfg.yaml: $DEV_LOCATION"
    echo ""
    echo "$DEV_ID $DEV_DRIVER" >> ./nic.txt
    echo $DEV_ID | sudo tee /sys/bus/pci/drivers/${DEV_DRIVER}/unbind > /dev/null
    echo "uio_pci_generic" | sudo tee "/sys/bus/pci/devices/${DEV_ID}/driver_override" > /dev/null
    sleep 2
    echo $DEV_ID | sudo tee /sys/bus/pci/drivers/uio_pci_generic/bind > /dev/null
done
