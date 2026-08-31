eval "$(/opt/homebrew/bin/brew shellenv)"

# TeX handled in .zshrc consolidated PATH block (typeset -U path avoids duplication)

# OrbStack integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
