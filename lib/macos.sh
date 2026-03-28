#!/usr/bin/env bash
# macOS-specific installation functions

install_macos_prerequisites() {
  log_info "Installing macOS prerequisites..."

  if ! xcode-select -p &>/dev/null; then
    sudo xcode-select --install
    echo "Waiting for Xcode Command Line Tools to install..."
    until xcode-select -p &>/dev/null; do sleep 5; done
  fi

  # Rosetta 2 (only needed on Apple Silicon)
  if [[ "$(uname -m)" == "arm64" ]]; then
    sudo softwareupdate --install-rosetta --agree-to-license 2>/dev/null || true
  fi
}

install_macos_homebrew() {
  if ! command -v brew &>/dev/null; then
    log_info "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Homebrew on Apple Silicon vs Intel
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_macos_packages() {
  local script_dir="$1"
  local has_gui="$2"

  install_macos_homebrew
  brew update

  if [[ "$has_gui" == "yes" ]]; then
    log_info "Installing all packages (desktop mode)..."
    brew bundle --file="$script_dir/Brewfile"
  else
    log_info "Installing CLI-only packages (headless mode)..."
    # Strip cask and vscode lines for headless macOS (e.g., Mac Mini server)
    grep -vE '^cask |^vscode ' "$script_dir/Brewfile" | brew bundle --file=-
  fi

  brew upgrade

  # fzf key bindings and shell completion
  "$(brew --prefix)/opt/fzf/install" --all 2>/dev/null || true

  # gke-gcloud-auth-plugin is required by kubectl to authenticate against GKE clusters.
  # It ships as a gcloud SDK component, not a Homebrew formula, so it must be installed
  # explicitly after the google-cloud-sdk cask is in place.
  if command -v gcloud &>/dev/null; then
    log_info "Installing gke-gcloud-auth-plugin..."
    gcloud components install gke-gcloud-auth-plugin --quiet 2>/dev/null \
      || log_warn "gke-gcloud-auth-plugin install failed (will need manual: gcloud components install gke-gcloud-auth-plugin)"

    # gcloud CLI auth — required for gcloud commands (API enablement, GCS bucket management)
    if ! gcloud auth list --format="value(account)" 2>/dev/null | grep -q .; then
      log_info "Authenticating with gcloud (opens browser)..."
      gcloud auth login --quiet || log_warn "gcloud auth login failed — run manually: gcloud auth login"
    else
      log_info "gcloud already authenticated ($(gcloud config get-value account 2>/dev/null))"
    fi

    # Application Default Credentials — required by Terraform's GCP provider
    if ! gcloud auth application-default print-access-token >/dev/null 2>&1; then
      log_info "Setting up Application Default Credentials (opens browser)..."
      gcloud auth application-default login --quiet \
        || log_warn "gcloud ADC login failed — run manually: gcloud auth application-default login"
    else
      log_info "gcloud Application Default Credentials already set"
    fi
  fi
}
