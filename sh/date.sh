#!/bin/sh

BASEDIR=$(dirname $0)
echo BASEDIR: $BASEDIR

NOW=`date "+%Y-%m-%d.%H%M%S"`
echo NOW: $NOW

LAST7D=`date --date '7 day ago' +%Y-%m-%d`
echo LAST7D: $LAST7D
