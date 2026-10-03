# Portable interactive shell configuration. Machine-specific settings stay outside
# this repository, in your existing .zshrc (after this file is sourced).
[[ -o interactive ]] || return
export ZSH="$HOME/.local/share/portable-terminal/oh-my-zsh"
if [[ ! -f "$ZSH/oh-my-zsh.sh" ]]; then
  print -u2 'Portable Terminal: run scripts/install-dependencies.sh first.'
  return
fi
ZSH_CUSTOM="$ZSH/custom"
ZSH_THEME="robbyrussell"
DISABLE_MAGIC_FUNCTIONS="true"
# Update deliberately through the dependency installer, avoiding startup network calls.
zstyle ':omz:update' mode disabled
plugins=(git zsh-completions zsh-autosuggestions zsh-syntax-highlighting)
# Make extra completions available before Oh My Zsh runs compinit.
fpath=("$ZSH_CUSTOM/plugins/zsh-completions/src" $fpath)
source "$ZSH/oh-my-zsh.sh"

alias mkvenv='python3 -m venv venv && source venv/bin/activate'
alias workon='source venv/bin/activate'
