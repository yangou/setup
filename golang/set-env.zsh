asdf_use_goversion() {
  # respect .tool-versions
  if [[ -f ".tool-versions" ]]; then
    return 0
  fi

  # find go.mod recursively
  dir="$PWD"
  home="$HOME"
  gomod=""
  goversion=""
  while [[ "$dir" != "/" && "$dir" != "$home" ]]; do
    if [[ -f "$dir/go.mod" ]]; then
      gomod="$dir/go.mod"
      break
    fi
    dir=$(dirname "$dir")
  done

  if [[ "$dir" == "$home" && -f "$home/go.mod" ]]; then
    gomod="$home/go.mod"
  fi

  if [[ -n "${gomod}" ]]; then
    goversion=$(grep '^go ' $gomod | sed -n 's/^go //p')

    if [[ -n "${goversion}" ]]; then
      # Get all installed Golang versions
      installed_versions=($(asdf list golang | tr -d ' ' | sed 's/\*//g'))

      # Check if the user specified a full version
      if [[ $goversion =~ ^[0-9]+\.[0-9]+$ ]]; then
        # Partial version specified, find the highest installed version matching the base
        highest_version=$(echo "${installed_versions[@]}" | tr ' ' '\n' | grep "^${goversion//./\\.}" | sort -V | tail -n 1)

        if [[ -n $highest_version ]]; then
          asdf shell golang $highest_version
        else
          echo "Error: No matching golang '$goversion.x' found."
        fi
      else
        # Exact version specified, check if it's installed
        if [[ " ${installed_versions[@]} " =~ " $goversion " ]]; then
          asdf shell golang $goversion
        else
          echo "Error: golang '$goversion' is not installed."
        fi
      fi
    else
      asdf shell golang --unset
    fi
  else
    asdf shell golang --unset
  fi
}

asdf_update_golang_env() {
  asdf_use_goversion

  local go_bin_path
  go_bin_path="$(asdf which go 2>/dev/null)"
  if [[ -n "${go_bin_path}" ]]; then
    export GOROOT
    GOROOT="$(dirname "$(dirname "${go_bin_path:A}")")"

    export GOPATH
    GOPATH="$(dirname "${GOROOT:A}")/packages"

    export GOBIN
    GOBIN="$(dirname "${GOROOT:A}")/bin"

    export PATH
    PATH=$(echo $PATH | sed -E "s#${HOME}/.asdf/installs/golang/[0-9]+\.[0-9]+(\\.[0-9]+)?/bin(:|$)##g")
    PATH="$GOBIN:$PATH"
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd asdf_update_golang_env
