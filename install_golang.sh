asdf install golang 1.12.4
asdf global golang 1.12.4

brew tap alecthomas/homebrew-tap
brew reinstall gometalinter

vim +GoInstallBinaries +qall

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

touch ~/.bashrc
line="source $DIR/bash/golang"
grep -qF -- "$line" ~/.bashrc || echo "$line" >> ~/.bashrc
