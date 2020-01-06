#!/bin/bash
set -euo pipefail

echo "Generating Conjur policy."

pushd policy
  mkdir -p ./generated

  sed -e "s#{{ AUTHENTICATOR_ID }}#$AUTHENTICATOR_ID#g" ./template/projects-authn.template.yml |
    sed -e "s#{{ TEST_APP_NAMESPACE_NAME }}#$TEST_APP_NAMESPACE_NAME#g" > ./generated/projects-authn.yml


  sed -e "s#{{ AUTHENTICATOR_ID }}#$AUTHENTICATOR_ID#g" ./template/app-identity.template.yml |
    sed -e "s#{{ TEST_APP_NAMESPACE_NAME }}#$TEST_APP_NAMESPACE_NAME#g" > ./generated/app-identity.yml


  sed -e "s#{{ AUTHENTICATOR_ID }}#$AUTHENTICATOR_ID#g" ./template/secrets-grant.yml |
    sed -e "s#{{ TEST_APP_NAMESPACE_NAME }}#$TEST_APP_NAMESPACE_NAME#g" > ./generated/secrets-grant.yml

popd


echo "Loading Conjur policy."

# Create the random database password

#rm -f $PWD/policy/.conjurrc
#sudo docker run --rm -v $PWD/policy:/root -it cyberark/conjur-cli:5 init -u https://$CONJUR_MASTER_DNS_NAME -a $CONJUR_ACCOUNT --force=yes
sudo docker run --rm -v $PWD/policy:/root -it cyberark/conjur-cli:5 authn login -u admin -p $CONJUR_ADMIN_PASSWORD
sudo docker run --rm -v $PWD/policy:/root -it cyberark/conjur-cli:5 policy load conjur/authn-k8s/$AUTHENTICATOR_ID/apps /root/generated/projects-authn.yml
sudo docker run --rm -v $PWD/policy:/root -it cyberark/conjur-cli:5 policy load root /root/generated/app-identity.yml
sudo docker run --rm -v $PWD/policy:/root -it cyberark/conjur-cli:5 policy load secrets /root/generated/secrets-grant.yml
