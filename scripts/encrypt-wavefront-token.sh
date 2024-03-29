#!/usr/bin/env bash

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

WAVEFRONT_TOKEN=$1

if [[ -z $WAVEFRONT_TOKEN ]]; then
  WAVEFRONT_TOKEN=$(read_password "Enter wavefront api token: ")
fi

KEY_NAME="dev.markalston.net"
KEY_FP=$(gpg --list-secret-keys "${KEY_NAME}" | grep 'sec   rsa4096' -A1 | tail -1 | awk '{$1=$1};1')
echo "$WAVEFRONT_TOKEN" | sops --pgp "$KEY_FP" -e /dev/stdin > "${__DIR}/../infrastructure/observability-system/token.encrypted"
