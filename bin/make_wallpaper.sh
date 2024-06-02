#!/bin/bash

ALLDIR="$HOME/wallpapers/all"
WALLPAPER_PATH="$HOME/wallpapers/wallpaper.png"
BLURRED_PATH="$HOME/wallpapers/wallpaper-blurred.png"
SQUARED_PATH="$HOME/wallpapers/wallpaper-squared.png"

if [ $# -ne 1 ] ; then
  echo "Usage: $0 <new-wallpaper>"
  exit 1
fi

NEWFILE=$(basename $1)
NEWEXT=$(echo "${NEWFILE##*.}" | tr '[:upper:]' '[:lower:]')
NEWFILEBASE="${NEWFILE%.*}"

if [ ! -d  "$ALLDIR" ]; then
    mkdir -p "$ALLDIR"
fi


if [ "${ALLDIR}/${NEWFILE}" != $(realpath "$1") ]; then
    if [ -f "${ALLDIR}/${NEWFILE}" ]; then
        CURDATE=$(date '%Y-%m-%d')
        cmp --silent "${ALLDIR}/${NEWFILE}" "$1" || cp "$1" "${ALLDIR}/${NEWFILEBASE}_${CURDATE}.${NEWEXT}"
    else
        cp "$1" "${ALLDIR}"
    fi
fi

if [ "$NEWEXT" != "png" ]; then
    convert "$1" "$WALLPAPER_PATH"
else
    cp "$1" "$WALLPAPER_PATH"
fi

magick "$WALLPAPER_PATH" -resize 75% "$BLURRED_PATH"
magick "$BLURRED_PATH" -blur 50x30 "$BLURRED_PATH"
magick "$WALLPAPER_PATH" -gravity Center -extent 1:1 "$SQUARED_PATH"


