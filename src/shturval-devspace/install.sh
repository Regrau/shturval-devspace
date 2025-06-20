#!/bin/sh
set -e

echo "Activating feature shturval-devspace"

STC_VERSION=${STC_VERSION:-undefined}
echo "Shturval will be installed with version: $STC_VERSION"

# The 'install.sh' entrypoint script is always executed as the root user.
#
# These following environment variables are passed in by the dev container CLI.
# These may be useful in instances where the context of the final 
# remoteUser or containerUser is useful.
# For more details, see https://containers.dev/implementors/features#user-env-var
echo "The effective dev container remoteUser is '$_REMOTE_USER'"
echo "The effective dev container remoteUser's home directory is '$_REMOTE_USER_HOME'"

echo "The effective dev container containerUser is '$_CONTAINER_USER'"
echo "The effective dev container containerUser's home directory is '$_CONTAINER_USER_HOME'"


curl -L https://public.shturval.tech/stc-$STC_VERSION -o /usr/local/bin/stc
chmod +x /usr/local/bin/stc

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
su $_REMOTE_USER -c "helm repo add shturval https://r.shturval.tech/repository/shturval_helm"

curl -L https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl

su $_REMOTE_USER -c  "cat 'source <(command kubectl completion zsh)' >> /home/$_REMOTE_USER/.zshrc"
