#!/bin/sh

if [ -z "$1" ]; then
  echo "cd2iso.sh <output>"
  exit 1
fi

dd if="/dev/sr0" of="$1"
