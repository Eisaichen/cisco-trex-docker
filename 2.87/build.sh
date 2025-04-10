#!/bin/bash

cd ./2.87
wget --no-check-certificate --no-cache https://trex-tgn.cisco.com/trex/release/v2.87.tar.gz
tar -xzvf v2.87.tar.gz
mv v2.87 ./build/
chmod +x ../entry.sh
cp ../entry.sh ./build/v2.87/
docker build --no-cache --pull -t eisai/cisco-trex:v2.87 ./build
if [ $GH_CI_PUSH == "true" ]; then
    docker push eisai/cisco-trex:v2.87
fi
