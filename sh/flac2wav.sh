#!/bin/bash

b=$1

if [ -z "$1" ]; then
  b=2048
fi

for f in *.flac; do
  avconv -i "$f" -v $b  "${f[@]/%flac/wav}"
done
