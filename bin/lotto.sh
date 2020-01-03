#!/bin/bash

if [ $# -le 1 ] ; then
  echo "Usage: $0 <numbercount> <out-of> [<count>]"
  echo "Example: $0 7 77 1"
  exit 1
fi

COUNT=1
NC=$1
OUTOF=$2
PRINTNUMBERS=true

if [ $# -gt 2 ] ; then
  COUNT=$3
fi

if [ $# -gt 3 ] ; then
  if [ "$4" == "-n" ] ; then
    PRINTNUMBERS=false
  else
    echo "unknown option passed: $4"
    exit 1
  fi
fi

MAX=$COUNT

while [ $COUNT -gt 0 ]
do
  if [ "$PRINTNUMBERS" = true ] ; then
    printf "$(($MAX-$COUNT +1 % $MAX)). "
  fi
  echo $(seq -w $OUTOF | sort -R | head -$NC | sort -n | fmt)
  COUNT=$(($COUNT-1))
done

