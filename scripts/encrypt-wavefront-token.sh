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

TOKEN=$1

if [[ -z $TOKEN ]]; then
  TOKEN=$(read_password "Enter wavefront api token: ")
fi

echo "$TOKEN" | sops -e /dev/stdin > "${__DIR}/../infrastructure/observability-system/token.encrypted"
