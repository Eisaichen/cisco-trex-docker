#!/bin/bash


if [ ! -f ./devices.txt ]; then
    mv ./devices.txt.bak ./devices.txt 2> /dev/null
fi

modprobe -r -a uio_pci_generic uio vfio-pci
sleep 2
while IFS=' ' read -r DEV DEV_DRIVER; do
    DEV_NAME="$(lspci -s $DEV)"
    echo "Un-Binding: $DEV_NAME"
    echo $DEV | tee /sys/bus/pci/drivers/${DEV_DRIVER}/bind > /dev/null
done < "./devices.txt"

# disable hugepages
rm /dev/hugepages/* 2> /dev/null
sysctl -w vm.nr_hugepages=0 > /dev/null

rm ./devices.txt.bak 2> /dev/null
mv ./devices.txt ./devices.txt.bak


dmesg | grep -i iommu

