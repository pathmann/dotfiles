#!/bin/sh

if [[ -e "/etc/customizepkg.d/$(basename $(pwd))" ]]; then
    FOUND=0

    for i in "$@" ; do
        if [[ $i == "-cf" ]]; then
            FOUND=$(($FOUND|1))

            if [[ $FOUND == 3 ]]; then
                break
            fi
        elif [[ $i == "--noconfirm" ]] ; then
            FOUND=$(($FOUND|2))

            if [[ $FOUND == 3 ]]; then
                break
            fi
        fi
    done

    if [[ $FOUND == 3 ]]; then
        customizepkg --modify >&2
    fi
fi

exec makepkg ${@}
