#!/bin/bash

# Install dependencies for the Docker Image.

# Make bashline configurations.
set -e
RESET='\033[0m'
COLOR='\033[1;32m'
COLOR_WARN='\033[1;33m'
COLOR_ERR='\033[1;31m'

function msg {
  echo -e "${COLOR}$(date): $1${RESET}"
}

function msg_warn {
  echo -e "${COLOR_WARN}$(date): $1${RESET}"
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

INSTALL_MODE=$1

APT_OPTIONS="-o Acquire::Retries=5 -o Acquire::http::timeout=20 -o Acquire::https::timeout=20"

# Required packages
apt-get -y update || fail && apt-get $APT_OPTIONS -y install apt-utils \
apt-transport-https wget curl jq gnupg2 lsb-release xz-utils \
python3-yaml git-core sudo argon2 || fail

if ! nvm_has "lsb_release"; then
  msg_err "lsb_release does not exist. This should not happen. Please contact the author for technical supports."
  exit 1
fi

# Check the OS version
NAME_OS=$(lsb_release -is)
VER_OS=$(lsb_release -rs)
VERNAME_OS="$(echo $(lsb_release -cs) | tr '[:upper:]' '[:lower:]')"
if [ "x${NAME_OS}" = "xDebian" ]; then
  msg "Pass the OS check. Current OS: ${NAME_OS}."
else
  msg_err "The base image is not Debian OS, this dockerfile does not support it: ${NAME_OS}."
  exit 1
fi
if [ "x${VER_OS}" = "x12" ] || [ "x${VER_OS}" = "x11" ]; then
  msg "Pass the version check. Current version: ${VER_OS}."
else
  if [ "x${VERNAME_OS}" = "xtrixie" ]; then
    msg "Pass the version check. Current named version: ${VERNAME_OS}."
  else
    msg_err "The Debian version is not supported: ${VER_OS}, version name: ${VERNAME_OS}."
    exit 1
  fi
fi

if ! nvm_has "python3"; then
  if ! nvm_has "python"; then
    msg_err "Python supposes to be installed but is not found. This should not happen. Please contact the author for technical supports."
    exit 1
  fi
fi

if ! nvm_has "latex"; then
  msg_warn "LaTeX is not installed, try to install TeXLive by apt."
  apt-get $APT_OPTIONS -y install texlive || fail
fi

if [ "x${INSTALL_MODE}" = "xdev2" ]
then
  apt-get $APT_OPTIONS -y upgrade || fail
  apt-get -y update -qq || fail && apt-get $APT_OPTIONS -y install \
  autoconf automake build-essential cmake procps \
  libtool pkg-config zlib1g-dev python3-pip || fail
  
  msg "Successfully install the optional dependencies by APT (Level 2)."
elif [ "x${INSTALL_MODE}" = "xdev1" ]
then
  apt-get $APT_OPTIONS -y install build-essential cmake procps \
  pkg-config zlib1g-dev python3-pip || fail
  
  msg "Successfully install the optional dependencies by APT (Level 1)."
elif [ "x${INSTALL_MODE}" = "xdev" ]
then
  apt-get $APT_OPTIONS -y install procps || fail
  
  msg "Successfully install the developer's dependencies by APT (Level 0)."
else
  msg "Skip the optional apt dependencies."
fi

apt-get -y update || fail && apt-get $APT_OPTIONS -y upgrade || fail \
&& apt-get $APT_OPTIONS -y dist-upgrade || fail && apt-get -y autoremove || fail \
&& apt-get -y autoclean || fail

msg "Successfully install the pre-requisite dependencies."
