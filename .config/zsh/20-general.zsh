export PROJECT_DIR=/media/PROJECTS/Active/
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
