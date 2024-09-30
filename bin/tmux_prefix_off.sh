#!/bin/bash

if [ -n "$TMUX" ]; then 
    tmux set prefix None
    tmux set key-table off
    tmux set status-style "fg=$color_status_text,bg=$color_window_off_status_bg"
    tmux set window-status-current-format "#[fg=$color_window_off_status_bg,bg=$color_window_off_status_current_bg]$separator_powerline_right#[default] #I:#W# #[fg=$color_window_off_status_current_bg,bg=$color_window_off_status_bg]$separator_powerline_right#[default]"
    tmux set window-status-current-style "fg=$color_dark,bold,bg=$color_window_off_status_current_bg"
    
    pane_in_mode=$(tmux display-message -p '#{pane_in_mode}')
    if [ "$pane_in_mode" -eq 1 ]; then
        tmux send-keys -X cancel
    fi
    
    tmux refresh-client -S
else
    echo "not in a tmux session"
    exit 1
fi
