#!/bin/bash
set -Eeuo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OLDDIR="$DIR/backup/"             # old dotfiles backup directory
FILE_DIR="$DIR/files"

LOCALES=("en_US.UTF-8" "nl_NL.UTF-8")

# packages to be installed
apt_packages="zsh tmux source-highlight vim python3-pip build-essential curl htop xclip direnv"
brew_packages="tmux source-highlight vim htop xclip cmake"
pip_packages="ranger-fm Pygments"

if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
  NOCOLOR='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
else
  NOCOLOR='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
fi

msg() {
  echo >&2 -e "${1-}"
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  MACHINE="debian"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  MACHINE="osx"
fi
msg "${PURPLE}Machine type: $MACHINE${NOCOLOR}"

install_packages () {
    if [ "$MACHINE" == "debian" ]; then
      msg "${GREEN}Installing packages: $apt_packages${NOCOLOR}"
      sudo apt-get update
      sudo apt install -y -q $apt_packages
    elif [ "$MACHINE" == "osx" ]; then 
      for formula in $brew_packages; do
        if brew ls --versions myformula > /dev/null; then
          msg "${BLUE}Formula $formula is already installed.{NOCOLOR}"
        else
          brew install $formula
        fi
      done;
    fi
}

place_dotfiles() {
    msg "${GREEN}Linking dotfiles${NOCOLOR}"
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
          msg "${GREEN}Linking $file_path ${NOCOLOR}"
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
        msg "${GREEN}Linking $file_path ${NOCOLOR}"
      fi
    done
}

install_lsd () {
  if [[ ! -x "$(command -v lsd)" ]]; then
    UNAME=$(uname -m);
    if [ "$MACHINE" == "debian" ] && [ "$UNAME" == "x86_64" ]; then
      msg "${GREEN}Installing lsd${NOCOLOR}"
      wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb -O /tmp/lsd.deb
      sudo dpkg -i /tmp/lsd.deb
    elif [ $MACHINE == "osx" ]; then
      brew install lsd
    fi
  fi
}

install_pip_packages () {
  msg "${GREEN}Installing pip packages: $pip_packages${NOCOLOR}"
  pip3 install $pip_packages
}

install_vim_plugins () {
  msg "${GREEN}Installing vim plugins${NOCOLOR}"
  if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
  vim +PlugInstall +qall
  # TODO install vim plugins, mainly command T, which requires ruby make
  # TODO also install code formaters, pylint
}

install_ranger_plugins () {
  msg "${GREEN}Installing ranger plugins${NOCOLOR}"
  if [[ ! -d ~/.config/ranger/plugins/ranger_devicons ]]; then
    git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
  fi
}

install_antigen () {
  if [ ! -f ~/.antigen/antigen.zsh ]; then
    msg "${GREEN}Installing antigen${NOCOLOR}"
    mkdir ~/.antigen
    curl -L git.io/antigen > ~/.antigen/antigen.zsh
  fi
}

install_fzf () {
  if [ ! -d ~/.fzf ]; then
      msg "${GREEN}Installing fzf${NOCOLOR}"
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install --bin
  fi
}

install_tmux_plugins () {
  msg "${GREEN}Installing tmux plugins${NOCOLOR}"
  if [ ! -d  ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
  bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh
}

set_zsh_default () {
  ZSH="$(which zsh)"
  if [[ "$(basename $SHELL)" != "$(basename $ZSH)" ]]; then
    msg "${GREEN}Setting zsh as default shell${NOCOLOR}"
    sudo chsh -s "$(which zsh)" "$USER"
  fi
}

set_locale () {
  if [ $MACHINE == "debian" ]; then
    for locale in "${LOCALES[@]}"; do
    #  sudo sed -i "/$locale/s/^#\ //g" /etc/locale.gen
        file="/etc/locale.gen"
	if ! grep -qxF "$locale" $file; then
            # sudo bash -C "echo $locale >> $file"
           echo "$locale UTF-8" | sudo tee -a "$file"
	fi	
    done
    sudo locale-gen
  fi;
}

install_pyenv () {
    if [[ ! -d "~/.pyenv" ]]; then 
        curl https://pyenv.run | bash
    fi
}

# a_flag=''
# b_flag=''
# files=''
# verbose='false'

# print_usage() {
#   printf "Usage: ..."
# }

# while getopts 'abf:v' flag; do
#   case "${flag}" in
#     a) a_flag='true' ;;
#     b) b_flag='true' ;;
#     f) files="${OPTARG}" ;;
#     v) verbose='true' ;;
#     *) print_usage
#        exit 1 ;;
#   esac
# done


#TODO: --gui tag that installs patched nerdfonts, 
#TODO: git settings
#TODO: asdf?
#TODO: nvm

set_locale
install_packages
install_pip_packages
place_dotfiles
install_antigen
install_fzf
install_vim_plugins
install_tmux_plugins
install_ranger_plugins
install_lsd
install_pyenv
set_zsh_default
