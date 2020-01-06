#!/bin/bash
set -e

script_dir=my-okd-conjur-deploy


oc login -u admin
#Clean up old deployment to avoid create error
oc delete --ignore-not-found svc dap-follower
oc delete --ignore-not-found dc dap-follower

#   oc create -f conjur-role.yml
pushd $script_dir
./1_prepare_conjur_namespace.sh
popd

pushd policy
./config_k8s_authn.sh
popd

pushd $script_dir
./2_prepare_docker_images.sh
./3_deploy_conjur_followers.sh
popd
