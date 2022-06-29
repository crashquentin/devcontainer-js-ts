#!/bin/bash

docker_scripts_dir="$(dirname $0)"

# Source
. .env
. $docker_scripts_dir/build.sh
. $docker_scripts_dir/run.sh

# Args
if [[ $# -eq 0 ]]; then
  echo "No arguments provided"
  exit 1
fi

"$1_$2"
