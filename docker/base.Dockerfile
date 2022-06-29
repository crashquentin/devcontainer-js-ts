# base.Dockerfile builds the base image for devcontainer.
####################

FROM ubuntu:latest

# Args
ARG USERNAME
ARG USER_PASSWORD
ARG USER_UID
ARG USER_GID
ARG BASE_PACKAGES
ARG HOME_DIR=/home/$USERNAME
ARG BOOTSTRAP_PATH=/.bootstrap-base.sh

COPY --chown="${USER_UID}:${USER_GID}" scripts/bootstrap/bootstrap-base.sh $BOOTSTRAP_PATH

# Install base packages, create group, and user
RUN \
  export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && BASE_PACKAGES="${BASE_PACKAGES}" bash ${BOOTSTRAP_PATH} \
  && groupadd --gid ${USER_GID} ${USERNAME} \
  && useradd \
  --system \
  --create-home \
  --home-dir ${HOME_DIR} \
  --shell /bin/zsh \
  --gid ${USER_GID} \
  --groups root \
  --groups sudo \
  --uid ${USER_UID} \
  --password "$(openssl passwd -6 ${USER_PASSWORD})" \
  ${USERNAME}

