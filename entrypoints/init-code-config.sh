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
msg "Configure VSCode."
if [ "x${PASSWORD}" != "x" ]; then
  HASHED_PASSWORD=$(echo -n "${PASSWORD}" | argon2 codeserver -t 2 -m 16 -p 4 -l 24 -e)
  ${PYTHON} "${SCRIPTPATH}/reconfigure_code.py" -p ~/code-config.yaml -vp ${HASHED_PASSWORD} -ni || fail
else
  ${PYTHON} "${SCRIPTPATH}/reconfigure_code.py" -p ~/code-config.yaml -ni || fail
fi

GITHUB_TOKEN=$(${PYTHON} "${SCRIPTPATH}/get_config_item.py" -p ~/code-config.yaml -k github-auth)

if [ "x${GITHUB_TOKEN}" != "x" ]; then
  msg "git config --global user.name $(id -n -u)"
  git config --global user.name $(id -n -u)
  # msg "git config --global user.email ${USER}@gmail.com"
  # git config --global user.email ${USER}@gmail.com
  msg "git config --global credential.helper store"
  git config --global credential.helper store
  git config --global init.defaultBranch main
  msg "export GITHUB_TOKEN=${GITHUB_TOKEN}"
  echo "export GITHUB_TOKEN=${GITHUB_TOKEN}" >> ~/.bashrc
fi
