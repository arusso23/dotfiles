# misc config
export LC_ALL="en_US.UTF-8"
export CLICOLOR='Yes'

# history config
setopt append_history     # multiple sessions share a file
setopt extended_history   # save timestamp and elapsed time
setopt hist_find_no_dups  # do not find duplicate commands
setopt hist_reduce_blanks # dont store blank lines
setopt inc_append_history # append as commands are called
setopt share_history      # share a history file
setopt hist_no_store      # do not store calls to the history cmd
setopt histignorespace    # ignore entries with with leading whitspace


[[ ! -d "$HOME/.zsh_history" ]] && mkdir "$HOME"/.zsh_history
HISTFILE="$HOME/.zsh_history/$HOSTNAME-$(date +%Y%m%d)"
HISTSIZE=500
SAVEHIST=200000

# ls config
export LSCOLORS='Exgxfxcxdxdxhbadbxbx'
export LS_OPTIONS='--color=auto'

# add $HOME/bin and $HOME/.local/bin to our path
[[ -d "$HOME"/.local/bin ]] && :prependpath "$HOME/.local/bin"

# Ensure my $HOME/bin directory comes before system bin dirs.
bidx=$path[(i)/bin]
hidx=$path[(i)$HOME/bin]
ubidx=$path[(i)/usr/bin]
ulbidx=$path[(i)/usr/local/bin]
if [[ $hidx -lt $ubidx ]] || [[ $hidx -lt $bidx || $hidx -lt $ulbidx ]]; then
  path=(${path:#$HOME/bin})
  path=($HOME/bin $path)
fi

[[ ${fpath[(ie)$DOTFILES_DIR]} -le ${#fpath} ]] || fpath=($DOTFILES_DIR/zsh.d/func $fpath)
autoload -Uz compinit && compinit
