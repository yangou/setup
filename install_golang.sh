asdf install golang 1.11.9
asdf global golang 1.11.9

go get -u github.com/mdempsky/gocode
go get -u github.com/golang/lint/golint
go get -u golang.org/x/tools/cmd/guru
go get -u golang.org/x/tools/cmd/goimports
go get -u golang.org/x/tools/cmd/gorename
go get -u github.com/tools/godep
go get -u github.com/golang/dep/cmd/dep

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

touch ~/.bashrc
line="source $DIR/bash/golang"
grep -qF -- "$line" ~/.bashrc || echo "$line" >> ~/.bashrc
