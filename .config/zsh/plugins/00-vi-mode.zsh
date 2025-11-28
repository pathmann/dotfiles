PLUG_PATH=$HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh

# pos1 and end keys don't work after loading zvm, so re-source keys.zsh
function zvm_after_init() {
  source $HOME/.config/zsh/*keys.zsh
}

if [ -f $PLUG_PATH ]; then
  source $PLUG_PATH
fi
