# dotfiles

Personal configuration files, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a Stow **package** whose contents mirror their location relative to `$HOME`:

| Package    | Installs to | Application |
| ---------- | ----------- | ----------- |
| `fish`     | `~/.config/fish/config.fish`, `~/.config/fish/themes/Rosé Pine.theme` | [fish](https://fishshell.com) shell |
| `ghostty`  | `~/.config/ghostty/config.ghostty` | [Ghostty](https://ghostty.org) terminal |
| `nvim`     | `~/.config/nvim/init.lua`, `~/.config/nvim/lazy-lock.json` | [Neovim](https://neovim.io) |
| `starship` | `~/.config/starship.toml` | [Starship](https://starship.rs) prompt |
| `tmux`     | `~/.config/tmux/tmux.conf` | [tmux](https://github.com/tmux/tmux) |

Everything uses the [Rosé Pine](https://rosepinetheme.com) color scheme.

Tested with: fish 4.9.3, Ghostty 1.3.1, Neovim 0.12.5, Starship 1.26.0, tmux 3.8 (macOS).

## Prerequisites

On macOS with [Homebrew](https://brew.sh):

```bash
brew install stow fish neovim starship tmux git && brew install --cask ghostty
```

On Linux, install the same packages with your distribution's package manager (see [ghostty.org](https://ghostty.org/download) for Ghostty). Skip any you already have.

The Starship and tmux status bar icons need [Nerd Font](https://www.nerdfonts.com) symbols. [Ghostty](https://ghostty.org) includes them by default. For other terminals, install a Nerd Font and set it as the terminal's font, for example:

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

## Installation

Clone this repo to `~/dotfiles`:

```bash
git clone https://github.com/itsjoaos/dotfiles.git ~/dotfiles
```

Stow links packages into the **parent** of the directory you run it from, so from `~/dotfiles` everything lands in `~` without extra flags. If you clone it somewhere else, add `-t ~` to every `stow` command.

### 1. Clear out conflicting files

Stow refuses to overwrite real files. Preview what would happen first:

```bash
cd ~/dotfiles && stow -n -v fish ghostty nvim starship tmux
```

If it reports a conflict (for example `cannot stow ... over existing target`), a file already exists where Stow wants to create a link. A fresh install of fish usually creates `~/.config/fish/config.fish`, for instance. Compare each conflicting file with the repo version, keep anything you need, then move it out of the way rather than deleting it:

```bash
mkdir -p ~/dotfiles-backup && mv ~/.config/fish/config.fish ~/dotfiles-backup/
```

Repeat the dry run until it reports no conflicts.

**On macOS, if you have a Ghostty config at `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`, move it aside too.** Ghostty gives that file priority over `~/.config/ghostty/config.ghostty`, so the config from this repo would be ignored.

```bash
mkdir -p ~/dotfiles-backup && mv ~/Library/Application\ Support/com.mitchellh.ghostty/config.ghostty ~/dotfiles-backup/
```

**If you have a `~/.tmux.conf`, move it aside too.** It doesn't conflict with Stow, but tmux loads only the *first* user config it finds, and `~/.tmux.conf` takes priority over `~/.config/tmux/tmux.conf`. If you leave it, the config from this repo is silently ignored.

```bash
mkdir -p ~/dotfiles-backup && mv ~/.tmux.conf ~/dotfiles-backup/
```

> Avoid `stow --adopt` here: it moves the existing files *into* the repo, replacing the versions tracked in git.

### 2. Stow the packages

```bash
cd ~/dotfiles && stow -v fish ghostty nvim starship tmux
```

You can also stow a single package, e.g. `stow nvim`.

### 3. Per-application setup

**Ghostty**: quit and reopen Ghostty, or reload its config with <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>,</kbd>. It follows your system's light/dark mode, switching between Rosé Pine and Rosé Pine Dawn. It runs your login shell, so set fish as your login shell (below).

**fish**: to make fish your login shell, it must be listed in `/etc/shells`. Check with `grep fish /etc/shells`, and if it's missing, add it:

```bash
command -v fish | sudo tee -a /etc/shells
```

Then change your shell:

```bash
chsh -s "$(command -v fish)"
```

tmux starts your login shell, so until you do this new tmux panes open your previous shell. The config turns off the greeting, loads the Rosé Pine theme, and starts Starship with transient prompts.

**Neovim**: the first launch bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim) and installs the plugins (`rose-pine`, `vim-tmux-navigator`) at the versions pinned in `lazy-lock.json`.

**tmux**: install [tpm](https://github.com/tmux-plugins/tpm), the plugin manager, if you don't have it yet. The config expects it at `~/.tmux/plugins/tpm`:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then start tmux and press `prefix` + <kbd>I</kbd> (the prefix is <kbd>Ctrl</kbd>+<kbd>b</kbd> by default) to install the plugins (`tmux-sensible`, `rose-pine/tmux`, `vim-tmux-navigator`). Reload the config at any time with `prefix` + <kbd>r</kbd>.

> tpm normally installs plugins next to `~/.config/tmux/tmux.conf`. With Stow, that location is a link into this repo, so `tmux.conf` sets `TMUX_PLUGIN_MANAGER_PATH` to keep tpm and all plugins in `~/.tmux/plugins/` instead.

**Starship**: no extra steps. fish's `config.fish` already initializes it. The symbols come from the `nerd-font-symbols` preset. After a Starship update, regenerate them with `starship preset nerd-font-symbols` and re-apply the overrides at the top of `starship.toml`.

## Keybindings worth knowing

| Keys | Where | Action |
| ---- | ----- | ------ |
| <kbd>Ctrl</kbd>+<kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd> | Neovim & tmux | Move between Neovim splits and tmux panes seamlessly |
| <kbd>Ctrl</kbd>+<kbd>\\</kbd> | Neovim & tmux | Go to the previous split/pane |
| `prefix` + `"` / `%` | tmux | Split into top/bottom or left/right panes, keeping the current directory |
| `prefix` + <kbd>r</kbd> | tmux | Reload tmux config |
| <kbd>Space</kbd> | Neovim | Leader key |

Inside tmux, <kbd>Ctrl</kbd>+<kbd>l</kbd> is used for pane navigation, so it no longer clears the screen. Run `clear` instead.

## Making changes

The files in `~` are symlinks into this repo, so editing them in place edits the repo. Commit as usual.

`~/.config/ghostty`, `~/.config/nvim` and `~/.config/tmux` are links to whole directories in the repo, so new files you create in them (for example `~/.config/nvim/lua/...`) are added to the repo too. `~/.config/fish` is a real directory with only the two files above linked, so anything else fish writes there (such as `fish_variables`) stays out of the repo.

To update plugins, run `:Lazy update` in Neovim and commit the updated `lazy-lock.json`. In tmux, press `prefix` + <kbd>U</kbd>.

To add a new config, mirror its path under a new package directory, then stow it:

```bash
mkdir -p ~/dotfiles/git/.config/git && mv ~/.config/git/config ~/dotfiles/git/.config/git/
```

```bash
cd ~/dotfiles && stow -v git
```

## Uninstalling

To remove the symlinks for a package (the repo files are left untouched):

```bash
cd ~/dotfiles && stow -D -v tmux
```

Use `stow -R` (restow) after adding or removing files in a package to prune stale links.
