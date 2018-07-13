export GOPATH="$HOME/.config/go"

if [ -d "$HOME/.goenv" ] && [ "$(which goenv 2>/dev/null)" != "" ]; then
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
fi