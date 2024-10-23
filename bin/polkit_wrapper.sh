#!/bin/bash
TRY_PATHS=(/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 /usr/libexec/polkit-gnome-authentication-agent-1)
for trypath in "${TRY_PATHS[@]}"; do
  if [ -f "$trypath" ]; then
    "$trypath"
    exit 0
  fi
done

exit 1
