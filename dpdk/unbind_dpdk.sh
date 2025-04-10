#!/bin/bash

while IFS=' ' read -r DEV_ID DEV_DRIVER; do
    echo $DEV_ID | sudo tee /sys/bus/pci/drivers/uio_pci_generic/unbind > /dev/null
    echo $DEV_DRIVER | sudo tee "/sys/bus/pci/devices/${DEV_ID}/driver_override" > /dev/null
    sleep 2
    echo $DEV_ID | sudo tee /sys/bus/pci/drivers/${DEV_DRIVER}/bind > /dev/null
done < "./nic.txt"

sudo modprobe -r -a uio_pci_generic uio
rm ./nic.txt

# disable hugepages
sudo rm /dev/hugepages/* 2> /dev/null
sudo sysctl -w vm.nr_hugepages=0 > /dev/null
