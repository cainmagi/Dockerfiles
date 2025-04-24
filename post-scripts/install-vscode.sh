#!/bin/bash

# Install VSCode extensions.

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
  if [ -f "ext.vsix" ]; then
    rm -f "ext.vsix"
  fi
  exit 1
}

function mcd {
  mkdir -p "$1" || fail
  cd "$1" || fail
}

function nvm_has {
  type "$1" > /dev/null 2>&1
}

if [ $# -lt 1 ]; then
  msg_err "Usage: $0 <extension-list-file> [<vsx-source>]"
  exit 1
fi

EXT_LIST=$1

VSCODE=""
if nvm_has "code-server"; then
  VSCODE="code-server"
else
  if nvm_has "code"; then
    VSCODE="code"
  else
    msg_err "Need to have either VSCode-Server or VSCode installed."
    exit 1
  fi
fi

VSIX_SOURCE="auto"
if [ $# -gt 1 ]; then
  VSIX_SOURCE=$2
fi

# Function to process each line
function install_extension {
  local name=""
  local version="latest"
  local stable=""
  local source="default"
  if [[ "$1" == *"="* ]]; then
    name="$( cut -d '=' -f 1 <<< "$1" )"
    version="$( cut -d '=' -f 2 <<< "$1" )"
  else
    name="$1"
  fi
  if [ $# -gt 1 ]; then
    source="$2"
  fi
  if [ "x${source}" != "xmarket" ]; then
    source="default"
  fi
  if [ "x${source}" = "xmarket" ]; then
    if [ $# -gt 2 ]; then
      stable="$3"
    fi
    if [ "x${stable}" != "xstable" ]; then
      stable=""
    fi
    if [ "x${version}" = "x" ]; then
      version="latest"
    fi
    if [ "x${version}" = "xlatest" ]; then
      if [ "x${stable}" = "x" ]; then
        version=$(curl -s -X POST 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery' \
          -H 'Content-Type: application/json' \
          -H 'Accept: application/json;api-version=6.1-preview.1' \
          --data-raw '{"filters":[{"criteria":[{"filterType":7,"value":"'"${name}"'"},{"filterType":12,"value":"4096"}]}],"flags":513}' \
          | jq -r '.results[0].extensions[0].versions[] | select(.version | test("insider") | not) | .version' \
          | head -n 1 | sed 's/"//g'\
        )
      else
        # Try to get the stable version
        version=$(curl -s -X POST 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery' \
          -H 'Content-Type: application/json' \
          -H 'Accept: application/json;api-version=6.1-preview.1' \
          --data-raw '{"filters":[{"criteria":[{"filterType":7,"value":"'"${name}"'"},{"filterType":12,"value":"4096"}]}],"flags":103}' \
          | jq -r '.results[0].extensions[0].versions[] | select(.version | test("^[0-9]+\\.[0-9]+\\.[0-9]{1,4}$")) | .version' \
          | head -n 1 | sed 's/"//g'
        )
      fi
    fi
    if [ "x${version}" = "xnull" ] || [ "x${version}" = "x" ]; then
      version="latest"
    fi
    if [ "x${stable}" = "x" ]; then
      msg "Installing the extension: $name, version: $version"
    else
      msg "Installing the extension (stable): $name, version: $version"
    fi
    local code_org="$( cut -d '.' -f 1 <<< "$name" )"
    local code_name="$( cut -d '.' -f 2 <<< "$name" )"
    wget -qO- "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${code_org}/vsextensions/${code_name}/${version}/vspackage" | gzip -d > ext.vsix
    ${VSCODE} --install-extension "./ext.vsix" || return 1
    rm -f "ext.vsix"
  else
    msg "Installing the extension (open-vsx): $name"
    ${VSCODE} --install-extension "$name"
  fi
}

# Check if the ext list exists
if [ ! -f "${EXT_LIST}" ]; then
  msg_warn "The list of extension is not found, skip installing extensions: ${EXT_LIST}"
  exit
fi

# Read the ext list line by line
while IFS= read -r name || [ -n "${name}" ]; do
  # Skip empty lines
  if [ -z "${name}" ]; then
    continue
  fi
  # Skip lines starting with "#" (comment)
  if [[ "${name}" == \#* ]]; then
    continue
  fi
  if [ "x${VSIX_SOURCE}" = "xauto" ]; then
    if ! install_extension "${name}"; then
      msg_warn "Fail to install the access open-vsx. Try to install ${name} by market."
      if ! install_extension "${name}" "market"; then
        msg_warn "Fail to install the newest version. Try to install ${name} in the stable mode."
        install_extension "${name}" "market" "stable" || fail
      fi
    fi
  else
    if [ "x${VSIX_SOURCE}" = "xmarket" ]; then
      if ! install_extension "${name}" "market"; then
        msg_warn "Fail to install the newest version. Try to install ${name} in the stable mode."
        install_extension "${name}" "market" "stable" || fail
      fi
    else
      install_extension "${name}" || fail
    fi
  fi
  if [ -f "ext.vsix" ]; then
    rm -f "ext.vsix"
  fi
done < "${EXT_LIST}"
