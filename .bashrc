# per-interactive shell startup file

# maintain an env variable to keep track of where we store our dotfiles
# we'll assume Darwin (OSX), and check for Linux as an after thought
READLINK=$(which readlink)
[[ "$(uname)" == "Linux" ]] && READLINK="$READLINK -e"
export READLINK

export DOTFILES_DIR=$(dirname $($READLINK ~/.bashrc))

# load files in our bash.d dir
for file in "$DOTFILES_DIR"/bash.d/*.sh; do
  . "$file"
done

# Lastly, lets import our 'private' definitions.  If items are redefined
# likes SSH_DOMAIN, etc.  Then these will be the ones to take precedence
[[ -f ~/.bashrc.private ]] && \
  . ~/.bashrc.private
