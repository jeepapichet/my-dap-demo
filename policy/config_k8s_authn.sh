#!/bin/bash
set -e

curr_dir=$(pwd)

#== Obtain K8S API detail and load to Conjur
# This should be applied after creating Kubernetes service account
TOKEN_SECRET_NAME="$(oc get secrets -n $CONJUR_NAMESPACE_NAME \
    | grep 'conjur.*service-account-token' \
    | head -n1 \
    | awk '{print $1}')"

CA_CERT="$(oc get secret -n $CONJUR_NAMESPACE_NAME $TOKEN_SECRET_NAME -o json \
      | jq -r '.data["ca.crt"]' \
      | base64 --decode)"

SERVICE_ACCOUNT_TOKEN="$(oc get secret -n $CONJUR_NAMESPACE_NAME $TOKEN_SECRET_NAME -o json \
      | jq -r .data.token \
      | base64 --decode)"

API_URL="$(oc config view --minify -o json \
      | jq -r '.clusters[0].cluster.server')"


docker run --rm -v $curr_dir:/root -it cyberark/conjur-cli:5 authn login -u admin -p $CONJUR_ADMIN_PASSWORD

docker run --rm -v $curr_dir:/root -it cyberark/conjur-cli:5 variable values add conjur/authn-k8s/$AUTHENTICATOR_ID/kubernetes/ca-cert "$CA_CERT"

docker run --rm -v $curr_dir:/root -it cyberark/conjur-cli:5 variable values add conjur/authn-k8s/$AUTHENTICATOR_ID/kubernetes/service-account-token "$SERVICE_ACCOUNT_TOKEN"

docker run --rm -v $curr_dir:/root -it cyberark/conjur-cli:5 variable values add conjur/authn-k8s/$AUTHENTICATOR_ID/kubernetes/api-url "$API_URL"
