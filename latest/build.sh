#!/bin/bash

wget --no-check-certificate --no-cache https://trex-tgn.cisco.com/trex/release/latest
tar -xzvf latest
version=$(find . -maxdepth 1 -type d -name "v*" -printf "%f\n")
echo ""
echo -e "\033[0;32mLatest version is ${version}\033[0m"
echo ""
sed -i "4s/.*/COPY .\/${version} \/opt\/trex\/${version}/" ./build/Dockerfile
sed -i "39s/.*/WORKDIR \/opt\/trex\/${version}/" ./build/Dockerfile

mv ${version} ./build/
chmod +x ../entry.sh
cp ../entry.sh ./build/${version}/

if [ GH_CI_LATEST == "true"]; then
    docker build --no-cache --pull -t eisai/cisco-trex -t eisai/cisco-trex:${version} ./build
else
    docker build --no-cache --pull -t eisai/cisco-trex:${version} ./build
fi

if [ GH_CI_PUSH == "true"]; then
    docker push eisai/cisco-trex -a
fi
