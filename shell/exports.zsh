export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"

typeset -U path
path=(
  "$HOME/.local/bin"
  "$PNPM_HOME"
  "$BUN_INSTALL/bin"
  $path
)
