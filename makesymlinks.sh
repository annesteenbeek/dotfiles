#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
########## Variables

OLDDIR="$DIR/dotfiles_old"             # old dotfiles backup directory
files="bashrc vimrc zshrc tmux.conf rosrc"    	  # list of files/folders to symlink in homedir
packages="zsh tmux source-highlight vim-gnome build-essential"             # packages to be installed

##########

#TODO add functionality for adding ppa's
#TODO select to either link or overwrite dotfiles
#TODO don't start zsh after installation
#TODO allow for different users (now /home/anne is baked in
#TODO add airline colors


# TODO add xclip

##########
# Dialog
# -. Select packages to install -> store this list, (add optional extra packages that are not selected by default)
# -. Should dotfiles be linked or placed -> store choice
# -. Select dotfiles to be placed
# -. if vim is selected, allow for removal of certain plugins
# -. 
#########

place_dotfiles() {
    # create dotfiles_old in homedir
    mkdir -p $OLDDIR

    pushd $DIR
    # move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
    for file in $files; do
        if [ -f $DIR/$file ]; then # check if file exists and is not symlink
            echo "Moving $file from ~ to $OLDDIR"
            mv --backup=numbered ~/.$file $OLDDIR
            echo "Creating symlink to $file in home directory."
            ln -s $DIR/$file ~/.$file
        else
            echo "File $file is symlink, doing nothing"
        fi
    done
    popd
}

install_packages () {
    sudo apt-get update
    for package in $packages; do
        echo "installing package: $package"
        sudo apt-get install -y $package
    done
}

install_omzsh () {
    echo "setting up Oh-My-ZSH"
    # install my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d ~/.oh-my-zsh/ ]]; then
        wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh 
    fi

    # install zsh-autosuggestions
    AUTO_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    if [[ ! -d $AUTO_DIR ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git $AUTO_DIR
    fi

    # install fasd
    if [[ ! -d "/tmp/fasd" ]]; then
        git clone https://github.com/clvv/fasd.git /tmp/fasd
    fi
    pushd /tmp/fasd
    PREFIX=$HOME/.local make install
    mkdir -p ~/.fasd # create fasd history storage folder
    popd
}

install_vim_plugins () {
  if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
          git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  fi
  vim +PluginInstall +qall
  # TODO install vim plugins, mainly command T, which requires ruby make
  # TODO also install code formaters, pylint
}

disable_ubuntu_crap () {
  gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"
}

install_fzf () {
    if [ ! -d ~/.fzf ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    fi
}

setup_tmux_plugins () {
    if [ ! -d  ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh
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
install_omzsh
install_fzf
place_dotfiles
install_vim_plugins
setup_tmux_plugins
install_patched_fonts
