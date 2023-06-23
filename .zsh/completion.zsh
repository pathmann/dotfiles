fpath=("$HOME/.zsh/completion" $fpath)

autoload -Uz compinit
compinit

if [ -f /usr/bin/zoxide ]; then
  eval "$(zoxide init zsh)"
fi

if [ -f ~/.zsh/nocorrect ]; then
    while read -r COMMAND; do
        if [ command -v -- "$COMMAND" > /dev/null 2>&1 ]; then
            alias $COMMAND="nocorrect $COMMAND"
        fi
    done < ~/.zsh/nocorrect
fi

#enable case-insensitive matches
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Enable automatic rehash of commands
_force_rehash() { 
  (( CURRENT == 1 )) && rehash 
  return 1   # Because we didn't really complete anything 
} 
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete

zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'
zstyle ':completion:*:sudo::' environ PATH="/sbin:/usr/sbin:$PATH" HOME="/root"

#allow zsh to correct commands (eg. call "lsa" and zsh will ask, if you mean "ls")
setopt correctall

# Falls die TAB-Completion lange dauert, währenddessen Punkte anzeigen :)
expand-or-complete-with-dots() {
 echo -n "\e[31m......\e[0m"
 zle expand-or-complete
 zle redisplay
}
zle -N expand-or-complete-with-dots

bindkey "^I" expand-or-complete-with-dots
