#!/bin/bash
set -Eeuo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

OLDDIR="$DIR/backup/"             # old dotfiles backup directory
FILES="$DIR/files/*"

packages="zsh tmux source-highlight vim build-essential"             # packages to be installed

#TODO don't start zsh after installation
#TODO Also backup .conf folder?

place_dotfiles() {
    for source_path in $FILES; do
      file_path=${source_path#"$DIR/files/"}
      dest=~/."$file_path"
      if [ -L "${dest}" ] ; then
        if [ -e "${dest}" ] ; then
          # Good link
          echo "${dest} already exists, doing nothing"
        else
          # Broken link
          rm "${dest}"
          ln -s "$source_path" "$dest"
        fi
      elif [ -e "${dest}" ] ; then
        # Not a link
        mv --backup=numbered ~/."$file_path" "$OLDDIR"
        ln -s "$source_path" "$dest"
      else
        # Missing
        ln -s "$source_path" "$dest"
      fi


    done
}

install_packages () {
    sudo apt-get update
    for package in $packages; do
      sudo apt install -y "${package}"
    done
}

install_vim_plugins () {
  if [[ ! -d ~/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
  vim +PluginInstall +qall
  # TODO install vim plugins, mainly command T, which requires ruby make
  # TODO also install code formaters, pylint
}

install_antigen () {
  if [ ! -d ~/.antigen/antigen.zsh ]; then
    mkdir ~/.antigen
    curl -L git.io/antigen > ~/.antigen/antigen.zsh
  fi
}

install_fzf () {
  if [ ! -d ~/.fzf ]; then
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install --bin
  fi
}

setup_tmux_plugins () {
    if [ ! -d  ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}

set_zsh_default () {
  chsh -s "$(which zsh)"
}

set_locale () {
    export LANGUAGE=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LC_CTYPE="en_US.UTF-8"
    locale-gen en_US.UTF-8
    sudo dpkg-reconfigure locales
}

install_patched_fonts () {
    git clone https://github.com/powerline/fonts.git /tmp/fonts --depth=1
    pushd /tmp/fonts
    ./install.sh
    popd
}

install_packages
place_dotfiles
install_antigen
install_fzf
install_vim_plugins
setup_tmux_plugins
set_zsh_default
# install_patched_fonts