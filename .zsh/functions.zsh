function extract()      # "extract Datei" extrahiert alle unten definierten Verzeichnisse
 # Credits: urukrama, Ubuntuforums.org
{
 local OUTDIR=$(pwd)
 local OLDPWD=$OUTDIR
 if (( $# == 2 ))
 then
   OUTDIR="$2"
 fi

 if [ -f $1 ] ; then
 case $1 in
 *.tar.bz2)   tar xvjf $1 -C $OUTDIR    ;;
 *.tar.gz)    tar xvzf $1 -C $OUTDIR    ;;
 *.tar.xz)    tar Jxvf $1 -C $OUTDIR     ;;
 *.bz2)       cd $OUTDIR; bunzip2 $1; cd $OLDPWD      ;;
 *.rar)       cd $OUTDIR; unrar x $1; cd $OLDPWD      ;;
 *.gz)        cd $OUTDIR; gunzip $1; cd $OLDPWD       ;;
 *.tar)       tar xvf $1 -C $OUTDIR      ;;
 *.tbz2)      tar xvjf $1 -C $OUTDIR    ;;
 *.tgz)       tar xvzf $1 -C $OUTDIR     ;;
 *.zip)       unzip $1 -d $OUTDIR        ;;
 *.Z)         cd $OUTDIR; uncompress $1; cd $OLDPWD   ;;
 *.7z)        7z x $1 -o$OUTDIR         ;;
 *)           echo "'$1' kann nicht mit extract entpackt werden!" ;;
 esac
 else
 echo "'$1' ist keine gültige Datei!"
 fi
}

function mkcd {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

function swapfiles()
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE $2
}

function yaourt {
  command yaourt "$@" | tee -a /tmp/yaourt.log
}

function lastfile {
    local X=1
    if [ -n "$1" ]; then
        X=$(echo ""$X" - "$1"" | bc)
    fi

    if [ ! -n "$2" ]; then
        ONDIR="./"
    else
        ONDIR="$2"
    fi

    echo $(command find "$ONDIR" -maxdepth 1 -type f | sort | tail -n$X | head -n 1)
}

function findin {
    if [ ! -n "$1" ]; then
        echo "Enter a directory name"
        return
    fi
    if [ ! -d $1 ]; then
        echo "Directory does not exist"
        return
    fi
    if [ ! -n "$2" ]; then
        echo "No search phrase given"
        return
    fi

    find $1 -type f -exec awk -v pattern="$2" '
        FNR == 1 {filename_printed = 0}
        $0 ~ pattern {
            if (!filename_printed) {
                print "\033[31m"FILENAME"\033[0m"
                filename_printed = 1
            }
            printf FNR": "
            print
        }' {} +
}

function do_git {
    local DIFFIT=false

    if [ -n "$1" ]; then
        if [ "$1" = "diff" ]; then
            if [[ ! "$*" == *-p* ]] then
                DIFFIT=true
                shift
            fi
        fi
    fi
    
    local DIFFLEN=0
    
    if [ "$DIFFIT" = true ]; then
        DIFF=$(command git --no-pager diff --color=always "$@")
        DIFFLEN=$(echo "$DIFF"|wc -l)

        if [ $DIFFLEN -gt 15 ]; then
            echo "$DIFF" | less -r
        else
            echo "$DIFF"
        fi
    else
        command git "$@"
    fi
}
