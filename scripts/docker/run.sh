# Run base image (devcontainer:base)
run_base() {
  docker run \
    --rm \
    --hostname machine \
    -it \
    devcontainer:base \
    /bin/bash
}

# Run dev image (devcontainer:dev)
run_dev() {
  docker run \
    --rm \
    -it \
    devcontainer:latest \
    /bin/zsh
}
