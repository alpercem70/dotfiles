#!/bin/bash
set -euo pipefail

# Run on the destination Mac. Downloads only these four public repositories.
# Revisions are pinned to those found on the source Mac.
root="$HOME/.local/share/portable-terminal"
mkdir -p "$root"
install_repo() {
  local url="$1" revision="$2" target="$3"
  if [ -e "$target" ]; then
    if [ -d "$target/.git" ] && [ "$(git -C "$target" rev-parse HEAD)" = "$revision" ]; then
      printf 'Already installed: %s\n' "$target"
      return
    fi
    printf 'Refusing to replace existing directory: %s\n' "$target" >&2
    exit 1
  fi
  git clone --no-checkout "$url" "$target"
  git -C "$target" checkout --detach "$revision"
}
install_repo https://github.com/ohmyzsh/ohmyzsh.git \
  6421f8e104e4e87f2373362cbf61e46a918612a7 "$root/oh-my-zsh"
install_repo https://github.com/zsh-users/zsh-completions.git \
  f7c3173886f4f56bf97d622677c6d46ab005831f "$root/oh-my-zsh/custom/plugins/zsh-completions"
install_repo https://github.com/zsh-users/zsh-autosuggestions.git \
  c3d4e576c9c86eac62884bd47c01f6faed043fc5 "$root/oh-my-zsh/custom/plugins/zsh-autosuggestions"
install_repo https://github.com/zsh-users/zsh-syntax-highlighting.git \
  bb27265aeeb0a22fb77f1275118a5edba260ec47 "$root/oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
