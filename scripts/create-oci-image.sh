#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

ORG=$1
TOKEN=$2

if [[ -z $ORG ]]; then
  echo -n "Enter docker org: "
  read -r ORG
fi

if [[ -z $TOKEN ]]; then
  echo -n "Enter docker personal access token: "
  read -r TOKEN
fi

kustomize build --enable-alpha-plugins --enable-exec ./infrastructure/observability-system > wavefront-operator.yaml

# Login by passing credentials directly
flux push artifact "oci://docker.io/${ORG}/wavefront-operator:$(git tag --points-at HEAD)" \
    --path=wavefront-operator.yaml \
    --source="$(git config --get remote.origin.url)" \
    --revision="$(git tag --points-at HEAD)@sha1:$(git rev-parse HEAD)" \
    --creds "${ORG}:${TOKEN}"
