# Setup

Cross-platform development environment bootstrap for macOS and Ubuntu/Debian.

## Quick Start

### macOS

Run directly — no bootstrap needed:

```bash
git clone https://github.com/yangou/setup.git ~/Workspace/setup
~/Workspace/setup/install <username> <email>
```

### Fresh Ubuntu/Linux server (run from local machine)

Use the `bootstrap` script, which installs your SSH public key on the server and then kicks off the full setup over SSH:

```bash
curl -fsSL https://raw.githubusercontent.com/yangou/setup/main/bootstrap -o /tmp/bootstrap
bash /tmp/bootstrap <username> <email> <host> [hostname]
```

Example:

```bash
bash /tmp/bootstrap yang yang@example.com 164.92.126.113
```

Bootstrap requires root SSH key access to the server (standard with cloud providers like DigitalOcean, AWS EC2, etc.). It will:
1. Create the user and install your local `~/.ssh/id_ed25519.pub` (or `id_rsa.pub`)
2. SSH in as the user (key auth, no password) and run the full install

> Re-running install on an existing machine (Linux or macOS) is safe — all steps are idempotent.

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
