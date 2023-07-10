#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

GITHUB_USER=malston
GITHUB_REPO=k8s-deployments

mkdir -p "${__DIR}/../clusters/development"

flux bootstrap github \
    --context=kind-kind \
    --owner="${GITHUB_USER}" \
    --repository="${GITHUB_REPO}" \
    --branch=main \
    --personal \
    --path="clusters/development"
