#!/bin/bash

if [ -n "$TMUX" ]; then 
    tmux set -u prefix
    tmux set -u key-table
    tmux set -u status-style
    tmux set -u window-status-current-style
    tmux set -u window-status-current-format
    
    tmux refresh-client -S
else
    echo "not in a tmux session"
    exit 1
fi
