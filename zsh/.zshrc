autoload -Uz compinit
compinit -i

# TODO: Delete this function once https://github.com/microsoft/vscode/issues/204085 is fixed
function code() {
    /usr/local/bin/code "$@" 2> >( fgrep -v 'SecCodeCheckValidity: Error Domain=NSOSStatusErrorDomain' >&2 )
}

## WezTerm
# Sets the title of a terminal to the last directory of the current working directory.
function set_tab_title(){
    echo -ne "\033]0; $(basename "$PWD") \007"
}
precmd_functions+=(set_tab_title) # Set tab title when opening new tab.

## Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

## zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_THEME="dracula"
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[precommand]=fg=#8be9fd

zstyle ":completion:*:*:cd:*:*" ignore-parents "*/__pycache__/*"

HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

## uv
eval "$(uv generate-shell-completion zsh)"

## ruff
eval "$(ruff generate-shell-completion zsh)"

## Just
alias j="just"

## Astro
alias adi="astro dev init"
alias ads="astro dev start --wait 5m"
alias ads!="astro dev stop"
alias adrs="astro dev restart"
alias adk="astro dev kill"
alias adrs!="adk && ads"
alias adp="astro dev parse"
alias adps="astro dev ps"
alias adt="astro dev pytest"
alias adr="astro dev run $@"
alias adb="astro dev bash"

alias awl="astro workspace list"
alias aws="astro workspace switch"
alias adl="astro deployment list"

## Git
alias g="git"
alias gcb="g checkout -b"

git_close_branch () {
    local delete_branch=${1:-$(git branch --show-current)}
    g switch main
    g branch -D $delete_branch
    g fetch origin main
    g pull origin main
}

git_fixup () {
    local rebase_branch=${1:-main}
    g add .
    g commit --fixup HEAD
    g fetch origin $rebase_branch
    g rebase -i origin/$rebase_branch --autosquash
    g push --force-with-lease
}

alias gcb!="git_close_branch $@"
alias gfix="git_fixup $@"
alias grel='gcb release/$(TZ=US/Eastern date +%y.%-m.%-d) && g push origin $(g branch --show-current)'

## bat
export BAT_THEME=Dracula

## fzf
eval "$(fzf --zsh)"

# Use fd instead of fzf.
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# The first argument to the function ($1) is the base path to start traversal.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion.
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# File previews using fzf and bat
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function.
# The first argument to the function is the name of the command.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# Dracula color schema for fzf.
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

## eza (fork of exa, no longer maintained)
alias ls="eza --color=always --git --icons=always --hyperlink --tree --level=1 --group-directories-first --ignore-glob=__pycache__"

## thefuck
eval $(thefuck --alias)

## zoxide
eval "$(zoxide init zsh)"
alias cd="z"

## lazy*
alias lzg="lazygit"
alias lzd="lazydocker"
