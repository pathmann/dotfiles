#!/bin/sh
# Params:
# $1: 1 for current pane, 0 otherwise
# $2: pane_pid
# $3: pane_current_path
# $4: pane_current_command
#

get_display_dirname() {
    if [ $1 -ef "$HOME" ]; then
        printf "~"
    else
        BASE=$(basename $(echo "$1" | sed "s#$HOME#~#g"))
        printf $BASE
    fi
}

get_display_command() {
    if [ "$1" = "ssh" ]; then
        printf "#[fg=red]"
        printf "$(ps -f --no-headers --ppid "$2" | awk {'print substr($0, index($0,$8)) '})"
        printf "#[fg=default]"
    elif [ "$1" = "sudo" ]; then
        printf "#[fg=colour166]"
        printf "$(ps -f --no-headers --ppid "$2" | awk {'print substr($0, index($0,$8)) '} | awk {'print substr($0, 6)'})"
        printf "#[fg=default]"
    elif [ "$1" = "bash" ] || [ "$1" = "sh" ]; then
        printf "$(ps -f --no-headers --ppid "$2" | basename $(awk {'print $9 '}))"
    else
        printf "$1"
    fi
}

if [ $# -gt 3 ]; then
    if [ "$1" -eq "1" ]; then
        printf "#[fg=yellow]"
    fi

    printf "(#I) "
    get_display_dirname $3

    if [ "$4" != "zsh" ]; then
        printf ": "
        get_display_command $4 $2
        printf " "
    fi

    printf "#F |"
    printf "\n"
fi

