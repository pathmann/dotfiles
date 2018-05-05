function extract()      # "extract Datei" extrahiert alle unten definierten Verzeichnisse
 # Credits: urukrama, Ubuntuforums.org   
{
 if [ -f $1 ] ; then
 case $1 in
 *.tar.bz2)   tar xvjf $1     ;;
 *.tar.gz)    tar xvzf $1     ;;
 *.tar.xz)    tar Jxvf $1     ;;
 *.bz2)       bunzip2 $1      ;;
 *.rar)       unrar x $1      ;;
 *.gz)        gunzip $1       ;;
 *.tar)       tar xvf $1      ;;
 *.tbz2)      tar xvjf $1     ;;
 *.tgz)       tar xvzf $1     ;;
 *.zip)       unzip $1        ;;
 *.Z)         uncompress $1   ;;
 *.7z)        7z x $1         ;;
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

function yaourt {
  command yaourt "$@" | tee /tmp/yaourt.log
}
