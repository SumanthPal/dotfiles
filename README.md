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

## Fresh machine

```bash
git clone --recurse-submodules https://github.com/SumanthPal/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh          # installs brew deps, stows, tpm, oh-my-zsh
# or manual:
brew bundle --file=Brewfile
stow -t ~ zsh bash git vim tmux agents herdr nvim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm  # then tmux → prefix+I
```

Secrets: copy `zsh/.zshenv.local.example` → `zsh/.zshenv.local` (or `~/.zshenv.local`, both gitignored and sourced by `.zshrc` — see `install.sh` Step 10 which creates + links it idempotently) and add `ZOTGPT_API_KEY` / `GOOGLE_VERTEX_*` etc.

## Packages

| Package | Files |
|---|---|
| `zsh` | `.zshrc`, `.zprofile`, `.zshenv` (secrets in `.zshenv.local`, gitignored) |
| `bash` | `.bash_profile`, `.bash_completion`, `.profile` |
| `git` | `.gitconfig`, `.gitignore_global` |
| `vim` | `.vimrc` |
| `tmux` | `.tmux.conf`, `.tmux/` (plugins gitignored — run `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm` then prefix+I on a fresh machine) |
| `agents` | `AGENTS.md` (shared AI-harness rules; `~/.claude/CLAUDE.md` includes it) |
| `herdr` | `.config/herdr/config.toml` (plugins.json/session.json/logs gitignored — runtime state) |
| `nvim` | `.config/nvim` — git **submodule** of [SumanthPal/nvim-dotfiles](https://github.com/SumanthPal/nvim-dotfiles); clone with `git clone --recurse-submodules` |

## Adding a new dotfile

```bash
mkdir -p ~/dotfiles/<tool>
mv ~/.<file> ~/dotfiles/<tool>/.<file>
cd ~/dotfiles && stow -t ~ <tool>
```

For files under `~/.config/`, mirror the path inside the package (e.g. `~/dotfiles/foo/.config/foo/config.toml`).


