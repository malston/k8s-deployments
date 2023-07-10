#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

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