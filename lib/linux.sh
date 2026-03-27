#!/usr/bin/env bash
# Linux-specific installation functions (Ubuntu/Debian)
#
# Strategy: add all third-party apt repos first, run ONE apt-get update,
# then install everything via apt in a single pass. Only fall back to
# curl/binary for tools that genuinely have no apt repo (kind,
# kustomize, AWS CLI v2, asdf).

install_linux_apt_repos() {
  log_info "Adding third-party apt repositories..."

  # Prerequisites for adding repos
  _sudo apt-get update
  _sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

  _sudo mkdir -p /etc/apt/keyrings

  # Docker (official repo — newer than Ubuntu's docker.io)
  if ! [ -f /etc/apt/keyrings/docker.gpg ]; then
    log_info "  Adding Docker repo..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
      | _sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
      | _sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  fi

  # Kubernetes (kubectl)
  if ! [ -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg ]; then
    log_info "  Adding Kubernetes repo..."
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key \
      | _sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
      https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" \
      | _sudo tee /etc/apt/sources.list.d/kubernetes.list >/dev/null
  fi

  # HashiCorp (Terraform)
  if ! [ -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]; then
    log_info "  Adding HashiCorp repo..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg \
      | _sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
      https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
      | _sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
  fi

  # Google Cloud SDK
  if ! [ -f /usr/share/keyrings/cloud.google.gpg ]; then
    log_info "  Adding Google Cloud SDK repo..."
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
      | _sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] \
      https://packages.cloud.google.com/apt cloud-sdk main" \
      | _sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list >/dev/null
  fi

  # Tailscale
  if ! [ -f /usr/share/keyrings/tailscale-archive-keyring.gpg ]; then
    log_info "  Adding Tailscale repo..."
    curl -fsSL "https://pkgs.tailscale.com/stable/ubuntu/$(lsb_release -cs).noarmor.gpg" \
      | _sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    curl -fsSL "https://pkgs.tailscale.com/stable/ubuntu/$(lsb_release -cs).tailscale-keyring.list" \
      | _sudo tee /etc/apt/sources.list.d/tailscale.list >/dev/null
  fi

  # Helm (official apt repo via Buildkite)
  if ! [ -f /usr/share/keyrings/helm.gpg ]; then
    log_info "  Adding Helm repo..."
    curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey \
      | gpg --dearmor | _sudo tee /usr/share/keyrings/helm.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/helm.gpg] \
      https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" \
      | _sudo tee /etc/apt/sources.list.d/helm-stable-debian.list >/dev/null
  fi

  # Single update after all repos are added
  log_info "Updating apt cache with all repositories..."
  _sudo apt-get update
}

install_linux_packages() {
  log_info "Installing packages via apt..."

  local packages=(
    # Build tools
    build-essential automake cmake libtool pkg-config ruby

    # CLI tools (mapped from Brewfile brews)
    ack colordiff universal-ctags ffmpeg fzf git jq
    neovim protobuf-compiler ripgrep silversearcher-ag
    socat telnet tmux tree unzip watch wget zip zsh

    # Dev libraries (needed by asdf for building language runtimes)
    libffi-dev libpq-dev libreadline-dev libsqlite3-dev
    libssl-dev libxml2-dev libxslt1-dev libyaml-dev zlib1g-dev

    # Docker (from Docker's apt repo)
    docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Kubernetes
    kubectl

    # HashiCorp
    terraform

    # Google Cloud SDK
    google-cloud-cli

    # Tailscale
    tailscale

    # Helm (from Buildkite apt repo)
    helm
  )

  # Filter out packages unavailable on this Ubuntu version
  local available=()
  for pkg in "${packages[@]}"; do
    if apt-cache show "$pkg" &>/dev/null 2>&1; then
      available+=("$pkg")
    else
      log_warn "Package not available: $pkg (skipping)"
    fi
  done

  _sudo apt-get install -y "${available[@]}"

  # Docker: add current user to docker group
  _sudo usermod -aG docker "$USER" 2>/dev/null || true
}

# ── Tools that have no apt repo (curl/binary only) ─────────────────────────

install_linux_awscli() {
  if command -v aws &>/dev/null; then return; fi
  log_info "Installing AWS CLI v2 (apt only has v1)..."
  local arch
  arch="$(uname -m)"
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${arch}.zip" -o /tmp/awscliv2.zip
  unzip -o /tmp/awscliv2.zip -d /tmp
  _sudo /tmp/aws/install
  rm -rf /tmp/aws /tmp/awscliv2.zip
}

install_linux_kind() {
  if command -v kind &>/dev/null; then return; fi
  log_info "Installing kind (not in apt)..."
  local arch kind_ver
  arch="$(dpkg --print-architecture)"
  kind_ver="$(curl -fsSL https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | jq -r .tag_name)"
  curl -fsSL "https://kind.sigs.k8s.io/dl/${kind_ver}/kind-linux-${arch}" -o /tmp/kind
  _sudo install -o root -g root -m 0755 /tmp/kind /usr/local/bin/kind
  rm -f /tmp/kind
}

install_linux_kustomize() {
  if command -v kustomize &>/dev/null; then return; fi
  log_info "Installing kustomize (not in apt)..."
  curl -fsSL "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
  _sudo mv kustomize /usr/local/bin/
}

install_linux_asdf() {
  if [ -d ~/.asdf ]; then
    log_info "Updating asdf..."
    git -C ~/.asdf fetch --tags
  else
    log_info "Installing asdf (not in apt)..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  fi

  # Checkout latest tag
  cd ~/.asdf
  git checkout "$(git describe --abbrev=0 --tags)" 2>/dev/null || true
  cd - >/dev/null

  # Make asdf available for the rest of this script
  export PATH="$HOME/.asdf/bin:$PATH"
  source "$HOME/.asdf/asdf.sh" 2>/dev/null || true
}

# ── Orchestrator ────────────────────────────────────────────────────────────

install_linux_all() {
  local has_gui="$1"

  # Phase 1: add all apt repos, then single apt-get update
  install_linux_apt_repos

  # Phase 2: install everything available via apt in one pass
  install_linux_packages

  # Phase 3: tools that have no apt repo
  install_linux_awscli
  install_linux_kind
  install_linux_kustomize
  install_linux_asdf

  # fzf keybindings info
  if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    log_info "fzf keybindings will be sourced from apt install location"
  fi
}
