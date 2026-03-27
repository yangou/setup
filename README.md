# Setup

Cross-platform development environment bootstrap for macOS and Ubuntu/Debian.

## Quick Start

### Fresh Ubuntu server (one-liner)

```bash
apt-get install -y git curl && git clone https://github.com/yangou/setup.git ~/Workspace/setup && ~/Workspace/setup/install <username> <email>
```

Example:

```bash
apt-get install -y git curl && git clone https://github.com/yangou/setup.git ~/Workspace/setup && ~/Workspace/setup/install yang yang@example.com
```

> `bash <(curl ...)` won't work because the install script sources sibling files — it must run from a cloned directory on disk.

### macOS or re-running

```bash
git clone https://github.com/yangou/setup.git ~/Workspace/setup
~/Workspace/setup/install <username> <email>
```

## What Gets Installed

### Both platforms

| Tool | Description | Method |
|------|-------------|--------|
| zsh + oh-my-zsh + powerlevel10k | Shell | apt / brew |
| asdf | Runtime version manager | git clone / brew |
| Node.js 22, Go 1.23, Java 23 | Runtimes via asdf | asdf |
| git, tmux, fzf, ripgrep, jq | Core CLI tools | apt / brew |
| neovim + vim (maximum-awesome) | Editors | apt / brew |
| docker | Container runtime | apt / brew |
| kubectl, helm, terraform | Kubernetes / IaC | apt / brew |
| tailscale | VPN | apt / brew |
| AWS CLI v2 | Cloud CLI | binary / brew |
| kind, kustomize | Local k8s | binary / brew |

### macOS only (GUI)

| Tool | Method |
|------|--------|
| VS Code, PyCharm, Cursor | brew cask |
| iTerm2, Rectangle, 1Password | brew cask |
| Google Chrome, Slack | brew cask |

### macOS headless (no GUI)

Casks and GUI apps are automatically skipped — only CLI tools are installed.

## Platform Detection

The install script auto-detects:

- **OS**: macOS vs Linux
- **GUI**: desktop session vs headless server

No flags needed — it adapts automatically.

## Requirements

- Ubuntu 20.04+ or macOS 12+
- Internet access
- `curl` (pre-installed on most systems)

On Ubuntu, the script runs as root or via sudo — both work.
