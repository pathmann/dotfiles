#!/bin/bash

action="logout"

for arg in "$@"; do
  case $arg in
    --reboot)
      action="reboot"
      shift
      ;;
    --shutdown)
      action="shutdown"
      shift
      ;;
    --logout)
      action="logout"
      shift
      ;;
    *)
      echo "Unknown argument: $arg"
      exit 1
      ;;
  esac
done

# gracefully shutdown chromium to not have the annoying restore tabs question and restore tabs automatically
pkill --signal TERM chromium

case $action in
  "logout")
    # killall -9 Hyprland || killall -9 sway 
    if pgrep -x Hyprland > /dev/null; then
      hyprctl dispatch exit || pkill -x Hyprland
    elif pgrep -x sway > /dev/null; then
      swaymsg exit || pkill -x sway
    fi
    ;;
  "reboot")
    systemctl reboot
    ;;
  "shutdown")
    systemctl poweroff
    ;;
esac

