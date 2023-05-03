eval "$(ssh-agent -s)" >/dev/null
ssh-add --apple-use-keychain ~/.ssh/id_rsa 2>/dev/null

eval "$(/usr/local/bin/brew shellenv)"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
