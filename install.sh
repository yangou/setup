#! /bin/bash

printf 'user: '
read -r USER

printf 'email: '
read -r EMAIL

printf 'hostname: '
read -r HOSTNAME

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install gvm
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# packages
brew reinstall ack tmux ctags bash-completion csshx jq tree watch colordiff fzf ripgrep
brew cask reinstall virtualbox vagrant vagrant-manager iterm2 docker atom flux slack wechat dropbox google-chrome

# install fzf
$(brew --prefix)/opt/fzf/install --all

# vim
rm -rf ~/.vim && ln -s $DIR/vim ~/.vim
for package in `find ~/.vim/pack/*/start/*/doc -type d`
do
  vim -c "helptags ${package} | q"
done

# tmux
rm -rf ~/.tmux.conf && rm -rf ~/.tmux.conf.local
ln -s $DIR/tmux/tmux.conf ~/.tmux.conf
ln -s $DIR/tmux/tmux.conf.local ~/.tmux.conf.local

# git
rm -rf ~/.bash-git-prompt && ln -s $DIR/bash-git-prompt ~/.bash-git-prompt
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cp cherry-pick
git config --global alias.cm commit
git config --global alias.df diff
git config --global alias.st status
git config --global user.name "$USER"
git config --global user.email "$EMAIL"

# update bashrc
line="source ~/.bashrc"
grep -qF -- "$line" ~/.bash_profile || echo "$line" >> ~/.bash_profile

line="source $DIR/bash/bashrc"
grep -qF -- "$line" ~/.bashrc || echo "$line" >> ~/.bashrc

# install fonts
cp $DIR/fonts/* ~/Library/Fonts/

# set hostnames
sudo scutil --set HostName $HOSTNAME
sudo scutil --set LocalHostName $HOSTNAME
sudo scutil --set ComputerName $HOSTNAME
sudo dscacheutil -flushcache

# restart
sudo reboot
