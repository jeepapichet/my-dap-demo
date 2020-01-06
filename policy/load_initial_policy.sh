#!/bin/bash
set -e

curr_dir=$(pwd)

docker run --rm -v $curr_dir:/root -i cyberark/conjur-cli:5 authn login -u admin -p $CONJUR_ADMIN_PASSWORD
docker run --rm -v $curr_dir:/root -i cyberark/conjur-cli:5 policy load root /root/root.yml


#=== LDAP Policy
docker run --rm -v $curr_dir:/root -i cyberark/conjur-cli:5 policy load conjur/ldap-sync /root/ldap-sync.yml

#=== Auto-failover cluster
docker run --rm -v $curr_dir:/root -i cyberark/conjur-cli:5 policy load root /root/cluster.yml

