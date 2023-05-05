export EDITOR='vim'
alias ll='ls -lha'

export PATH="~/bin:$PATH"

# source credentials if any: aws, etc
[ -f ~/.credentials ] && source ~/.credentials

# pure
# autoload -U promptinit; promptinit
# prompt pure

# asdf
. /usr/local/opt/asdf/libexec/asdf.sh

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
