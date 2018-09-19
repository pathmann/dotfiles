if [ -f "/usr/share/zsh/site-contrib/fzf.zsh" ]; then
    source /usr/share/zsh/site-contrib/fzf.zsh
elif [ -f "/usr/share/fzf/key-bindings.zsh" ]; then
    source /usr/share/fzf/key-bindings.zsh
fi

if [ -f "/usr/share/zsh/site-functions/_fzf" ]; then
    source /usr/share/zsh/site-functions/_fzf
elif [ -f "/usr/share/fzf/completion.zsh" ]; then
    source /usr/share/fzf/completion.zsh
fi

