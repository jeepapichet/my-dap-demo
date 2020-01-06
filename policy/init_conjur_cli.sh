#!/bin/bash
set -e

curr_dir=$(pwd)


rm -f $curr_dir/.conjurrc
rm -f $curr_dir/conjur-$CONJUR_ACCOUNT.pem

docker run -i --rm -v $curr_dir:/root cyberark/conjur-cli:5 init --force=yes -a cyberark -u https://$CONJUR_MASTER_DNS_NAME << EOF
yes
EOF
