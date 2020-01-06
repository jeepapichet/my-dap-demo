#!/bin/bash
set -e

curr_dir=$(pwd)  #use this to get full path inside container. Assuming user is running as root

docker run --rm -v $HOME:/root -it cyberark/conjur-cli:5 policy load java $curr_dir/java.yml
docker run --rm -v $HOME:/root -it cyberark/conjur-cli:5 policy load powershell $curr_dir/powershell.yml
docker run --rm -v $HOME:/root -it cyberark/conjur-cli:5 policy load root $curr_dir/app-permission.yml
