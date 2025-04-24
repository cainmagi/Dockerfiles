#!/bin/bash --login

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

INSTALL_MODE=default
INSTALL_OS=debian
CODE_SOURCE=auto

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
    code-src)       CODE_SOURCE="${VALUE}" ;;
    *)
  esac
done

# Check existence of python
if nvm_has "python"; then
  PYTHON=python
else
  if nvm_has "python3"; then
    PYTHON=python3
  else
    msg_err "Fail to find Python3 in the image, stop the running."
    exit 1
  fi
fi

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

cd "$SCRIPTPATH" || fail
msg "Create the VSCode config file."
cp ./config.yaml ~/code-config.yaml || fail

msg "Install VSCode extensions."
cd "$SCRIPTPATH" || fail
if [ -f "extensions.txt" ]; then
  bash ./install-vscode.sh "extensions.txt" "${CODE_SOURCE}" || fail
else
  msg_warn "Skip the installation of VSCode extensions."
fi

LANG_NAME="en_US"
if [[ "${LANG}" == *"."* ]]; then
  LANG_NAME="$( cut -d '.' -f 1 <<< "${LANG}" )"
else
  if [ "x${LANG}" != "x" ]; then
    LANG_NAME="${LANG}"
  fi
fi

if [ "x${LANG_NAME}" = "xzh_CN" ]; then
  msg "Install VSCode extensions (zh_CN)."
  cd "$SCRIPTPATH" || fail
  if [ -f "extensions.txt" ]; then
    bash ./install-vscode.sh "extensions-zh_CN.txt" "${CODE_SOURCE}" || fail
  else
    msg_warn "Skip the installation of VSCode extensions (zh_CN)."
  fi
fi
