#!/bin/bash
set -euo pipefail
repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
if [ ! -f "$HOME/.local/share/portable-terminal/oh-my-zsh/oh-my-zsh.sh" ]; then
  printf 'Run bash scripts/install-dependencies.sh first.\n' >&2
  exit 1
fi
for plugin in zsh-completions zsh-autosuggestions zsh-syntax-highlighting; do
  if [ ! -f "$HOME/.local/share/portable-terminal/oh-my-zsh/custom/plugins/$plugin/$plugin.plugin.zsh" ]; then
    printf 'Missing %s; finish scripts/install-dependencies.sh first.\n' "$plugin" >&2
    exit 1
  fi
done
config_dir="$HOME/.config/portable-terminal"
profile_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
zshrc="${ZDOTDIR:-$HOME}/.zshrc"
backup_dir="$(mktemp -d "$HOME/.portable-terminal-backup.XXXXXX")"
mkdir -p "$config_dir" "$profile_dir" "$(dirname "$zshrc")"
copy_with_backup() {
  local source="$1" target="$2" backup_name="$3"
  if [ -e "$target" ] || [ -L "$target" ]; then
    cp -p "$target" "$backup_dir/$backup_name"
  fi
  # Refuse symlinks rather than writing through to an unexpected location.
  if [ -L "$target" ]; then
    printf 'Refusing to overwrite symlink: %s\n' "$target" >&2
    exit 1
  fi
  cp "$source" "$target"
}
copy_with_backup "$repo_dir/shell/terminal.zsh" "$config_dir/terminal.zsh" terminal.zsh
copy_with_backup "$repo_dir/iterm/portable-terminal.json" "$profile_dir/portable-terminal.json" portable-terminal.json
line='source "$HOME/.config/portable-terminal/terminal.zsh" # portable-terminal'
if [ -L "$zshrc" ]; then
  printf 'Existing .zshrc is a symlink. Add this line manually:\n%s\n' "$line"
elif ! /usr/bin/grep -Fqx "$line" "$zshrc" 2>/dev/null; then
  if [ -e "$zshrc" ]; then cp -p "$zshrc" "$backup_dir/zshrc"; fi
  # Put it first so existing business-specific settings can override it.
  staged="$(mktemp "$(dirname "$zshrc")/.portable-terminal-zshrc.XXXXXX")"
  printf '%s\n' "$line" > "$staged"
  if [ -f "$zshrc" ]; then cat "$zshrc" >> "$staged"; fi
  cat "$staged" > "$zshrc"
  rm "$staged"
fi
printf 'Installed. Backups: %s\nOpen a new shell and choose the Portable Terminal profile in iTerm.\n' "$backup_dir"
