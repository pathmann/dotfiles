bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward


bindkey "^[[2~" yank                    # Insert
bindkey "^[[3~" delete-char             # Del
bindkey "^[[5~" up-line-or-history      # PageUp
bindkey "^[[6~" down-line-or-history    # PageDown
bindkey "^[e"   expand-cmd-path         # C-e for expanding path of typed command.
bindkey "^[[A"  up-line-or-search       # Up arrow for back-history-search.
bindkey "^[[B"  down-line-or-search     # Down arrow for fwd-history-search.
bindkey " "     magic-space             # Do history expansion on space.
bindkey '^O' push-line-or-edit

# in case we don't use vi-mode, we could use these:
# # delete word behind cursor
# bindkey '^[b' backward-kill-word
# # move cursor one word left
# bindkey '^[B' backward-word
# # delete word in front of cursor
# bindkey '^[w' kill-word
# # move cursor one word right
# bindkey '^[W' forward-word

case "$TERM" in
        xterm) #guake is returning xterm
                bindkey "^[OH" beginning-of-line
                bindkey "^[OF" end-of-line
        ;;
        linux|screen)
                bindkey "^[[1~" beginning-of-line       # Pos1
                bindkey "^[[4~" end-of-line             # End
        ;;
        *xterm*|(dt|k)term|alacritty)
                bindkey "^[[H"  beginning-of-line       # Pos1
                bindkey "^[[F"  end-of-line             # End
                bindkey "^[[7~" beginning-of-line       # Pos1
                bindkey "^[[8~" end-of-line             # End
        ;;
        rxvt|Eterm)
                bindkey "^[[7~" beginning-of-line       # Pos1
                bindkey "^[[8~" end-of-line             # End
        ;;
        tmux*)
                bindkey "^[[1~" beginning-of-line       # Pos1
                bindkey "^[[4~" end-of-line             # End
        ;;
esac
