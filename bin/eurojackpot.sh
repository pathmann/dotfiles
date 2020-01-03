#!/bin/bash

#Usage: $0 [<count>]

COUNT=1

if [ $# -ge 1 ] ; then
  COUNT=$1
fi

for i in $(seq 1 $COUNT) ; 
do
  printf "$i. "
  echo "$(lotto.sh 5 50 1 -n)"
  echo "   $(lotto.sh 2 10 1 -n)"
done

