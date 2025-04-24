#!/bin/bash --login

# Create a new user.

# Make bashline configurations.
set -e
RESET='\033[0m'
COLOR='\033[1;32m'
COLOR_ERR='\033[1;31m'

function msg {
  echo -e "${COLOR}$(date): $1${RESET}"
}

function msg_err {
  echo -e "${COLOR_ERR}$(date): $1${RESET}"
}

function fail {
  msg_err "Error : $?"
  exit 1
}

function mcd {
  mkdir -p "$1" || fail
  cd "$1" || fail
}

function nvm_has {
  type "$1" > /dev/null 2>&1
}

NEW_USER=codeuser

# Pass options from command line
for ARGUMENT in "$@"
do
  KEY=$(echo $ARGUMENT | cut -f1 -d=)
  if [[ $KEY != '--*' ]]
  then
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)
  fi
  case "$KEY" in
    user)           NEW_USER="${VALUE}" ;;
    *)
  esac
done

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

APT_OPTIONS="-o Acquire::Retries=5 -o Acquire::http::timeout=20 -o Acquire::https::timeout=20"

cd "$SCRIPTPATH" || fail
msg "Create user ${NEW_USER} ..."
apt-get update || fail
apt-get ${APT_OPTIONS} install -y apt-utils wget curl sudo || fail

useradd -ms /bin/bash ${NEW_USER} || fail # Add the user
passwd -d ${NEW_USER} || fail # Delete the password
usermod -a -G sudo ${NEW_USER} || fail # Make the user admin

if [ "x${LANG}" = "x" ]; then
  LANG="en_US.UTF-8"
fi

LANG_NAME="en_US"
LANG_ENC="UTF-8"
if [[ "${LANG}" == *"."* ]]; then
  LANG_NAME="$( cut -d '.' -f 1 <<< "${LANG}" )"
  LANG_ENC="$( cut -d '.' -f 2 <<< "${LANG}" )"
else
  if [ "x${LANG}" != "x" ]; then
    LANG_NAME="${LANG}"
  fi
fi

msg "Move files to /etc"
echo "LC_ALL=${LANG_NAME}.${LANG_ENC}" >> /etc/environment
echo "${LANG_NAME} ${LANG_ENC}" >> /etc/locale.gen
echo "LANG=${LANG_NAME}.${LANG_ENC}" > /etc/locale.conf
if [ "x${LANG_NAME}" = "xen_US" ] && [ "x${LANG_ENC}" = "xUTF-8" ]; then
  cp -f ${SCRIPTPATH}/etc/locale.gen /etc/locale.gen || fail
fi
if [ "x${LANG_NAME}" = "xzh_CN" ] && [ "x${LANG_ENC}" = "xUTF-8" ]; then
  cp -f ${SCRIPTPATH}/etc/locale-zh_CN.gen /etc/locale.gen || fail
fi
cp -f ${SCRIPTPATH}/etc/sudoers /etc || fail

# Setting language
apt-get ${APT_OPTIONS} install -y locales || fail
locale-gen ${LANG_NAME}.${LANG_ENC}
