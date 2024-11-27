#!/bin/sh
SESSIONNAME="Desktop"
if [ $# -eq 1 ] ; then
  SESSIONNAME="$1"
fi

exec tmux new-session -A -s "$SESSIONNAME"
