#!/usr/bin/env bash
# Copy images from ghcr.io to harbor 

set -o errexit
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

function read_password() {
  local prompt="$1"
  unset password
  while IFS= read -p "$prompt" -r -s -n 1 char; do
    if [[ $char == $'\0' ]]; then
      break
    fi
    prompt='*'
    password+="$char"
  done
  echo "$password"
}

if [[ -z $HARBOR_PASSWORD ]]; then
  HARBOR_PASSWORD=$(read_password "Enter harbor password: ")
  echo ""
fi

export HARBOR_USERNAME=admin
export HARBOR_HOSTNAME=harbor.markalston.net

echo "$HARBOR_PASSWORD" | skopeo login --username "$HARBOR_USERNAME" "$HARBOR_HOSTNAME" --password-stdin

skopeo --insecure-policy copy "docker://ghcr.io/fluxcd/helm-controller:v0.35.0" \
    "docker://$HARBOR_HOSTNAME/fluxcd/helm-controller:v0.35.0" \
    --dest-creds "${HARBOR_USERNAME}:${HARBOR_PASSWORD}"

skopeo --insecure-policy copy "docker://ghcr.io/fluxcd/kustomize-controller:v1.0.1" \
    "docker://$HARBOR_HOSTNAME/fluxcd/kustomize-controller:v1.0.1" \
    --dest-creds "${HARBOR_USERNAME}:${HARBOR_PASSWORD}"

skopeo --insecure-policy copy "docker://ghcr.io/fluxcd/notification-controller:v1.0.0" \
    "docker://$HARBOR_HOSTNAME/fluxcd/notification-controller:v1.0.0" \
    --dest-creds "${HARBOR_USERNAME}:${HARBOR_PASSWORD}"

skopeo --insecure-policy copy "docker://ghcr.io/fluxcd/source-controller:v1.0.1" \
    "docker://$HARBOR_HOSTNAME/fluxcd/source-controller:v1.0.1" \
    --dest-creds "${HARBOR_USERNAME}:${HARBOR_PASSWORD}"
