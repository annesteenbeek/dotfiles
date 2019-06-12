# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

ZSH_THEME="bira"

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

plugins=(git colorize colored-man-pages command-not-found compleat zsh-autosuggestions wd fasd)

# Set color of autosuggestion in 256 color style to match background
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# User configuration
export PATH="usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# Modify prompt to show background jobs
export PROMPT="$(echo $PROMPT | sed 's/\@\%[m]\%{\$reset_color\%}./&%(1j.[%j].)/')"

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

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# add cuda tools to command path
export PATH="/usr/local/cuda/bin:$PATH"
export MANPATH=/usr/local/cuda/man:${MANPATH}

# add cuda libraries to library path
# if [[ "${LD_LIBRARY_PATH}" != "" ]]
# then
  # export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}
# else
  # export LD_LIBRARY_PATH=/usr/local/cuda/lib64
# fi

# source ~/.rosrc

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"
# export FZF_DEFAULT_COMMAND="fd --type f"
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Personal additions
# alias sshServer='ssh anne@annesteenbeek.student.utwente.nl'
# alias sshBackup='ssh anne@steenbeekthuis.ddns.net'

alias clc='clear'
alias dirs='dirs -v'
alias d='dirs -v'
alias tree='tree -L 3 --filelimit 20 -h'

