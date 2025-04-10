# cisco-trex-docker
TRex Traffic Generator, Containerized.\
https://hub.docker.com/r/eisai/cisco-trex

# Usage

**Prepare your test configuration, `test.yaml` or `test.py` [basic_usage](https://trex-tgn.cisco.com/trex/doc/trex_manual.html#_basic_usage)**
``` bash
docker run --name trex -v <your_test_conf>:/test.yaml --rm -it --privileged --cap-add=ALL eisai/cisco-trex -f /test.yaml <arguments>
```
## Example
### Run test stateless
``` bash
docker run --name trex -v ./test.yaml:/test.yaml --rm -it --privileged --cap-add=ALL eisai/cisco-trex -f /test.yaml -m 1000 -l 10
```
### Run test ASTF stateful
``` bash
docker run --name trex -v ./test.py:/test.py --rm -it --privileged --cap-add=ALL eisai/cisco-trex --astf -f /test.py -m 10 -d 100
```
### Run test with host NIC
1. Prepare TRex configuration `trex_cfg.yaml` [First time Running](https://trex-tgn.cisco.com/trex/doc/trex_manual.html#_first_time_running)
2. Set up IP address on NIC for testing

**By default, ports 4500,4501,4507 are used.**
``` bash
docker run --name trex -v ./trex_cfg.yaml:/etc/trex_cfg.yaml -v ./test.py:/test.py --rm -it --privileged --cap-add=ALL --network host eisai/cisco-trex --astf -f /test.py -m 10 -d 100
```
*Run without any arguments will enter auto-config interface `dpdk_setup_ports.py -i`*
### docker-compose.yaml
``` yaml
services:
    trex:
        container_name: trex
        image: eisai/cisco-trex
        restart: "no"
        network_mode: "host"
        cap_add:
            - ALL
        privileged: true
        tty: true
        stdin_open: true
        command: ["--astf", "-f", "/test.py", "-d", "100", "-m", "10"]
        volumes:
            - './test.py:/test.py'
            - './trex_cfg.yaml:/etc/trex_cfg.yaml'
```
## Interactive mode
### TRex Console
``` bash
docker run --name trex --rm -it --privileged --cap-add=ALL eisai/cisco-trex -i --astf
```
### TRex Daemon Server (For stateless GUI)
``` bash
docker run --name trex --rm -it --privileged --cap-add=ALL --network host eisai/cisco-trex:v2.87
```
Default port for daemon server: 8090
### DPDK mode
https://github.com/Eisaichen/cisco-trex-docker/tree/main/dpdk

# Documents

## TRex Documentation
https://trex-tgn.cisco.com/trex/doc/
