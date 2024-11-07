#!/bin/sh
if pgrep -x "fuzzel" > /dev/null
then
    pkill fuzzel
else
  fuzzel --lines 5
fi
