#!/bin/bash
set -Eeuo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

OLDDIR="$DIR/backup/"             # old dotfiles backup directory
FILE_DIR="$DIR/files"

packages="zsh tmux source-highlight vim python-pip build-essential"             # packages to be installed
pip_packages="ranger-fm Pygments"

place_dotfiles() {
    files="$(find $FILE_DIR -type f)"
    for source_path in $files; do
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

install_lsd () {
  if [[ "$(which lsd)" != "" ]]; then
    wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb /tmp/lsd.deb
    sudo dpkg -i /tmp/lsd.deb
  fi
}

install_packages () {
    sudo apt-get update
    sudo apt install -y $packages
}

install_pip_packages () {
  pip install $pip_packages
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

install_ranger_plugins () {
  if [[ ! -d ~/.config/ranger/plugins/ranger_devicons ]]; then
    git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
  fi
  # echo "default_linemode devicons" >> ~/.config/ranger/rc.conf
}

install_antigen () {
  if [ ! -f ~/.antigen/antigen.zsh ]; then
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

install_packages
install_pip_packages
place_dotfiles
install_antigen
install_fzf
install_vim_plugins
setup_tmux_plugins
set_zsh_default
install_lsd
