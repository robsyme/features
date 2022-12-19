#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Maintainer: Rob Syme

USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Determine the appropriate non-root user
echo "Before username check, username==$USERNAME"
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

if ! cat /etc/group | grep -e "^nftest:" > /dev/null 2>&1; then
    groupadd -r nftest
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

usermod -a -G nftest "${USERNAME}"

echo "Installing nf-test for user $USERNAME..."

NFTEST_DIR=/opt/nf-test
mkdir -p $NFTEST_DIR/bin
chown -R "${USERNAME}:nftest" "${NFTEST_DIR}"
chmod -R g+r+w "${NFTEST_DIR}"

cd $NFTEST_DIR/bin
curl -fsSL https://code.askimed.com/install/nf-test | bash
find "${NFTEST_DIR}" -type d -print0 | xargs -n 1 -0 chmod g+s

set -x 
if [[ $(id -u -n) != "${_REMOTE_USER}" ]]; then
    cp -R ~/.nf-test ${_REMOTE_USER_HOME}
    chown -R "${_REMOTE_USER}:${_REMOTE_USER}" "${_REMOTE_USER_HOME}/.nf-test"
fi
set +x

echo "Done!"