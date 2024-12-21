export EDITOR='vim'
alias ll='ls -lha'

export PATH="$HOME/bin:$HOME/Workspace/bin:$PATH"

# source credentials if any: aws, etc
[ -f ~/.credentials ] && source ~/.credentials

# pure
# autoload -U promptinit; promptinit
# prompt pure

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# java
. ~/.asdf/plugins/java/set-java-home.zsh
add-zsh-hook -d precmd asdf_update_java_home
add-zsh-hook chpwd asdf_update_java_home

# golang
export GLOBAL_GOLANG=1.23.4
. ~/.asdf/plugins/golang/set-env.zsh

# bison
export PATH="$PATH:$(brew --prefix bison)/bin"

# flex
export PATH="$PATH:$(brew --prefix flex)/bin"

# openssl
export KERL_CONFIGURE_OPTIONS="--with-ssl=$(brew --prefix openssl)"
export PATH="$PATH:$(brew --prefix openssl)/bin"

# npm
export PATH="$PATH:$HOME/.npm-global/bin"

# fzf
if type ag &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 40% --layout=reverse --border'
fi

# search selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# search shell history
fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# search chrome history
ch() {
  local cols sep
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  cp -f ~/Library/Application\ Support/Google/Chrome/Profile\ 1/History /tmp/h

  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
}

# erlang shell
export ERL_AFLAGS="-kernel shell_history enabled"

source ~/powerlevel10k/powerlevel10k.zsh-theme

# functions
ws() {
  cd ~/Workspace/$1
}

_ws_complete() {
  local ws_path=~/Workspace/
  compadd -W $ws_path -- $(ls -1 $ws_path)
}

compdef _ws_complete ws
