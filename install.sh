#!/usr/bin/env bash
# Bootstrap a fresh Mac from zero. Idempotent — safe to re-run.
set -euo pipefail
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

info() { printf "\033[1;34m==>\033[0m %s\n" "$*"; }
ok()   { printf "\033[1;32m✔\033[0m %s\n" "$*"; }

# 1. Xcode CLT (needed for git, brew)
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools..."
  xcode-select --install || true
  echo "  Rerun this script after CLT finishes installing."
  exit 0
fi

# 2. Homebrew
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  ok "Homebrew present"
fi

# 3. Clone / update dotfiles
if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
  info "Cloning dotfiles..."
  git clone --recurse-submodules git@github.com:SumanthPal/dotfiles.git "$DOTFILES_DIR" 2>/dev/null \
    || git clone --recurse-submodules https://github.com/SumanthPal/dotfiles.git "$DOTFILES_DIR"
else
  info "Updating dotfiles..."
  git -C "$DOTFILES_DIR" pull --rebase --autostash || true
  git -C "$DOTFILES_DIR" submodule update --init --recursive || true
fi
cd "$DOTFILES_DIR"

# 4. Brew bundle (everything in Brewfile)
if [[ -f Brewfile ]]; then
  info "brew bundle (this takes a few minutes on first run)..."
  brew bundle --file=Brewfile || true
else
  echo "No Brewfile found — skipping brew bundle"
fi

# 5. Stow — link dotfiles into $HOME
info "Stowing dotfiles..."
brew list stow &>/dev/null || brew install stow
# herdr runtime files (plugins.json etc.) are gitignored; --adopt avoids conflicts if they exist pre-stow
for pkg in zsh bash git vim tmux agents herdr nvim; do
  if [[ -d "$pkg" ]]; then
    echo "  stow $pkg"
    if [[ "$pkg" == "herdr" ]]; then
      stow --adopt -t "$HOME" -R "$pkg" 2>&1 | sed 's/^/    /' || true
    else
      stow -t "$HOME" -R "$pkg" 2>&1 | sed 's/^/    /' || true
    fi
  fi
done

# 6. oh-my-zsh (only if not already)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
else
  ok "oh-my-zsh present"
fi

# oh-my-zsh plugins (if missing, brew versions already installed)
# zsh-autosuggestions, zsh-syntax-highlighting, zsh-history-substring-search are brew formulas;
# oh-my-zsh loads them via $plugins in .zshrc — no extra clone needed if brew installed.
# If you prefer git clones:
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || true

# 7. tmux plugin manager
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  info "Installing tpm (tmux plugin manager)..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || true
else
  ok "tpm present"
fi
echo "  → inside tmux, press prefix+I to install plugins"

# 8. git-lfs, gh auth hint
git lfs install 2>/dev/null || true

# 9. nvim lazy.nvim bootstrap — just opening nvim triggers it
info "Neovim plugins will auto-install on first nvim launch (lazy.nvim)"

# 10. Secrets
if [[ ! -f "$DOTFILES_DIR/zsh/.zshenv.local" && ! -f "$HOME/.zshenv.local" ]]; then
  info "Creating zsh/.zshenv.local from example (fill in your keys)..."
  cp "$DOTFILES_DIR/zsh/.zshenv.local.example" "$DOTFILES_DIR/zsh/.zshenv.local"
  chmod 600 "$DOTFILES_DIR/zsh/.zshenv.local"
  echo "  → edit $DOTFILES_DIR/zsh/.zshenv.local and add ZOTGPT_API_KEY etc."
  # ensure HOME link exists (stow already ran before this, so link manually to avoid drift on re-clone)
  if [[ ! -e "$HOME/.zshenv.local" ]]; then
    ln -sf "$DOTFILES_DIR/zsh/.zshenv.local" "$HOME/.zshenv.local" 2>/dev/null || true
  fi
fi
# drift fix: if repo has .zshenv.local but HOME does not (e.g., after git pull that added the file), link it
if [[ -f "$DOTFILES_DIR/zsh/.zshenv.local" && ! -e "$HOME/.zshenv.local" ]]; then
  ln -sf "$DOTFILES_DIR/zsh/.zshenv.local" "$HOME/.zshenv.local" 2>/dev/null || true
fi

ok "Done. Restart shell or: exec zsh"
echo ""
echo "Next steps:"
echo "  gh auth login"
echo "  nvim  # let lazy.nvim install"
echo "  tmux  # prefix+I"
