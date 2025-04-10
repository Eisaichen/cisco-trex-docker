#!/bin/bash

if [ $# -eq 0 ]; then
    ./trex_daemon_server start-live
else
    if [ ! -f /etc/trex_cfg.yaml ]; then
        gw="$(ip route | grep default | awk '{print $3}')"
        veth_driver="$(ethtool -i eth0 | grep driver | awk '{ print $2 }')"
        ip_addr="$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"

        if [ ! "$veth_driver" == "veth" ]; then
            echo "host network detected, launching config.."
            echo 'input NIC name like "eth0" for non-DPDK mode'
            echo 'input PCI location like "0000:00:ab.3" for DPDK mode'
            echo ''
            python3 ./dpdk_setup_ports.py -i --stack linux_based -o /etc/trex_cfg.yaml
        else
            cat <<EOF > /etc/trex_cfg.yaml
- port_limit    : 2
  version       : 2
  interfaces    : ["eth0", "dummy"]   # list of the interfaces to bind run ./dpdk_nic_bind.py --status
  stack         : linux_based
  port_info     :  # set eh mac addr
    - ip         : ${ip_addr}
      default_gw : ${gw}
EOF
        fi
    fi

    for arg in "$@"; do
        if [[ "$arg" == "-i" ]]; then
            timer=0
            nohup ./t-rex-64 $@ > /dev/null 2>&1 &
            until nc -z -w 2 127.0.0.1 4501; do
                if [ $timer -gt 15 ]; then
                    ./t-rex-64 $@
                    exit 1
                fi
                ((timer+=1))
                echo "Starting..."
                sleep 2
            done
            ./trex-console
            exit 0
        fi
    done
    ./t-rex-64 $@
fi
