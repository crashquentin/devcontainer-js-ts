#!/bin/bash
# ~/.local/scripts/bootstrap-base.sh
# Bootstrap base environment
################################################################################

set -e

_default_packages="
apt-utils,
openssh-client,
gnupg2,
dirmngr,
iproute2,
lsof,
sudo,
rsync,
ninja-build,
neovim,
gettext,
libtool,
dpkg,
libtool-bin,
libc6,
strace,
autoconf,
automake,
cmake,
make,
software-properties-common,
g++,
pkg-config,
zip,
unzip,
ca-certificates,
less,
curl,
wget,
doxygen,
build-essential,
git,
tree,
ripgrep,
fzf,
fd-find,
jq,
fontconfig,
golang,
htop,
glances,
zsh,
lsb-release,
apt-transport-https,
locales,
manpages,
manpages-dev,
net-tools,
pip
"

# If environment var `BASE_PACKAGES` does NOT EXIST, set defaults
# [[ -z "${BASE_PACKAGES}" ]] && BASE_PACKAGES=$default_packages
_packages="${BASE_PACKAGES:-$_default_packages}"

function transform_packages_str() {
  _tr_newlines=$(tr '\n' ' ' <<<"$_packages") # transform newlines to spaces
  _tr_commas=$(tr ',' ' ' <<<"$_tr_newlines") # transform commas to spaces
  packages_arr=($_tr_commas) # convert to array
}


# Transform packages string to array
transform_packages_str

echo "Installing packages: ${packages_arr[@]}"

# Suppress interactive prompts
# Update apt cache
# Install packages
# Set locale to en_US.UTF-8
export DEBIAN_FRONTEND=noninteractive \
&& apt update -y \
&& apt install -y ${packages_arr[@]} \
&& locale-gen en_US.UTF-8 \
&& apt-get autoremove -y \
&& apt-get clean -y

list_path="${PRINT_PACKAGES_LIST:-/usr/local/share/base_packages.txt}"

echo "$_packages" > "$list_path"
