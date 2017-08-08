# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

ZSH_THEME="bira"

# Personal additions
alias sshServer='ssh anne@annesteenbeek.student.utwente.nl'
alias sshNetbook='ssh anne@192.168.0.103'
alias sshBackup='ssh anne@steenbeekthuis.ddns.net'
alias vpnServer='sudo openvpn ~/.vpn/ubuntuLaptop.ovpn'

alias clc='clear'
alias dirs='dirs -v'
alias tree='tree -L 3 --filelimit 20 -h'

zstyle ':completion:*' menu select # Do menu-driven completion.

# less color highlighting
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '

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

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"


# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

plugins=(git colorize colored-man-pages command-not-found compleat zsh-autosuggestions wd fasd)

# User configuration
export PATH="usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# Modify prompt to show background jobs
export PROMPT="$(echo $PROMPT | sed 's/\@\%[m]\%{\$reset_color\%}./&%(1j.[%j].)/')"

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

