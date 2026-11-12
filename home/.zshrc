DOTFILES="$HOME/.dotfiles"

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
  git
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source "$ZSH/oh-my-zsh.sh"

for file in "$DOTFILES"/shell/{exports,aliases,functions}.zsh; do
  [ -r "$file" ] && source "$file"
done

# nvm (manual install in ~/.nvm or from Homebrew)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
elif [ -s /opt/homebrew/opt/nvm/nvm.sh ]; then
  source /opt/homebrew/opt/nvm/nvm.sh
fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

command -v starship >/dev/null && eval "$(starship init zsh)"

# machine-specific stuff, not in the repo
[ -r "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
