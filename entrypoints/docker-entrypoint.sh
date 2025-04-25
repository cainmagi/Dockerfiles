#!/bin/bash --login

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

HELP=false
VERSION=false
BASH=false
RECONFIG=false
USESSL=false
SET_UID=""
SET_GID=""
INARGS=()

# Pass options from command line
for ARGUMENT in "$@"
do
  KEY=$(echo $ARGUMENT | cut -f1 -d=)
  if [[ $KEY != '--*' ]]
  then
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)
  fi
  case "$KEY" in
    --help)         HELP=true ;;
    --version)      VERSION=true ;;
    --bash)         BASH=true ;;
    --reconfig)     RECONFIG=true ;;
    --usessl)       USESSL=true ;;
    uid)            SET_UID=${VALUE} ;;
    gid)            SET_GID=${VALUE} ;;
    *)              INARGS+=("${ARGUMENT}");;
  esac
done

CURRENT_PATH="$(pwd)"

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

CUR_UID=$(id "$(id -n -u)" -u)
if [ "x${CUR_UID}" = "x1000" ]; then
  CUR_UID="0"
fi
if [ ! -z "${SET_UID}" ] && [ "x${SET_UID}" != "x0" ] && [ "x${SET_UID}" != "x${CUR_UID}" ]; then
  msg "Remap the file ownership and the setup the VSCode configuration"
  cd ${SCRIPTPATH} || fail
  sudo bash ./user-mapping.sh uid=${SET_UID} gid=${SET_GID} username="$(id -n -u)" || fail
  exit 0
fi

cd ${CURRENT_PATH} || fail

if $BASH
then
  msg "Developer's environment of the Code Server with TeXLive."
  exec bash --login
  exit 0
fi

# Check existence of code
if nvm_has "code-server"; then
  VSCODE="code-server"
else
  msg_err "Fail to find Code Server in the image, stop the running."
  exit 1
fi

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

if $HELP
then
  echo "${VSCODE} --help"
  ${VSCODE} --help || fail
  exit 0
fi

if $VERSION
then
  echo "${VSCODE} --version"
  ${VSCODE} --version || fail
  exit 0
fi

if $RECONFIG
then
  msg "Attempt to reconfigure the Code Sever."
  if [ -f "${SCRIPTPATH}/reconfigure-code.sh" ]; then
    bash --login "${SCRIPTPATH}/reconfigure-code.sh" || fail
  fi
  msg "Has reconfigured, please commit the image and exit from this container."
  echo ""
  echo "docker commit --change='CMD [\"\"]' $(hostname) <your-image-name>:<tag>"
  echo ""
fi

TEST_PASSWORD=$(${PYTHON} "${SCRIPTPATH}/get_config_item.py" -p ~/code-config.yaml -k hashed-password)
if [ "x${TEST_PASSWORD}" = "x" ] && [ -f "${SCRIPTPATH}/reconfigure-code.sh" ]; then
  if [ ! -s "~/code-config.txt" ]; then
    bash --login "${SCRIPTPATH}/reconfigure-code.sh" || fail
  fi
fi

# GET GITTOKEN
if [ "x${GITHUB_TOKEN}" = "x" ]; then
  GITHUB_TOKEN=$(${PYTHON} "${SCRIPTPATH}/get_config_item.py" -p ~/code-config.yaml -k github-auth)
fi

msg "Run Code Server."

LANG_NAME="en_US"
if [[ "${LANG}" == *"."* ]]; then
  LANG_NAME="$( cut -d '.' -f 1 <<< "${LANG}" )"
else
  if [ "x${LANG}" != "x" ]; then
    LANG_NAME="${LANG}"
  fi
fi

FLAG_LANG=""
if [ "x${LANG_NAME}" = "xzh_CN" ]; then
  FLAG_LANG="--locale zh-cn"
fi

if ${USESSL} && [ ! -s "~/code-cert.pem" ]
then
  if [ -s "/codecerts/code-cert.pem" ]; then
    sudo cp -f /codecerts/cert.pem ~/code-cert.pem || fail
  else
    openssl req -new -x509 -days 365 -nodes -config /etc/ssl/code-server.cnf -out ~/code-cert.pem -keyout ~/code-cert.pem || fail
  fi
fi

FLAG_CERT=""
if ${USESSL} && [ -f "~/code-cert.pem" ]; then
  msg "USE SSL mode."
  FLAG_CERT="--cert ~/code-cert.pem --cert-key ~/code-cert.pem --cert-host localhost"
fi

if [ ${#INARGS[@]} -lt 1 ]; then
  echo "code-server ~"
  echo "GITHUB_TOKEN=${GITHUB_TOKEN} code-server ${FLAG_LANG} ${FLAG_CERT} --config ~/code-config.yaml ~" | bash
else
  echo "code-server ${INARGS[@]}"
  echo "GITHUB_TOKEN=${GITHUB_TOKEN} code-server ${FLAG_LANG} ${FLAG_CERT} --config ~/code-config.yaml ${INARGS[@]}" | bash
fi
