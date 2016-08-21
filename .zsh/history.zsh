#how many commands should be saved in history
export HISTSIZE=2000
#where should the history be stored
export HISTFILE="$HOME/.zsh/history"
#without this, the history won't be saved
export SAVEHIST=$HISTSIZE
#don't save duplicates in history
setopt hist_ignore_all_dups

#History will ignore spaces, so you can call commands with a leading space to not save it to history
setopt hist_ignore_space
