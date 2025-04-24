#!/bin/bash

# Scripts for user mapping.
# Thanks the work of
# https://gist.github.com/renzok/29c9e5744f1dffa392cf

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


HOST_UID=""
HOST_GID=""
USER_NAME="$(id -n -u)"
# Pass options from command line
for ARGUMENT in "$@"
do
  KEY=$(echo $ARGUMENT | cut -f1 -d=)
  VALUE=$(echo $ARGUMENT | cut -f2 -d=)
  case "$KEY" in
    uid)            HOST_UID=${VALUE} ;;
    gid)            HOST_GID=${VALUE} ;;
    *)
  esac
done

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

CUR_UID=$(id ${USER_NAME} -u)
CUR_GID=$(id ${USER_NAME} -g)

# UID is not changed.
if [ "x${CUR_UID}" = "x1000" ]; then
  CUR_UID="0"
fi
if [ -z "${HOST_UID}" ] || [ "x${HOST_UID}" = "x0" ] || [ "x${HOST_UID}" = "x${CUR_UID}" ]; then
  echo "Current UID is not changed." ; exit 0
fi

# GID is not changed.
if [ -z "${HOST_GID}" ] || [ "x${HOST_GID}" = "x0" ] || [ "x${HOST_GID}" = "x${CUR_GID}" ]; then
  HOST_GID=${CUR_UID}
fi

# reset user_?id to either new id or if empty old (still one of above
# might not be set)
USER_ID=${HOST_UID:=$CUR_UID}
USER_GID=${HOST_GID:=$CUR_GID}

LINE=$(grep -F ${USER_NAME} /etc/passwd)
# replace all ':' with a space and create array
array=( ${LINE//:/ } )

# home is 5th element
USER_HOME=${array[4]}

sed -i -e "s/^${USER_NAME}:\([^:]*\):[0-9]*:[0-9]*/${USER_NAME}:\1:${USER_ID}:${USER_GID}/"  /etc/passwd
sed -i -e "s/^${USER_NAME}:\([^:]*\):[0-9]*/${USER_NAME}:\1:${USER_GID}/"  /etc/group

chown -R ${USER_ID}:${USER_GID} ${USER_HOME}

# The following configuration will be used only when tigervnc is installed.
if nvm_has "tigervncpasswd"; then
  msg "Please reset VNC password."
  FILE_VNCPASSWD=${USER_HOME}/.vnc/passwd
  if [[ -f "${FILE_VNCPASSWD}" ]]; then
    echo "Find VNC password in ${FILE_VNCPASSWD}"
  else
    echo "Reset VNC password in ${FILE_VNCPASSWD}"
    sudo -i -u ${USER_NAME} tigervncpasswd ${FILE_VNCPASSWD}
    mkdir -p /root/.vnc/ || fail
    if $(sudo [ ! -s /root/.vnc/passwd ]); then
      cp -f ${FILE_VNCPASSWD} /root/.vnc/ || fail
    fi
  fi
fi

if nvm_has "python"; then
  PYTHON=python
else
  if nvm_has "python3"; then
    PYTHON=python3
  else
    PYTHON=""
  fi
fi

if [ -f "${SCRIPTPATH}/reconfigure-code.sh" ]; then
  bash --login "${SCRIPTPATH}/reconfigure-code.sh" || fail
fi

msg "Switch the account id to ${USER_ID}:${USER_GID}. Please commit the image by the following command and exit."
echo ""
echo "docker commit --change='CMD [\"\"]' $(hostname) <your-image-name>:<tag>"
echo ""

exec su - ${USER_NAME}
