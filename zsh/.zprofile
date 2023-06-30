eval "$(ssh-agent -s)" >/dev/null
ssh-add --apple-use-keychain ~/.ssh/id_rsa 2>/dev/null

eval "$(/opt/homebrew/bin/brew shellenv)"

