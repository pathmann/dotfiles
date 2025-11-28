if [ -f /usr/bin/fzf ]; then
  source <(fzf --zsh)

  bindkey -r '^T'
  bindkey '^f' fzf-file-widget
fi
