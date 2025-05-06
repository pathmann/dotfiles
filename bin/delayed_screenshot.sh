#!/bin/bash

timeout=3
notify=false

for arg in "$@"; do
    case $arg in
        --notify)
            notify=true
            shift
            ;;
        [0-9]*)
            timeout=$arg
            shift
            ;;
        *)
            echo "Unknown argument: $arg"
            exit 1
            ;;
    esac
done

if $notify; then
    for ((i=timeout; i>0; i--)); do
        notify-send -t 500 "Screenshot in $i second(s)..."
        sleep 1
    done
else
    sleep "$timeout"
fi

grim -c - | satty --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png

