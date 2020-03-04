# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# ZSH_THEME="bira"
ZSH_THEME="spaceship"
# Spaceship settings
# SPACESHIP_CHAR_SYMBOL="$ "
SPACESHIP_DIR_TRUNC=5
SPACESHIP_DIR_TRUNC_PREFIX="…/"
SPACESHIP_DIR_TRUNC_REPO="false"
# SPACESHIP_GIT_PREFIX=" "
# SPACESHIP_GIT_SUFFIX=" "
SPACESHIP_VENV_SYMBOL="🐍·"
SPACESHIP_EXIT_CODE_SHOW="true"
SPACESHIP_EXIT_CODE_SYMBOL=""


zstyle ':completion:*' menu select # Do menu-driven completion.

# less color highlighting
# export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
# export LESS=' -R '

# set ranger default editor
export EDITOR=vim ranger

# force 256 color
export TERM=screen-256color
# export TERM=xterm-256color
# make sure tmux is loaded correctly
alias tmux="TERM=screen-256color-bce tmux"

# Plugin conf
# fasd
export _FASD_DATA="$HOME/.fasd/.fasd"

DISABLE_AUTO_TITLE="true"
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

DISABLE_AUTO_UPDATE="true"
# export UPDATE_ZSH_DAYS=30

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

plugins=(git colorize colored-man-pages command-not-found compleat zsh-autosuggestions wd fasd zsh-syntax-highlighting git-prompt)

# Set color of autosuggestion in 256 color style to match background
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# initialize fasd
eval "$(fasd --init auto)"

# User configuration
export PATH="usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# disable pasted text highlighting
zle_highlight+=(paste:none)

# Modify prompt to show background jobs
# export PROMPT="$(echo $PROMPT | sed 's/\@\%[m]\%{\$reset_color\%}./&%(1j.[%j].)/')"

# export PATH="/opt/anaconda2/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Store npm packages in user space, no root
# might need to add prefix=${HOME}/.npm-packages to ~/.npmrc
# make sure ~/.npm-packages exists
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$HOME/.npm-packages/bin:$PATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi


# use ctrl+o to navigate directories in ranger
function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi  
    rm -f -- "$tempfile"
}

bindkey -s '^O' 'ranger-cd\n'

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# add cuda tools to command path
export PATH="/usr/local/cuda/bin:$PATH"
export MANPATH=/usr/local/cuda/man:${MANPATH}

# rust cargo to path
export PATH="/home/$USER/.cargo/bin:$PATH"

source ~/.rosrc

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"
# export FZF_DEFAULT_COMMAND="fd --type f"
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
setopt HIST_IGNORE_ALL_DUPS

# Use android studio adb if available
if [[ -f "$HOME/Android/Sdk/platform-tools/adb" ]]; then
    alias adb="$HOME/Android/Sdk/platform-tools/adb" 
fi

alias clc='clear'
alias dirs='dirs -v'
alias d='dirs -v'
alias tree='tree -L 3 --filelimit 20 -h'
alias c='fasd -e code -d'


source /home/anne/.config/broot/launcher/bash/br
