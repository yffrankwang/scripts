#!/bin/sh

find . -type f -regex .*.$1 -exec wc -l {} \; | awk '{print $1}' | awk '{s+=$1} END {print s}'
