#!/bin/sh
if pgrep -x "wofi" > /dev/null
then
    pkill wofi
else
    wofi --insensitive --show drun
fi
