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

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
SOURCE_ROOT=/opt
cd $SOURCE_ROOT || fail

APT_OPTIONS="-o Acquire::Retries=5 -o Acquire::http::timeout=20 -o Acquire::https::timeout=20"

# Check existence of python
if nvm_has "python"; then
    PYTHON=python
else
    if nvm_has "python3"; then
        PYTHON=python3
    else
        msgerr "Fail to find Python3 in the image, stop the running."
        exit 1
    fi
fi

msg "Get APT packages..."
apt-get update || fail
apt-get install $APT_OPTIONS -y apt-utils apt-transport-https git-core wget unzip gnupg2 lsb-release ccache || fail

msg "Install PIP dependencies..."
cd "$SCRIPTPATH" || fail
${PYTHON} -m pip install -r requirements.txt || fail

msg "Get Deformable DETR..."
cd "$SOURCE_ROOT" || fail
if [ ! -d "deformable_detr" ]; then
  git clone --branch main --single-branch --depth 1 https://github.com/fundamentalvision/Deformable-DETR.git deformable_detr || fail
  cd deformable_detr || fail
else
  cd deformable_detr || fail
  git pull || fail
fi

msg "Preconfigure Deformable DETR..."
cd "$SOURCE_ROOT/deformable_detr/models/ops" || fail
cp "$SCRIPTPATH/test-lite.py" "./test-lite.py" || fail
cp "$SCRIPTPATH/build.py" "$SOURCE_ROOT/deformable_detr/build.sh" || fail
