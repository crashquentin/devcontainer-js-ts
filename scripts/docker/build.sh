#!/bin/bash
# docker/build.sh
# Build docker images for dev environment.
################################################################################

# ARGS
HOME_DIR=/home/$USERNAME
DOCKER_CONTEXT="$(pwd)"
docker_files_path="$(pwd)/docker"

# Common build options
common_build_opts="\
--build-arg USER_UID=$USER_UID \
--build-arg USER_GID=$USER_GID \
--build-arg USERNAME=$USERNAME \
--build-arg HOME_DIR=$HOME_DIR \
--no-cache"

# Build base
build_base() {
  local DOCKERFILE_PATH="${DOCKER_CONTEXT}/docker/base.Dockerfile"

  local base_packages="$(echo $BASE_PACKAGES | tr '\n' ' ' | tr '\t' ' ')"
  echo "Installing packages: $base_packages"

  local build_opts="$common_build_opts \
  --build-arg USER_PASSWORD=$USER_PASSWORD"

  local vals_str="$build_opts \
  -t ${BASE_DOCKER_TAG} \
  -f ${DOCKERFILE_PATH} \
  ${DOCKER_CONTEXT}"

  local vals="$(echo $vals_str | tr '\n' ' ' | tr '\t' ' ')"

  printf "\nDocker build command:\ndocker build --build-arg BASE_PACKAGES=%s%s\n\n" "$base_packages" "$vals"
  # Build arg BASE_PACKAGES is seperate because it needs to be one string
  docker build \
  --build-arg BASE_PACKAGES="$base_packages" \
  $vals
}

# Build user dev space
build_dev() {
  local DOCKERFILE_PATH="${DOCKER_CONTEXT}/docker/user.Dockerfile"

  docker build \
    $common_build_opts \
    -t ${DEV_DOCKER_TAG} \
    -f ${DOCKERFILE_PATH} \
    ${DOCKER_CONTEXT}
}

build_all() {
  build_base
  build_dev
}
