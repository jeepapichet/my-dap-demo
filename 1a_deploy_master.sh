#!/bin/bash
set -e

echo "==== Cleaning up old container and starting a fresh one ==="
docker stop dap-appliance || true && \
  docker rm dap-appliance || true && \
  docker run --name dap-appliance -d --restart=always --security-opt seccomp:unconfined -p "443:443" -p "5432:5432" -p "1999:1999" $CONJUR_APPLIANCE_IMAGE


echo "==== Configuring Master ===="
docker exec dap-appliance evoke configure master --accept-eula -h $CONJUR_MASTER_DNS_NAME -p $CONJUR_ADMIN_PASSWORD $CONJUR_ACCOUNT

# Include workaround for ca rehash bug. This also need to be applied on followers
# Certificate files must be in tar-zip format and include dap-master.key dap-master.cer dap-follower.key dap-follower.cer file
echo "==== Importing certificates ===="
docker cp $CONJUR_CERT_FILES dap-appliance:/tmp/. \
  && docker exec dap-appliance tar -zxvf /tmp/dap-certificate.tgz \
  && docker exec dap-appliance evoke ca import --root ca-cert.cer \
  && docker exec dap-appliance openssl rehash /opt/conjur/etc/ssl \
  && docker exec dap-appliance evoke ca import --key dap-follower.key dap-follower.cer \
  && docker exec dap-appliance evoke ca import --key dap-master.key --set dap-master.cer


# Generate follower certs if not using 3rd party
#docker exec dap-appliance evoke ca issue --force follower.dap.svc.cluster.local follower.dap.svc dap-follower.apps.okd.cyberark.local follower-dap.apps.okd.cyberark.local

#echo "=== Generate SEED files for standby and follower ==="
#docker exec -i dap-appliance evoke seed standby dap2.cyberarkdemo.com dap1.cyberarkdemo.com > dap2-seed.tar
#docker exec -i dap-appliance evoke seed standby dap3.cyberarkdemo.com dap1.cyberarkdemo.com > dap3-seed.tar

#echo "==== Configuring Standby ===="
#ssh dap2 'docker exec  dap-appliance evoke keys exec -- evoke configure standby --master-address=dap1.cyberarkdemo.com'
#ssh dap3 'docker exec dap-appliance evoke keys exec -- evoke configure standby --master-address=dap1.cyberarkdemo.com'

#echo "==== Starting synchronous replication ===="
#ssh dap1 'docker exec dap-appliance evoke replication sync'

echo "==== Wait for Conjur to Start ===="
sleep 10

echo "==== Load default policy ===="
pushd policy
  ./load_initial_policy.sh
popd
