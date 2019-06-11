asdf install erlang 21.3.4
asdf global erlang 21.3.4

asdf install elixir 1.8.1
asdf global elixir 1.8.1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

touch ~/.bashrc
line="source $DIR/bash/elixir"
grep -qF -- "$line" ~/.bashrc || echo "$line" >> ~/.bashrc
