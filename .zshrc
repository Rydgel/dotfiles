# The following lines were added by compinstall

# zstyle :compinstall filename '/home/rydgel/.zshrc'

# ~/.zshrc

# initialize completion system etc.
autoload -U compinit colors && colors
compinit
colors

# prompts
PROMPT="%{$fg[red]%}%n%{$reset_color%}: %{$fg_no_bold[green]%}%1~ %{$reset_color%}%# " 

# locale
export LANG="en_US.UTF-8"

# exports
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.bin:$PATH
export PATH=$PATH:$HOME/.config/herbstluftwm
export PATH=$PATH:$HOME/.config/bspwm
export PATH=$PATH:$HOME/.local/bin

export PANEL_FIFO="/tmp/panel-fifo"

export __GL_SYNC_TO_VBLANK=1
export __GL_SYNC_DISPLAY_DEVICE=DFP-0
export __GL_THREADED_OPTIMIZATIONS=0

export EDITOR=vim

LS_COLORS='di=100:fi=33:ln=31:pi=5:so=5:bd=5:cd=4:or=31:mi=0:ex=35'
export LS_COLORS

# set fpath
fpath=($fpath .zsh/functions)
autoload functions
functions

# use different file for aliases
if [ -f ~/.zsh/alias ]; then
    source ~/.zsh/alias
else
    print "404: ~/.zsh/alias not found, asshole"
fi

# set history
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt append_history
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

# fix zsh history behavior
h() { if [ -z "$*" ]; then history 1; else history 1 | egrep "$@"; fi; }

# quoting urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# speed up completion
zstyle ':completion:*:paths' accept-exact '*(N)'
zstyle ':completion::complete:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# rehash
zstyle ':completion:*' rehash true

# killall completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $(whoami) -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always

# completion
setopt completealiases
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=34=36"

# formatting and messages
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'%{\e[0;33m%} %B%d%b%{\e[0m%}'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:default' list-prompt'%S%M matches%s'
zstyle ':completion:*:prefix:*' add-space true

# other crab
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search
