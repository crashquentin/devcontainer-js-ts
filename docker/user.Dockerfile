# user.Dockerfile builds the user space.
####################

FROM devcontainer:base

# ARGS
ARG USERNAME
ARG HOME_DIR
ARG USER_UID
ARG USER_GID

# Change user
USER ${USERNAME}

# Working directory on host
WORKDIR ${HOME_DIR}

# Copy script
ARG SCRIPT_PATH="/bootstrap-user-space.sh"

COPY --chown="${USER_UID}:${USER_GID}" scripts/bootstrap/bootstrap-user-space.sh $SCRIPT_PATH

# Bootstrap user space
RUN bash $SCRIPT_PATH
