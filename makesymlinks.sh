#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc zshrc tmux.conf rosrc"    	  # list of files/folders to symlink in homedir
packages="zsh tmux source-highlight vim-gnome"             # packages to be installed

##########

#TODO select different package manager depending on distro
#TODO add functionality for adding ppa's
#TODO select to either link or overwrite dotfiles
#TODO add rosinstall component (x86, arm, indigo, kinetic)
#TODO don't start zsh after installation
#TODO allow for different users (now /home/anne is baked in
#TODO add airline colors

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
    echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
    mkdir -p $olddir
    echo "done"


    # change to the dotfiles directory
    echo -n "Changing to the $dir directory ..."
    cd $dir
    echo "done"

    # move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
    for file in $files; do
        echo "Moving any existing dotfiles from ~ to $olddir"
        mv --backup=numbered ~/.$file ~/dotfiles_old/
        echo "Creating symlink to $file in home directory."
        ln -s $dir/$file ~/.$file
    done
}

install_packages () {
    for package in $packages; do
        echo "installing package: $package"
        sudo apt-get install -y $package
    done
}

install_omzsh () {
    # install my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d ~/.oh-my-zsh/ ]]; then
        sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    fi
    # install zsh-autosuggestions
    git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    # install fasd
    if [[ ! -d /usr/local/bin/fasd ]]; then
      git clone https://github.com/clvv/fasd.git ~/Downloads/fasd
      cd ~/Downloads/fasd/; sudo make install; cd ..; rm -rf fasd
    fi
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

set_locale () {
    export LANGUAGE=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LC_CTYPE="en_US.UTF-8"
    locale-gen en_US.UTF-8
    sudo dpkg-reconfigure locales
}

install_packages
install_omzsh
# disable_ubuntu_crap
install_vim_plugins
place_dotfiles
