#!/bin/sh

D=$1
N=$2

if [ -z "$D" ]; then
  echo "findrm.sh [Dir (default: .)] <Name>"
  exit 1
fi

if [ -z "$N" ]; then
  N=$D
  D=.
fi

echo "find $D -type f -name $N -exec rm {} +"
find $D -type f -name $N -exec rm {} +

