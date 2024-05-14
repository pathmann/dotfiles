#!/bin/bash

function handle {
  if [ -f "$HOME/bin/hyprland-eventhandler-openwindow.sh" ] && [ ${1:0:10} == "openwindow" ]; then
	IFS=","
	read -ra parsed_args <<< "${1:12}"
	"$HOME/bin/hyprland-eventhandler-openwindow.sh" "${parsed_args[@]}"
  fi
}

socat -t 100 -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read line; do handle "$line"; done
