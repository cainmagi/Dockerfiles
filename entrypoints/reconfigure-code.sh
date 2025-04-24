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

if nvm_has "python"; then
  PYTHON=python
else
  if nvm_has "python3"; then
    PYTHON=python3
  else
    PYTHON=""
  fi
fi

# Run the reconfigure of the Code Server.
if nvm_has "code-server"; then
  if [ "x${PYTHON}" != "x" ] && [ -f "${SCRIPTPATH}/reconfigure_code.py" ]; then
    msg "Configure VSCode."
    read -p "Provide the password to be hashed: " user_password
    HASHED_PASSWORD=$(echo -n "${user_password}" | argon2 codeserver -t 2 -m 16 -p 4 -l 24 -e)
    if [ ! -s "~/code-config.txt" ]; then
      touch ~/code-config.txt || fail
      echo "Code Config has been reconfigured." >> ~/code-config.txt
    fi
    ${PYTHON} "${SCRIPTPATH}/reconfigure_code.py" -p ~/code-config.yaml -vp "${HASHED_PASSWORD}" || fail
    
    read -p "Provide the Git user name: " GITUSER
    if [ "x${GITUSER}" != "x" ]; then
      msg "git config --global user.name ${GITUSER}"
      git config --global user.name ${GITUSER}|| fail
    fi
    
    read -p "Provide the Git email: " GITEMAIL
    if [ "x${GITUSER}" != "x" ]; then
      msg "git config --global user.email ${GITEMAIL}"
      git config --global user.email ${GITEMAIL}|| fail
    fi
    
    GITHUB_TOKEN=$(${PYTHON} "${SCRIPTPATH}/get_config_item.py" -p ~/code-config.yaml -k github-auth)
    if [ "x${GITHUB_TOKEN}" != "x" ]; then
      msg "git config --global credential.helper store"
      git config --global credential.helper store|| fail
      git config --global init.defaultBranch main|| fail
      msg "export GITHUB_TOKEN=${GITHUB_TOKEN}"
      echo "export GITHUB_TOKEN=${GITHUB_TOKEN}" >> ~/.bashrc
    fi
  fi
fi
