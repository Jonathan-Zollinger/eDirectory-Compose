#!/bin/bash
# installs eDirectory as a container and instantiates it for idm-unit testing
#

#######################################
# prints error message with timestamp to stderr
#
# Globals:
#   None
# Arguments:
#   Error message string.
# Outputs:
#   Error message with timestamp
# Returns:
#   1
#######################################
err() {
  red='\033[0;31m'
  no_color='\033[0m' # No Color
  echo -e "${red}[ERROR $(date +'%Y-%m-%dT%H:%M:%S%z')] $*${no_color}" >&2
  return 1
}

#######################################
# unarchives eDirectory container image from provided tarball to the local directory. 
#
# Globals:
#   None
# Arguments:
#   tarball filepath 
# Outputs:
#   unarchived container content to the pwd. 
# Returns:
#   0 on success, non-zero on error
#######################################
unarchive_edirectory_tarball() {
  if [[ $# -ne 1 ]]; then
    err "expected 1 argument, received $#"
    return
  elif [[ ! -e $1 ]]; then
    err "No eDirectory tarball available."
    return
  elif [[ ! $(tar --version) ]]; then
    err "the tar command isn't executable. Is it installed and on PATH?"
    return
  fi
  tar -xf "$1" --strip-components=1 --exclude="*azure*" -C "${PWD}"
}

#######################################
# loads eDirectory image
#
# Arguments:
#   container tarball filepath 
#
# Outputs:
#   a new eDirectory image  
# Returns:
#   image repo and tag on success, non-zero on error
#######################################
build_edir_image() {
  if [[ ! $(docker --version) ]]; then
    err "docker isn't executable. Is it installed and on PATH? \n\tNOTE: This container will not work with podman"
  fi
  if [[ ! -e $1 ]]; then
    err "The provided file, '$1' doesn't exist."
    return
  fi

  dockerOutput=$(docker load -i "$1")
  if [[ $? ]]; then
    echo "${dockerOutput#Loaded image: }"
  fi
  return $?
}

#######################################
# build eDir container and initialize eDir server per global variables 
#
# Globals:
#   CONTAINER_NAME
#   SOURCE_IMAGE
#   IP_PORT
#   SERVER_CONTEXT
#   SERVER_NAME
#   TREENAME
#   LDAP_PORT
#   SSL_PORT
#   HTTP_PORT
#   HTTPS_PORT
#
# Outputs:
#   new eDirectory server container  
# Returns:
#   image repo and tag on success, non-zero on error#
build_edir_container() {
  declare -A global_variables=(
  ["CONTAINER_NAME"]=$CONTAINER_NAME
  ["SOURCE_IMAGE"]=$SOURCE_IMAGE
  ["IP"]=$IP
  ["NCP_PORT"]=$NCP_PORT
  ["SERVER_CONTEXT"]=$SERVER_CONTEXT
  ["SERVER_NAME"]=$SERVER_NAME
  ["TREENAME"]=$TREENAME
  ["ADMIN_DN"]=$ADMIN_DN
  ["ADMIN_SECRET"]=$ADMIN_SECRET
  ["LDAP_PORT"]=$LDAP_PORT
  ["SSL_PORT"]=$SSL_PORT
  ["HTTP_PORT"]=$HTTP_PORT
  ["HTTPS_PORT"]=$HTTPS_PORT
)
  for global_variable in "${!global_variables[@]}"; do
    if [[ -z "${global_variables[$global_variable]}" ]]; then
      err "the global variable '${global_variable}' is null." 
      return 1
    fi
  done

  docker run -d \
    --name "${CONTAINER_NAME}" \
    --stop-timeout 180 \
    --restart on-failure:5 \
    --memory=700M \
    --pids-limit=300 \
    --network=host \
    "${SOURCE_IMAGE}" \
      new \
      -t "${TREENAME}" \
      -a "${ADMIN_DN}" \
      -w "${ADMIN_SECRET}" \
      -n "${SERVER_CONTEXT}" \
      -S "${SERVER_NAME}" \
      -B "${IP}/${NCP_PORT}" \
      -o "${HTTP_PORT}" \
      -O "${HTTPS_PORT}" \
      -L "${LDAP_PORT}" \
      -l "${SSL_PORT}" \
      --configure-eba-now yes
}
