#!/bin/bash
# scripts/bootstrap/bootstrap-user-space.sh
# Bootstrap user environment
################################################################################

set -e

PLATFORM=""


# Platform detection
#########
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      PLATFORM="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
      PLATFORM="macos"
elif [[ "$OSTYPE" == "cygwin" ]]; then
      # POSIX compatibility layer and Linux environment emulation for Windows
      PLATFORM="windows-cygwin"
elif [[ "$OSTYPE" == "msys" ]]; then
      # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
      PLATFORM="windows-msys"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
      PLATFORM="freebsd"
else
      PLATFORM="unknown"
fi

# Dotfiles
# If the dotfiles repo is not cloned, clone it
#########
DOTFILES_REPO="https://github.com/crashquentin/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
[[ -d "$DOTFILES_DIR" ]] || git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
# Run script in the dotfiles repo
bash $DOTFILES_DIR/dotfiles sync

# Source environment variables
#########
source $HOME/.profile
source $HOME/.zshenv

# Make directories if they do not exist
#########
mkdir -p ${XDG_CONFIG_HOME:-"$HOME/.config"}
mkdir -p ${XDG_CACHE_HOME:-"$HOME/.cache"}
mkdir -p ${XDG_DATA_HOME:-"$HOME/.local/share"}
mkdir -p ${XDG_BIN_HOME:-"$HOME/.local/bin"}
mkdir -p ${XDG_WORKSPACE_HOME:-"$HOME/workspace"}
mkdir -p ${ZSH_CUSTOM:-"$HOME/.config/zsh/custom"}
mkdir -p $ZSH_CUSTOM/plugins

# Oh-My-ZSH
#
# If the zsh repo is not cloned, clone it
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended # Install oh-my-zsh unattended and overwrite existing ~/.zshrc
#
# If the zsh repo is not cloned and a ~/.zshrc exists, clone and dont overwrite ~/.zshrc
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc # Install oh-my-zsh unattended and keep ~/.zshrc
#
#########
# Install oh-my-zsh unattended and keep ~/.zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc 
# Install ZSH plugins
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
# Install ZSH prompt
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# This isn't really necessary. More as a lookup.
#########
ln -s $(which fdfind) $XDG_BIN_HOME/fd
ln -s $(which fzf) $XDG_BIN_HOME/fzf
ln -s $(which rg) $XDG_BIN_HOME/rg
ln -s $(which glances) $XDG_BIN_HOME/glances

# Fonts
#########
__fonts="$XDG_DATA_HOME/fonts"
mkdir -p "$__fonts"
curl -fLo "$__fonts/Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf &&
  wget "https://github.com/ryanoasis/nerd-fonts/raw/master/src/glyphs/powerline-symbols/PowerlineSymbols.otf" -O "$__fonts/PowerlineSymbols.otf" &&
  wget "https://github.com/ryanoasis/nerd-fonts/raw/master/src/glyphs/font-awesome/FontAwesome.otf" -O "$__fonts/FontAwesome.otf" &&
  wget "https://github.com/ryanoasis/nerd-fonts/raw/master/src/glyphs/devicons.ttf" -O "$__fonts/devicons.ttf" &&
  fc-cache -f -v


# Rust
#########
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y # Install Rust unattended
# . "$HOME/.cargo/env"                                                    # Load rust environment

# NVM
#########
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash # Install nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install --lts                                # Install latest LTS node version
# curl -o- -L https://yarnpkg.com/install.sh | bash # Install yarn via script
npm install -g yarn # Install yarn via npm

# Some oppinonated tools 
#############
# FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

# Neovim LTS 
neovim_dir=${XDG_DATA_HOME:-"$HOME/.local/share"}/neovim
if [[ "$PLATFORM" == "linux" ]]; then
  mkdir -p $neovim_dir
  wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O "$neovim_dir/nvim.appimage"
  chmod u+x "$neovim_dir/nvim.appimage"
  cd $neovim_dir
  "$neovim_dir/nvim.appimage" --appimage-extract
  "$neovim_dir/squashfs-root/AppRun" --version
  ln -s "$neovim_dir/squashfs-root/AppRun" "$XDG_BIN_HOME/nvim"
elif [[ "$PLATFORM" == "macos" ]]; then
    brew install neovim
else
  echo "Neovim not installed because platform is not supported"
fi

# Overwrite any changes to the zsh environment from installs
cd $HOME
bash $DOTFILES_DIR/dotfiles sync

# Source environment variables
source ~/.profile

# Lunarvim
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -- -y
