#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Maintainer: Rob Syme

USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"
NEXTFLOW_DIR=/opt/nextflow
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

if ! cat /etc/group | grep -e "^nextflow:" > /dev/null 2>&1; then
    groupadd -r nextflow
fi

apt_get_update()
{
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

check_packages curl ca-certificates zip unzip sed default-jdk

usermod -a -G nextflow "${USERNAME}"

echo "Installing Nextflow..."

mkdir -p $NEXTFLOW_DIR/bin
cd $NEXTFLOW_DIR/bin
curl -s https://get.nextflow.io | bash

chown -R "${USERNAME}:nextflow" "${NEXTFLOW_DIR}"
chmod -R g+r+w "${NEXTFLOW_DIR}"

find "${NEXTFLOW_DIR}" -type d -print0 | xargs -n 1 -0 chmod g+s

set -x 
if [[ $(id -u -n) != "${_REMOTE_USER}" ]]; then
    chown -R "${_REMOTE_USER}:${_REMOTE_USER}" "${_REMOTE_USER_HOME}/.nextflow"
fi
set +x


echo "Done!"
