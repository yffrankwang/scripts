#!/bin/bash

for f in *.wav; do
  avconv -i "$f"  "${f[@]/%wav/flac}"
done

