#!/bin/bash --login

# Make bashline configurations.
set -e
RESET='\033[0m'
COLOR='\033[1;32m'

function msg {
  echo -e "${COLOR}$(date): $1${RESET}"
}

function fail {
  msg "Error : $?"
  exit 1
}

function mcd {
  mkdir -p "$1" || fail
  cd "$1" || fail
}

function nvm_has {
  type "$1" > /dev/null 2>&1
}

INSTALL_MODE=default
INSTALL_OS=debian
NAME_CUDA_TOOLKIT=cuda-toolkit

# Pass options from command line
for ARGUMENT in "$@"
do
  KEY=$(echo $ARGUMENT | cut -f1 -d=)
  if [[ $KEY != '--*' ]]
  then
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)
  fi
  case "$KEY" in
    mode)           INSTALL_MODE="${VALUE}" ;;
    os)             INSTALL_OS="${VALUE}" ;;
    cuda)           NAME_CUDA_TOOLKIT="${VALUE}" ;;
    *)
  esac
done

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

cd "$SCRIPTPATH" || fail
if [ "x${INSTALL_OS}" = "xdebian" ]; then
  bash ./install-debian.sh $INSTALL_MODE $NAME_CUDA_TOOLKIT
else
  msg_err "The specified OS is not supported: ${NAME_OS}."
fi
