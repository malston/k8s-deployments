#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Generate a GPG/OpenPGP key with no passphrase (%no-protection):

export KEY_NAME="dev.markalston.net"
export KEY_COMMENT="flux secrets"

gpg --batch --full-generate-key <<EOF
%no-protection
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Expire-Date: 0
Name-Comment: ${KEY_COMMENT}
Name-Real: ${KEY_NAME}
EOF

# The above configuration creates an rsa4096 key that does not expire. For a full list of options to consider for your environment, see Unattended GPG key generation.

# Retrieve the GPG key fingerprint (second row of the sec column) and store the key fingerprint as an environment variable:

KEY_FP=$(gpg --list-secret-keys "${KEY_NAME}" | grep 'sec   rsa4096' -A1 | tail -1 | awk '{$1=$1};1')

# Export the public and private keypair from your local GPG keyring and create a Kubernetes secret named sops-gpg in the flux-system namespace:

gpg --export-secret-keys --armor "${KEY_FP}" | \
  kubectl create secret generic sops-gpg \
    --namespace=flux-system \
    --from-file=sops.asc=/dev/stdin

# It’s a good idea to back up this secret-key/K8s-Secret with a password manager or offline storage.
# Also consider deleting the secret decryption key from you machine:
# gpg --delete-secret-keys "${KEY_FP}"

