#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# packages
# brew install ack tmux ctags bash-completion csshx jq tree docker
# brew cask install virtualbox vagrant vagrant-manager iterm2

# tmux
rm -rf ~/.tmux.conf && rm -rf ~/.tmux.conf.local
ln -s $DIR/tmux/tmux.conf ~/.tmux.conf
ln -s $DIR/tmux/tmux.conf.local ~/.tmux.conf.local

# vim
rm -rf ~/.vim && ln -s $DIR/vim ~/.vim
for package in `find ~/.vim/pack/*/start/*/doc -type d`
do
  vim -c "helptags ${package} | q"
done

# git
rm -rf ~/.bash-git-prompt && ln -s $DIR/bash-git-prompt ~/.bash-git-prompt
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cp cherry-pick
git config --global alias.cm commit
git config --global alias.df diff
git config --global alias.st status
git config --global user.name 'Yang Ou'
git config --global user.email 'ouyang871223@gmail.com'

# update bashrc
line="source $DIR/bash/bashrc"
grep -qF -- "$line" ~/.bashrc || echo "$line" >> ~/.bashrc
