#!/bin/bash

for f in *.ape; do
  avconv -i "$f"  "${f[@]/%ape/flac}"
done

