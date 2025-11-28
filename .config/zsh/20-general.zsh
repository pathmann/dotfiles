HOSTNAME=${hostname}
if [[ "$HOSTNAME" == "heisenberg" ]]; then
  export PROJECT_DIR=/media/PROJECTS/Active/
else
  export PROJECT_DIR=$HOME/Projects/
fi
setopt autocd

if [ -f /usr/bin/nvim ]; then
  export EDITOR=nvim
elif [ -f /usr/bin/vim ]; then
  export EDITOR=vim
elif [ -f /usr/bin/vi ]; then
  export EDITOR=vi
else
  export EDITOR=nano
fi
