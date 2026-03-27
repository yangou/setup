#!/usr/bin/env bash
# Platform detection and cross-platform utilities

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)  echo "linux" ;;
    *)      echo "unsupported" ;;
  esac
}

is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
is_linux() { [[ "$(uname -s)" == "Linux" ]]; }

has_gui() {
  if is_macos; then
    # WindowServer runs when macOS has a graphical session
    pgrep -q WindowServer 2>/dev/null
  elif is_linux; then
    # Only trust $DISPLAY / $WAYLAND_DISPLAY — systemd graphical.target is
    # active on many headless Ubuntu servers and is not a reliable GUI indicator
    [[ -n "${DISPLAY:-}" ]] || [[ -n "${WAYLAND_DISPLAY:-}" ]]
  else
    return 1
  fi
}

# Use sudo only when not already root (Docker containers and fresh VPS servers run as root)
_sudo() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

# Portable sed in-place (macOS requires '' after -i, GNU sed does not)
sed_inplace() {
  if is_macos; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

# Append a line to a file if it's not already present
ensure_line() {
  local line="$1"
  local file="$2"
  grep -qF -- "$line" "$file" 2>/dev/null || echo "$line" >> "$file"
}

log_info()  { echo "==> $*"; }
log_warn()  { echo "==> WARNING: $*" >&2; }
log_error() { echo "==> ERROR: $*" >&2; }
