# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="bira"

# Personal additions
alias sshServer='ssh anne@annesteenbeek.student.utwente.nl'
alias sshNetbook='ssh anne@192.168.0.103'
alias sshBackup='ssh anne@steenbeekthuis.ddns.net'

alias clc='clear'
alias tree='tree -L 3 --filelimit 20 -h'

zstyle ':completion:*' menu select # Do menu-driven completion.

# less color highlighting
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '

# set ranger default editor
export EDITOR=vim ranger

# force 256 color
export TERM=screen-256color
# make sure tmux is loaded correctly
alias tmux="TERM=screen-256color-bce tmux"

# Plugin conf
# fasd
export _FASD_DATA="$HOME/.fasd/.fasd"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

plugins=(git colorize colored-man-pages command-not-found compleat zsh-autosuggestions wd fasd)

source $ZSH/oh-my-zsh.sh

# source all ros settings
source ~/.rosrc

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

