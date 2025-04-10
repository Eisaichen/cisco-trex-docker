# Enable DPDK
**Danger**\
**NIC bind to DPDK will be removed from system**

1. Bind NIC to DPDK (Run from the host)
``` bash
./bind_dpdk.sh DEV1 [DEV2..]
```
`uio_pci_generic` driver will be used

2. Prepare `trex_cfg.yaml`
``` yaml
- port_limit    : 2
  version       : 2
  # put pci location here
  interfaces    : ["0000:00:ab.3", "0000:01:cd.5"]
  port_info     :
    - ip         : <ip_addr>
      default_gw : <gateway_addr>
```

3. Check uio device exists, you should see one uio device for each NIC bound
``` bash
ls /dev/uio*
```

4. Run test [docker-compose.yaml](https://github.com/Eisaichen/cisco-trex-docker/blob/main/dpdk/docker-compose.yaml)
``` bash
docker compose up
```

5. Un-bind NIC from DPDK (Run from the host)
``` bash
./unbind_dpdk.sh
```
