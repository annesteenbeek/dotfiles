#!/bin/bash
set -Eeuo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OLDDIR="$DIR/backup/"             # old dotfiles backup directory
FILE_DIR="$DIR/files"

LOCALES="en_US.UTF-8 nl_NL.UTF-8"

# packages to be installed
apt_packages="zsh tmux source-highlight vim python3-pip build-essential curl htop xclip direnv shellcheck bat"
brew_packages="tmux source-highlight vim htop xclip cmake shellcheck direnv"
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
info "Machine type: $MACHINE"

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
    UNAME=$(uname -m);
    if [ "$MACHINE" == "debian" ] && [ "$UNAME" == "x86_64" ]; then
      wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb -O /tmp/lsd.deb
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
  pip3 install $pip_packages
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

#TODO: git settings
#TODO: asdf?
#TODO: nvm
#TODO: neovim (config init, plugin install)

set_locale
install_packages
install_pip_packages
install_pyenv
place_dotfiles
install_antigen
install_fzf
install_vim_plugins
install_tmux_plugins
install_ranger_plugins
install_lsd
install_pyenv
set_zsh_default
