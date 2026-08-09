HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000

path=($HOME/.opencode/bin $HOME/.local/bin $path)
typeset -U path

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt INTERACTIVE_COMMENTS
setopt LONG_LIST_JOBS
setopt COMPLETE_IN_WORD
setopt NO_BEEP

[[ -o interactive ]] || return

bindkey -e

bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word

up-line-or-search() {
    if (( $#LBUFFER )); then
        zle up-history
    else
        zle history-beginning-search-backward
    fi
}
down-line-or-search() {
    if (( $#RBUFFER )); then
        zle down-history
    else
        zle history-beginning-search-forward
    fi
}
zle -N up-line-or-search
zle -N down-line-or-search
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[[1;5A' history-beginning-search-backward
bindkey '^[[1;5B' history-beginning-search-forward

zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit bashcompinit
compinit
bashcompinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'

export EDITOR=nano

alias back='cd ..'
alias ls='eza --icons --color=always --group-directories-first'
alias l='eza -F --icons --color=always --group-directories-first'
alias ll='eza -alF --icons --color=always --group-directories-first'
alias la='eza -a --icons --color=always --group-directories-first'
alias l.='eza -a --color=always .[^.]*(N)'
alias lsize='du -sh * 2>/dev/null'

alias btw='fastfetch'
alias mvenv='python3 -m venv venv && source venv/bin/activate'
alias reload='source ~/.zshrc'
alias please='doas $(fc -ln -1)'
alias grep='grep --color=auto'
alias copy='wl-copy'
alias paste='wl-paste'

mkcd() { mkdir -p "$1" && cd "$1"; }

set_window_title() { print -n "\e]0;${USER}@${HOST}: $1\a"; }
set_cwd() { print -n "\e]7;file://$HOST${PWD// /%20}\a"; }

precmd() {
    set_window_title "$PWD"
    set_cwd
}
preexec() { set_window_title "$1" }

PROMPT='%B%F{green}%n@%m %~ %# %f%b'
