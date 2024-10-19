#!/bin/bash

ALLDIR="$HOME/wallpapers/all"
WALLPAPER_PATH="$HOME/wallpapers/wallpaper.png"
BLURRED_PATH="$HOME/wallpapers/wallpaper-blurred.png"
SQUARED_PATH="$HOME/wallpapers/wallpaper-squared.png"

SQGRAV="Center"

if [ $# -le 0 ] ; then
  echo "Usage: $0 [--squared-gravity <magick-gravity>] <new-wallpaper>"
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    --squared-gravity)
      shift

      if [ $# -eq 0 ]; then
        echo "missing gravity parameter, see magick -gravity help"
        exit 1
      fi
      SQGRAV=$1
      shift
      ;;
    -*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      FNAME=$1
      shift
      ;;
  esac
done

if [ -z "$FNAME" ]; then
  echo "No file given"
  exit 1
fi

NEWFILE=$(basename "$FNAME")
NEWEXT=$(echo "${NEWFILE##*.}" | tr '[:upper:]' '[:lower:]')
NEWFILEBASE="${NEWFILE%.*}"

if [ ! -d  "$ALLDIR" ]; then
    mkdir -p "$ALLDIR"
fi


if [ "${ALLDIR}/${NEWFILE}" != $(realpath "$FNAME") ]; then
    if [ -f "${ALLDIR}/${NEWFILE}" ]; then
        CURDATE=$(date '%Y-%m-%d')
        cmp --silent "${ALLDIR}/${NEWFILE}" "$FNAME" || cp "$FNAME" "${ALLDIR}/${NEWFILEBASE}_${CURDATE}.${NEWEXT}"
    else
        cp "$FNAME" "${ALLDIR}"
    fi
fi

if [ "$NEWEXT" != "png" ]; then
    magick "$FNAME" "$WALLPAPER_PATH"
else
    cp "$FNAME" "$WALLPAPER_PATH"
fi

magick "$WALLPAPER_PATH" -resize 75% "$BLURRED_PATH"
magick "$BLURRED_PATH" -blur 50x30 "$BLURRED_PATH"
magick "$WALLPAPER_PATH" -gravity $SQGRAV -extent 1:1 "$SQUARED_PATH"


