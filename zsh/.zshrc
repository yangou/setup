export EDITOR='vim'
unalias ll 2>/dev/null || true

alias vim='nvim'

export PATH="$HOME/bin:$HOME/Workspace/bin:$PATH"

# source credentials if any: aws, etc
[ -f ~/.credentials ] && source ~/.credentials

# pure
# autoload -U promptinit; promptinit
# prompt pure

# asdf - platform-aware sourcing
if [[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]]; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
elif [[ -f "$HOME/.asdf/asdf.sh" ]]; then
  . "$HOME/.asdf/asdf.sh"
fi

# java (only if plugin is installed)
if [[ -f ~/.asdf/plugins/java/set-java-home.zsh ]]; then
  . ~/.asdf/plugins/java/set-java-home.zsh
  add-zsh-hook -d precmd asdf_update_java_home
  add-zsh-hook chpwd asdf_update_java_home
fi

# golang - Deprecated for asdf 0.16
# export GLOBAL_GOLANG=1.23.4
# . ~/.asdf/plugins/golang/set-env.zsh

# Homebrew-provided tool paths (macOS)
if command -v brew &>/dev/null; then
  # bison
  [[ -d "$(brew --prefix bison 2>/dev/null)" ]] && export PATH="$PATH:$(brew --prefix bison)/bin"
  # flex
  [[ -d "$(brew --prefix flex 2>/dev/null)" ]] && export PATH="$PATH:$(brew --prefix flex)/bin"
  # openssl
  if [[ -d "$(brew --prefix openssl 2>/dev/null)" ]]; then
    export KERL_CONFIGURE_OPTIONS="--with-ssl=$(brew --prefix openssl)"
    export PATH="$PATH:$(brew --prefix openssl)/bin"
  fi
fi

# npm
export PATH="$PATH:$HOME/.npm-global/bin"

# clusterctl
alias clusterctl="clusterctl --config ./cluster-api/clusterctl.yml"

# fzf
if command -v rg &>/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 40% --layout=reverse --border'
fi

# fzf keybindings (Linux apt install location)
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi
if [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
  source /usr/share/doc/fzf/examples/completion.zsh
fi

# k8s
export CLUSTER_TOPOLOGY=true

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

# search chrome history (macOS desktop only)
if [[ "$(uname -s)" == "Darwin" ]]; then
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
fi

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

load_env() {
  if [[ -f .env ]]; then
    source .env
  fi
}

# Add the function to the chpwd hook
autoload -U add-zsh-hook
add-zsh-hook chpwd load_env

# ── Platform-specific utilities ─────────────────────────────────────────────

if [[ "$(uname -s)" == "Darwin" ]]; then
  # Finder comment annotations (macOS xattr)
  desc() {
    if [[ $# -eq 2 ]]; then
      xattr -w com.apple.metadata:kMDItemFinderComment "$2" "$1"
    else
      xattr -p com.apple.metadata:kMDItemFinderComment "$1"
    fi
  }

  undesc() {
    xattr -d com.apple.metadata:kMDItemFinderComment $1
  }

  # ls with Finder comments
  ll() {
    # Use the provided arguments or default to the current directory
    local args=("$@")
    if [ ${#args[@]} -eq 0 ]; then
      args=(".")
    fi

    # Force `ls` to output colors (even when piping)
    ls_output=$(CLICOLOR_FORCE=1 ls -lha "${args[@]}")

    # Determine the maximum length of the `ls -lha` output before the file name
    max_length=$(echo "$ls_output" | awk '{print length($0)}' | sort -nr | head -n 1)

    # Process each line of the `ls -lha` output
    echo "$ls_output" | while IFS= read -r line; do
      # Extract the file name from the line (ignoring color codes)
      file=$(echo "$line" | sed -E 's/\x1B\[[0-9;]*[mK]//g' | awk '{print $NF}')

      # Get the Finder comment for the file
      comment=$(xattr -p com.apple.metadata:kMDItemFinderComment "$file" 2>/dev/null || echo "")

      # Print the line with the comment aligned
      printf "%-${max_length}s\t\033[0;32m%s\033[0m\n" "$line" "$comment"
    done
  }
else
  # Linux: simple colored ls
  alias ll='ls -lha --color=auto'
fi
