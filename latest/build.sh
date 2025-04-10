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
docker build --no-cache --pull -t eisai/cisco-trex -t eisai/cisco-trex:${version} ./build
docker push eisai/cisco-trex -a
docker rmi eisai/cisco-trex eisai/cisco-trex:${version}
rm -rf ./build/${version}
rm latest
