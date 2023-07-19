#!/usr/bin/env bash

set -o errexit
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

GITHUB_USER="${1:-$GITHUB_USER}"
GITHUB_REPO="${2:-k8s-deployments}"
KUBECTX="${3:-"$(kubectl config view -o jsonpath='{.current-context}')"}"

if [[ -z $GITHUB_USER ]]; then
  echo -n "Enter your github username: "
  read -r GITHUB_USER
fi

mkdir -p "${__DIR}/../clusters/development"

flux bootstrap github \
    --context="${KUBECTX}" \
    --owner="${GITHUB_USER}" \
    --repository="${GITHUB_REPO}" \
    --branch=main \
    --personal \
    --path="clusters/development/cluster01"
