eval "$(/opt/homebrew/bin/brew shellenv)"

# TeX (keep if you use LaTeX)
export PATH="/Library/TeX/texbin:$PATH"

# OrbStack integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
