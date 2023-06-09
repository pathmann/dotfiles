#!/bin/bash

#Usage: $0 [-b|--buffered] [<count>] 
#where -b means buffered output after a keypress

wait_for_keypress () {
  echo "Press any key to continue"
  while [ true ] ; do
    read -t 3 -n 1
    if [ $? = 0 ] ; then
      return 0
    fi
  done
}

COUNT=1
BUFFERING=false

while [[ $# -gt 0 ]]; do
  case $1 in
    -b|--buffered)
      BUFFERING=true
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      COUNT=$1
      shift
      ;;
  esac
done

for i in $(seq 1 $COUNT) ; 
do
  printf "$i. "
  echo "$(lotto.sh 5 50 1 -n)"
  echo "   $(lotto.sh 2 12 1 -n)"
  
  if [ $i -ne $COUNT ] && [ $BUFFERING = true ]; then
    wait_for_keypress
  fi
done

