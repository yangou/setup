eval "$(ssh-agent -s)" >/dev/null
ssh-add --apple-use-keychain ~/.ssh/id_rsa 2>/dev/null

eval "$(/usr/local/bin/brew shellenv)"
