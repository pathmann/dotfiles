#!/bin/sh
if [ $(pidof Hyprland) ]; then
    #not necessary anymore since bug https://github.com/hyprwm/hyprlock/issues/347 is fixed in >=hyprland-0.41.1
    #trap 'hyprctl dispatch focuscurrentorlast; hyprctl dispatch focuscurrentorlast' EXIT
    hyprlock
fi

if [ $(pidof sway) ]; then
    swaylock
fi
