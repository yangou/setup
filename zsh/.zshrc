export EDITOR='vim'
alias ll='ls -lha'

export PATH="$HOME/bin:$PATH"

# source credentials if any: aws, etc
[ -f ~/.credentials ] && source ~/.credentials

# pure
# autoload -U promptinit; promptinit
# prompt pure

# asdf
. ~/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

# java
. ~/.asdf/plugins/java/set-java-home.zsh

# fzf
if type ag &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 40% --layout=reverse --border'
fi

# erlang shell
export ERL_AFLAGS="-kernel shell_history enabled"

source ~/powerlevel10k/powerlevel10k.zsh-theme

# functions
ws() {
  cd ~/Workspace/$1
}
