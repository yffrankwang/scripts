#!/bin/bash

b=$1

if [ -z "$1" ]; then
  b=128
fi

for f in *.flac; do
  avconv -i "$f" -b:a ${b}k "${f[@]/%flac/mp3}"
done
