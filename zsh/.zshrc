# 8. Completions (Optimized)
fpath=($HOME/.local/share/zsh-completion/completions $fpath)
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
  compinit -C
else
  compinit
fi
ZSH_THEME="robbyrussell"

# 2. Path & Environment (Consolidated)
typeset -U path  # Prevents PATH from getting duplicate entries
path=(
  "/opt/homebrew/opt/llvm/bin"
  "/Library/TeX/texbin"
  "$HOME/.local/bin"
  "$HOME/Library/Python/3.10/bin"
  "$HOME/.opencode/bin"
  "$HOME/.bun/bin"
  $path
)
export PATH
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun"
export GOOGLE_VERTEX_LOCATION=us-central1
export GOOGLE_VERTEX_PROJECT=instinct-459021
export ZOTGPT_API_KEY="93cdec49879a42d0ae260fb416e7489a"
# 3. Zsh Options
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT AUTO_CD
setopt APPEND_HISTORY SHARE_HISTORY HIST_EXPIRE_DUPS_FIRST 
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_VERIFY EXTENDED_HISTORY
HISTSIZE=10000
SAVEHIST=10000
export VISUAL="nvim"
# 4. Plugins (Removed 'z' since you use 'zoxide')
plugins=(
    git zsh-autosuggestions zsh-syntax-highlighting 
    zsh-history-substring-search sudo extract dirhistory macos
)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8a8a8a,bold"
source $ZSH/oh-my-zsh.sh

# 5. Tool Initializations (Late loading improves speed)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"
eval $(thefuck --alias)
[[ -r "/opt/homebrew/opt/mcfly/mcfly.zsh" ]] && source "/opt/homebrew/opt/mcfly/mcfly.zsh"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# 6. Aliases
alias v='nvim'
alias cl="clear"
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias rm='rm -i'
alias help="tldr"

# Git Aliases
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"

# Modern Replacements
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias lt="eza -T --icons --git-ignore"
alias find="fd"
alias cat="bat"

# 7. Custom Functions (The "Power User" stuff)

# Fast C++ Run
runcpp() {
    [[ -z "$1" ]] && { echo "Usage: runcpp filename.cpp"; return 1 }
    g++ -std=c++17 -O2 "$1" -o /tmp/a.out && /tmp/a.out
}

# Create and enter directory
mkcd() { mkdir -p "$1" && cd "$1"; }

# Simple FZF file opener (opens in nvim)
fo() {
  local file
  file=$(fd --type f | fzf --preview 'bat --color=always {}')
  [[ -n "$file" ]] && nvim "$file"
}





# Added by Antigravity CLI installer
export PATH="/Users/sumanth/.local/bin:$PATH"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
