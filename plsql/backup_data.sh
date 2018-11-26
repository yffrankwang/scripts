#!/bin/sh
. ./hkei_db1.rc

if [ $# -ne 1 ]; then
	echo "*** 引数は１つだけ指定してください。 ***"
	echo "*** % > xxx.sh [file name] ***"
	exit 1
elif [ ! -f $1 ]; then
   	echo "*** 引数で指定されたファイルがありません。 ***"
	exit 1
fi

FNUM=$1

for record in `cat $FNUM | sed '/^$/d;/^#/d'`
do
	TAB=`echo "$record" | cut -f 1 -d ","`
	################
	# 1.Export	
	################
	echo $TAB >> ../log/exp_time1.log
	date >> ../log/exp_time1.log

	exp $CONNECT tables=$TAB file=../backup_db/smc/"exp_"$TAB".dmp" log=../log/"exp_"$TAB".log" indexes=y rows=y compress=n constraints=y direct=yes buffer=8024768

	date >> ../log/exp_time1.log

	################
	# 2.Compress	
	################
	compress -f ../backup_db/smc/"exp_"$TAB".dmp"
done

exit 0

