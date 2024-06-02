#!/bin/sh
trap 'hyprctl dispatch focuscurrentorlast; hyprctl dispatch focuscurrentorlast' EXIT
hyprlock
