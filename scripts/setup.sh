#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

GITHUB_USER=${1:-malston}
GITHUB_REPO=k8s-deployments
KUBE_CONTEXT=$(kubectl config current-context)

if [[ -z $GITHUB_USER ]]; then
  echo -n "Enter your github username: "
  read -r GITHUB_USER
fi

mkdir -p "${__DIR}/../clusters/development"

flux bootstrap github \
    --context="${KUBE_CONTEXT}" \
    --owner="${GITHUB_USER}" \
    --repository="${GITHUB_REPO}" \
    --branch=main \
    --personal \
    --path="clusters/development"
