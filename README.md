# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). One directory per tool ("package"); each package mirrors the layout of `$HOME`, and `stow` symlinks the contents back into `$HOME`.

## Usage

```bash
cd ~/dotfiles

# link a package into $HOME
stow -t ~ zsh

# link everything
stow -t ~ */

# unlink a package
stow -t ~ -D zsh

# re-link after adding/removing files inside a package
stow -t ~ -R zsh
```

## Packages

| Package | Files |
|---|---|
| `zsh` | `.zshrc`, `.zprofile`, `.zshenv` |
| `bash` | `.bash_profile`, `.bash_completion`, `.profile` |
| `git` | `.gitconfig`, `.gitignore_global` |
| `vim` | `.vimrc` |
| `tmux` | `.tmux.conf`, `.tmux/` (plugins gitignored — run `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm` then prefix+I on a fresh machine) |
| `agents` | `AGENTS.md` (shared AI-harness rules; `~/.claude/CLAUDE.md` includes it) |
| `herdr` | `.config/herdr/config.toml`, `.config/herdr/plugins.json` (logs/sockets/plugin cache stay unmanaged) |
| `nvim` | `.config/nvim` — git **submodule** of [SumanthPal/nvim-dotfiles](https://github.com/SumanthPal/nvim-dotfiles); clone with `git clone --recurse-submodules` |

## Adding a new dotfile

```bash
mkdir -p ~/dotfiles/<tool>
mv ~/.<file> ~/dotfiles/<tool>/.<file>
cd ~/dotfiles && stow -t ~ <tool>
```

For files under `~/.config/`, mirror the path inside the package (e.g. `~/dotfiles/foo/.config/foo/config.toml`).

## Deliberately not stowed

- Secrets and machine state: `.netrc`, shell histories, `~/.claude/`, `~/.pi/`, `~/.codex/` (runtime state + auth tokens).
