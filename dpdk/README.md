# Enable DPDK

**Danger**\
**NIC bind to DPDK will be removed from system**\
Overall, I suggest not using DPDK since it is too problematic on consumer hardware, and the kernel stack is good enough.

---

1. Bind NIC to DPDK (Run from the host)\
   You can choose from:
   - [UIO Driver](https://github.com/Eisaichen/cisco-trex-docker/blob/main/dpdk/bind_dpdk_uio.sh)
     Require IOMMU to be disabled or in passthrough mode
   - [VFIO Driver](https://github.com/Eisaichen/cisco-trex-docker/blob/main/dpdk/bind_dpdk_vfio.sh)
     Require IOMMU to be enabled

```bash
./bind_dpdk_uio.sh DEV1 [DEV2..]
or
./bind_dpdk_vfio.sh DEV1 [DEV2..]
```

2. Prepare `trex_cfg.yaml`

```yaml
- port_limit: 2
  version: 2
  # put pci location here
  interfaces: ["0000:00:ab.3", "0000:01:cd.5"]
  port_info:
    - ip: <ip_addr>
      default_gw: <gateway_addr>
```

3. Check uio device exists

```bash
# UIO driver, you should see one uio device for each NIC bound
ls /dev/uio*

# VFIO driver, you should see VFIO group
ls /dev/vfio/
```

4. Put NIC into [`docker-compose.yaml`](https://github.com/Eisaichen/cisco-trex-docker/blob/main/dpdk/docker-compose.yaml)\
   For UIO driver, add the UIO device, eg. `/dev/uio0`\
   For VFIO driver, add the VFIO group, eg. `/dev/vfio/19`\
   Run test

```bash
docker compose up
```

5. Un-bind NIC from DPDK (Run from the host)\
   [unbind_dpdk.sh](https://github.com/Eisaichen/cisco-trex-docker/blob/main/dpdk/unbind_dpdk.sh)

```bash
./unbind_dpdk.sh
```

