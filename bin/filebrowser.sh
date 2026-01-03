#!/bin/bash

if [ -f /usr/bin/nautilus ]; then
  /usr/bin/nautilus "$@"
elif [ -f /usr/bin/pcmanfm ]; then
  /usr/bin/pcmanfm "$@"
fi

