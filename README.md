# Portable Mac terminal

Personal terminal appearance and shell conveniences for an Apple Silicon work Mac.
This repository contains no Git identity/configuration, SSH configuration or keys,
tokens, history, AI settings, cloud accounts, corporate network settings, or personal
filesystem paths. The Oh My Zsh `git` plugin provides aliases and prompt information;
it does not configure your Git identity.

## Included

- iTerm profile: existing colours, Monaco 12, cursor, spacing, scrollback, bell
  behaviour and keyboard mappings, including Shift+Return.
- Zsh: Oh My Zsh, `robbyrussell`, `git`, `zsh-completions`,
  `zsh-autosuggestions`, `zsh-syntax-highlighting`.
- Existing aliases: `mkvenv` creates/activates `venv`; `workon` activates it.
  These require Python 3, which this setup does not install.
- Optional installation of iTerm, VS Code and Sublime Text. No editor settings,
  extensions or sign-ins are copied.
- Optional iTerm app appearance preferences in `iterm/appearance.tsv`.

## Set up the other Mac

Download/copy this folder to the work Mac and open Terminal.app in that folder.
Use your company's software portal for apps if that is how the device is managed.
If Homebrew is already available and permitted, the alternative is:

```sh
brew bundle --file=./Brewfile
```

This project does not install Homebrew, change network/proxy/certificate settings,
accept Xcode licences, or use `sudo`. The dependency step needs Git and HTTPS access
to GitHub. If blocked, use your company's approved installation process; no network
workarounds are included.

```sh
bash scripts/install-dependencies.sh
bash scripts/install.sh
```

The dependency installer downloads four public repositories, pinned to the revisions
present on the source Mac. Oh My Zsh automatic update checks are disabled. The code
is installed under `~/.local/share/portable-terminal`, separate from any existing
Oh My Zsh installation. Dependencies are not bundled in this repository.

The configuration installer copies the shell configuration and an iTerm dynamic
profile, backing up existing destination files under
`~/.portable-terminal-backup.*`. It prepends a single `source` line to your `.zshrc`,
preserving its contents. If `ZDOTDIR` is exported, it uses that directory instead.
For a symlinked `.zshrc`, it prints the line for you to insert manually.
Run the installer again after changing this repository to refresh the copied files.

Open iTerm Settings → Profiles and select **Portable Terminal**. Set it as the
default using **Other Actions → Set as Default** if desired, then open a new window.
Existing profiles are retained. The profile starts the account's normal shell in
its home directory. This setup expects Zsh; it does not change the account shell.
The profile format follows the [iTerm dynamic profile documentation](https://iterm2.com/documentation-dynamic-profiles.html).

Existing `.zshrc` settings run after this configuration and can override it. If that
file already loads a shell framework, review the two setups before enabling both.
Keep any work-specific paths, aliases and Git identity on the work Mac.

## Optional iTerm app appearance

The dynamic profile handles terminal appearance and keyboard mappings. To also
apply the source Mac's scrollbar, fullscreen tab bar, fullscreen style, Escape
feedback, press-and-hold, scroll animation and print colour settings, quit iTerm
completely and run from Terminal.app:

```sh
bash scripts/apply-iterm-appearance.sh
```

Only the keys listed in `iterm/appearance.tsv` are changed. A full backup of existing
iTerm preferences is saved locally under `~/.portable-terminal-iterm-backup.*`.
That backup may contain private settings: do not publish it. If iTerm uses a custom
preferences folder or managed preferences, use its Settings UI instead of this script.
App-wide pointer gestures are not migrated; the portable profile carries keyboard
settings only. Session restoration, AI features and permissions are not migrated.

## Undo

Remove the line ending in `# portable-terminal` from your `.zshrc` and open a new
shell. Restore the backed-up shell configuration/profile if they existed, or remove
`~/.config/portable-terminal/terminal.zsh` and
`~/Library/Application Support/iTerm2/DynamicProfiles/portable-terminal.json`.
The dependency directory `~/.local/share/portable-terminal` can then be removed.

For optional app appearance changes, quit iTerm and restore the saved preferences
with `defaults import com.googlecode.iterm2 /path/to/backup/com.googlecode.iterm2.plist`.
This restores the whole saved iTerm preference snapshot, so it also reverts later
changes. If no preferences existed before installation, undo the individual keys in
`iterm/appearance.tsv` using `defaults delete com.googlecode.iterm2 'KEY'`.

## Publication

Publish only this project directory. Do not add raw exports of your home directory
or iTerm preferences. Machine-specific overrides and backups belong outside the
repository. These settings have not been applied to the source Mac.
