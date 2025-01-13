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

msg "Build Deformable DETR..."

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

SOURCE_ROOT=/opt
cd "$SOURCE_ROOT/deformable_detr/models/ops" || fail
bash ./make.sh || fail
# unit test (should see all checking is True)
# Change the test, because it may fail due to the OOM issue. My device only has 16GB
# GPU memory, it will fails on 2048 channels.
${PYTHON} test-lite.py || fail
