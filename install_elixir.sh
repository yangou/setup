asdf install erlang 22.2
asdf global erlang 22.2

asdf install elixir 1.9.4
asdf global elixir 1.9.4

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

touch ~/.bashrc
line="source $DIR/bash/elixir"
grep -qF -- "$line" ~/.bashrc || echo "$line" >> ~/.bashrc
