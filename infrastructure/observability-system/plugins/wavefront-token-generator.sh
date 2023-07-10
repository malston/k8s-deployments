#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Put logic for fetching api token here

# resourceList=$(cat) # read the `kind: ResourceList` from stdin
# serviceAccountId=$(echo "$resourceList" | yq e '.functionConfig.spec.serviceAccountId' - )
# wavefrontUrl=$(echo "$resourceList" | yq e '.functionConfig.spec.wavefrontUrl' - )

# curl -X 'POST' \
#   "${wavefrontUrl}/api/v2/apitoken/serviceaccount/${serviceAccountId}" \
#   -H 'accept: application/json' \
#   -H 'Content-Type: application/json' \
#   -H "Authorization: bearer XXX"
api_token="myapitoken"

echo "
kind: ResourceList
items:
- kind: Secret
  apiVersion: v1
  metadata:
    name: wavefront-secret
  data:
    token: $(echo -n $api_token | base64)
"