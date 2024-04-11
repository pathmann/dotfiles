#!/usr/bin/bash
area=$(slurp -o -w 1 -c 'ff0000ff')
if [ "$?" == "0" ]; then
	echo "yep $area"

	area=( $(grep -Eo '[[:digit:]]+' <<<"$area") )

	spx=$(echo "${area[0]} +1" | bc)
	spy=$(echo "${area[1]} +1" | bc)
	width=$(echo "${area[2]} -2" | bc)
	height=$(echo "${area[3]} -2" | bc)

	area="$spx,$spy ${width}x$height"

	grim -g "$area" - | satty --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
fi
