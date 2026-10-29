#!/bin/bash
set -Eeuo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OLDDIR="$DIR/backup/"             # old dotfiles backup directory
FILE_DIR="$DIR/files"

LOCALES="en_US.UTF-8 nl_NL.UTF-8"

# packages to be installed
apt_packages="zsh tmux source-highlight vim python3-pip build-essential curl htop xclip direnv shellcheck bat pipx unzip"
brew_packages="tmux source-highlight vim htop xclip cmake shellcheck direnv herdr"
pip_packages="ranger-fm Pygments"

# Set Colors and print statemetns
if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
  NO_COLOR='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
else
  NO_COLOR='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
fi
function info () { echo -e "${GREEN}INFO: $1${NO_COLOR}";}
function warn () { echo -e "${YELLOW}WARN: $1${NO_COLOR}";}
function error () { echo -e "${RED}ERROR: $1${NO_COLOR}"; if [ "$2" != "false" ]; then exit 1;fi; }

# Scripts
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  MACHINE="debian"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  MACHINE="osx"
fi
UNAME=$(uname -m);
info "Machine type: $MACHINE"
info "Architecture: $UNAME"

install_packages () {
    if [ "$MACHINE" == "debian" ]; then
       info "Installing packages: ${PURPLE}$apt_packages"
      sudo apt-get update
      sudo apt install -y -q $apt_packages
    elif [ "$MACHINE" == "osx" ]; then 
      for formula in $brew_packages; do
        if brew ls --versions myformula > /dev/null; then
           info "Formula $formula is already installed."
        else
          brew install $formula
        fi
      done;
    fi
}

place_dotfiles() {
    info "Linking dotfiles"
    files="$(find $FILE_DIR -type f)"
    for source_path in $files; do
      file_path=${source_path#"$DIR/files/"} # use # to chop off beginning, % chop of end
      dest=~/."$file_path"
      dir="$(dirname $dest)"
      if [ -L "${dest}" ]; then
        if [ -e "${dest}" ]; then
          # Good link
          :
        else
          # Broken link
          rm "${dest}"
          ln -s "$source_path" "$dest"
        fi
      elif [ -e "${dest}" ]; then
        # Not a link
        mv --backup=numbered ~/."$file_path" "$OLDDIR"
        ln -s "$source_path" "$dest"
      else
        # Missing
        if [[ ! -d $dir ]]; then
          mkdir -p $dir
        fi
        ln -s "$source_path" "$dest"
      fi
    done
}

install_lsd () {
  if [[ ! -x "$(command -v lsd)" ]]; then
    info "Installing LSD"
    if [ "$MACHINE" == "debian" ]; then
      if [ "$UNAME" == "x86_64" ]; then
          wget https://github.com/lsd-rs/lsd/releases/download/v1.1.2/lsd-musl_1.1.2_amd64.deb -O /tmp/lsd.deb
      elif [ "$UNAME" == "aarch64" ]; then
          wget https://github.com/lsd-rs/lsd/releases/download/v1.1.2/lsd-musl_1.1.2_arm64.deb -O /tmp/lsd.deb
      fi
      sudo dpkg -i /tmp/lsd.deb
    elif [ $MACHINE == "osx" ]; then
      brew install lsd
    fi
  else
      info "LSD already installed"
  fi
}

install_pip_packages () {
  info "Installing pip packages: $pip_packages"
  pipx install $pip_packages
}

install_vim_plugins () {
  info "Installing VIM plugins"
  if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
  vim +PlugInstall +qall
  # TODO install vim plugins, mainly command T, which requires ruby make
  # TODO also install code formaters, pylint
}

install_ranger_plugins () {
  info "Installing ranger plugins"
  if [[ ! -d ~/.config/ranger/plugins/ranger_devicons ]]; then
    git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
  fi
}

install_antigen () {
  if [ ! -f ~/.antigen/antigen.zsh ]; then
    info "Installing antigen"
    mkdir ~/.antigen
    curl -L git.io/antigen > ~/.antigen/antigen.zsh
  else 
    info "Antigen already installed"
  fi
}

install_fzf () {
  if [ ! -d ~/.fzf ]; then
      info "Installing FZF"
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install --bin
  else 
    info "FZF already installed"
  fi
}

install_tmux_plugins () {
  info "Installing TMUX plugins"
  if [ ! -d  ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
  # tpm reads this from the tmux server's global environment (normally set by
  # tpm itself when tmux.conf is loaded), so it must be set in tmux, not the shell
  tmux start-server \; set-environment -g TMUX_PLUGIN_MANAGER_PATH ~/.tmux/plugins/
  bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}

set_zsh_default () {
  ZSH="$(which zsh)"
  if [[ "$(basename $SHELL)" != "$(basename $ZSH)" ]]; then
    info "Setting zsh as default shell"
    sudo chsh -s "$(which zsh)" "$USER"
  fi
}

set_locale () {
  if [ $MACHINE == "debian" ]; then
    sudo locale-gen $LOCALES
    sudo update-locale
  fi;
}

install_pyenv () {
    if [[ ! -d "$HOME/.pyenv" ]]; then 
        curl https://pyenv.run | bash
        #git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
    fi
}

install_neovim () {
  # Release builds: distro packages are too old for tinyvim (needs nvim 0.11+,
  # and nvim-treesitter needs a newer tree-sitter CLI than Debian ships)
  NVIM_VERSION="v0.12.6"
  TS_VERSION="v0.27.1"
  if [ "$MACHINE" == "debian" ]; then
    if [ "$UNAME" == "x86_64" ]; then
      nvim_tar="nvim-linux-x86_64"; nvim_sha="474430d53e6264f6d6dd18db42d6dc9df3a1b56ca9e88a325bbf860e1a811d87"
      ts_gz="tree-sitter-linux-x64.gz"; ts_sha="d01042f94ba3d6827ddc9788e235f75d8366431be42bdf90ade534d960c98b7d"
    elif [ "$UNAME" == "aarch64" ]; then
      nvim_tar="nvim-linux-arm64"; nvim_sha="8f1f64a0bdb97247034038c3823c6cbad5bdf9ecd5751b85494b71c3ee04c815"
      ts_gz="tree-sitter-linux-arm64.gz"; ts_sha="404be5d54a4955571c4067c21d4699660eab3a534cefb0659341b207f7139ec5"
    fi
    mkdir -p ~/.local/bin ~/.local/opt
    if [[ "$(~/.local/bin/nvim --version 2>/dev/null | head -1)" != "NVIM $NVIM_VERSION" ]]; then
      info "Installing neovim $NVIM_VERSION"
      wget -q "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/$nvim_tar.tar.gz" -O /tmp/nvim.tar.gz
      echo "$nvim_sha  /tmp/nvim.tar.gz" | sha256sum -c --quiet
      rm -rf ~/.local/opt/"$nvim_tar"
      tar -C ~/.local/opt -xzf /tmp/nvim.tar.gz
      ln -sfn ~/.local/opt/"$nvim_tar"/bin/nvim ~/.local/bin/nvim
    else
      info "Neovim $NVIM_VERSION already installed"
    fi
    if [[ "$(~/.local/bin/tree-sitter --version 2>/dev/null)" != "tree-sitter ${TS_VERSION#v}"* ]]; then
      info "Installing tree-sitter $TS_VERSION"
      wget -q "https://github.com/tree-sitter/tree-sitter/releases/download/$TS_VERSION/$ts_gz" -O /tmp/tree-sitter.gz
      echo "$ts_sha  /tmp/tree-sitter.gz" | sha256sum -c --quiet
      gunzip -c /tmp/tree-sitter.gz > /tmp/tree-sitter
      install -m 755 /tmp/tree-sitter ~/.local/bin/tree-sitter
    fi
  elif [ "$MACHINE" == "osx" ]; then
    brew install neovim tree-sitter-cli
  fi
}

install_neovim_plugins () {
  info "Installing neovim plugins"
  NVIM="$(command -v nvim || echo ~/.local/bin/nvim)"
  # restore = the plugin versions pinned in lazy-lock.json
  PATH=~/.local/bin:$PATH "$NVIM" --headless "+Lazy! restore" +qa
  PATH=~/.local/bin:$PATH "$NVIM" --headless \
    -c 'lua require("nvim-treesitter").install({ "lua", "luadoc", "printf", "vim", "vimdoc" }):wait(300000)' -c qa
  # MasonInstallAll reinstalls everything, so only run it once
  if [[ ! -d ~/.local/share/nvim/mason/bin ]]; then
    PATH=~/.local/bin:$PATH "$NVIM" --headless -c MasonInstallAll -c qa
  fi
}

#TODO: git settings
#TODO: asdf?
#TODO: nvm

set_locale
install_packages
# install_pip_packages
install_pyenv
place_dotfiles
install_antigen
install_fzf
install_vim_plugins
install_neovim
install_neovim_plugins
install_tmux_plugins
install_ranger_plugins
install_lsd
install_pyenv
set_zsh_default
