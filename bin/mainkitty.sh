#!/bin/sh
kitty -o allow_remote_control=yes --listen-on unix:/tmp/mainkitty -e /home/thomas/bin/tmux_guake.sh Desktop
