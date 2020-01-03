#!/bin/bash

if [ $# -le 1 ] ; then
  echo "Usage: $0 <numbercount> <out-of> [<count>]"
  echo "Example: $0 7 77 1"
fi

COUNT=1
NC=$1
OUTOF=$2

if [ $# -gt 2 ] ; then
  COUNT=$3
fi

MAX=$COUNT

while [ $COUNT -gt 0 ]
do
  echo "$(($MAX-$COUNT +1 % $MAX)). " $(seq -w $OUTOF | sort -R | head -$NC | sort -n | fmt)
  COUNT=$(($COUNT-1))
done

