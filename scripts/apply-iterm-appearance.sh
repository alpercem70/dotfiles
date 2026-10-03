#!/bin/bash
set -euo pipefail
repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
if pgrep -x iTerm2 >/dev/null || pgrep -x iTerm >/dev/null; then
  printf 'Quit iTerm completely and run this from Terminal.app.\n' >&2
  exit 1
fi
backup_dir="$(mktemp -d "$HOME/.portable-terminal-iterm-backup.XXXXXX")"
if defaults read com.googlecode.iterm2 >/dev/null 2>&1; then
  defaults export com.googlecode.iterm2 "$backup_dir/com.googlecode.iterm2.plist"
fi
while IFS=$'\t' read -r key type value; do
  defaults write com.googlecode.iterm2 "$key" "-$type" "$value"
done < "$repo_dir/iterm/appearance.tsv"
printf 'Applied appearance settings. Previous preferences, if present: %s\n' "$backup_dir"
