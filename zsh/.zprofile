eval "$(ssh-agent -s)" >/dev/null

if [[ "$(uname -s)" == "Darwin" ]]; then
  ssh-add --apple-use-keychain ~/.ssh/id_rsa 2>/dev/null
else
  ssh-add ~/.ssh/id_rsa 2>/dev/null
fi

# Homebrew (macOS Apple Silicon, macOS Intel, or Linux)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# asdf (Linux git-clone install adds bin to PATH)
if [[ -f "$HOME/.asdf/bin/asdf" ]]; then
  export PATH="$HOME/.asdf/bin:$PATH"
fi
