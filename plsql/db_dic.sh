#!/bin/sh
##########################################################################
# [FILENAME]
#	db_dic_hkei1.sh
# [SUMMARY]
#	法人（SMC）用DBディクショナリ情報取得スクリプト
# [HISTORY]
#	2002/05/20  svc A.Masuda    新規作成
# [COPYRIGHT]
#	KDDI
##########################################################################
. ./hkei_db1.rc

ERRMSG='syntax error: db_dic_hkei1.sh { before | after }'
#
#コマンドのパラメータチェック.NULLの場合は、プロシジャを終了する。
#
if [ "$1" ]; then
	COMMAND=$1
else
	echo $ERRMSG
	exit 1
fi

sqlplus ${CONNECT} << EOF
set trims on
set trim on
set head off
set pages 0
set long 100

spool ../log/user_tables_${COMMAND}_${USER}.lst
select TABLE_NAME || ',' || TABLESPACE_NAME
	from user_tables
	order by TABLE_NAME;
spool off

spool ../log/user_indexes_${COMMAND}_${USER}.lst
select INDEX_NAME || ',' || TABLE_NAME || ',' || UNIQUENESS || ',' || TABLESPACE_NAME
	from user_indexes
	order by TABLE_NAME || ',' || INDEX_NAME;
spool off

spool ../log/user_constraints_${COMMAND}_${USER}.lst
select CONSTRAINT_NAME || ',' || CONSTRAINT_TYPE || ',' || TABLE_NAME || ',' || R_CONSTRAINT_NAME || ',' || STATUS,SEARCH_CONDITION
	from user_constraints
	where (CONSTRAINT_NAME like '%CHK%' or CONSTRAINT_NAME like '%PK%' or CONSTRAINT_NAME like '%FK%')
	order by TABLE_NAME || ',' || CONSTRAINT_NAME;
spool off

spool ../log/user_tab_columns_${COMMAND}_${USER}.lst
select TABLE_NAME || ',' || COLUMN_NAME || ',' || DATA_TYPE || ',' || DATA_LENGTH || ',' || NULLABLE , DATA_DEFAULT
	from user_tab_columns
	order by TABLE_NAME || ',' || COLUMN_ID;
spool off

spool ../log/user_ind_columns_${COMMAND}_${USER}.lst
select INDEX_NAME || ',' || TABLE_NAME || ',' || COLUMN_NAME
	from user_ind_columns
	order by INDEX_NAME || ',' || COLUMN_POSITION;
spool off

spool ../log/user_tab_partitions_${COMMAND}_${USER}.lst
select TABLE_NAME || ',' || PARTITION_NAME || ',' || HIGH_VALUE_LENGTH || ',' || TABLESPACE_NAME,HIGH_VALUE
	from user_tab_partitions
	order by TABLE_NAME || ',' || PARTITION_NAME || ',' || PARTITION_POSITION;
spool off

spool ../log/user_ind_partitions_${COMMAND}_${USER}.lst
select INDEX_NAME || ',' || PARTITION_NAME || ',' || HIGH_VALUE_LENGTH || ',' || TABLESPACE_NAME,HIGH_VALUE
	from user_ind_partitions
	order by INDEX_NAME || ',' || PARTITION_POSITION;
spool off

spool ../log/user_db_links_${COMMAND}_${USER}.lst
select DB_LINK || ',' || USERNAME || ',' || HOST from user_db_links;
spool off

spool ../log/user_sequences_${COMMAND}_${USER}.lst
select SEQUENCE_NAME || ',' || MIN_VALUE || ',' || MAX_VALUE || ',' || INCREMENT_BY || ',' || CYCLE_FLAG || ',' || ORDER_FLAG || ',' || CACHE_SIZE
	from user_sequences
	order by SEQUENCE_NAME;
spool off

spool ../log/user_snapshots_${COMMAND}_${USER}.lst
select NAME || ',' || TABLE_NAME || ',' || MASTER || ',' || MASTER_LINK || ',' || STATUS,QUERY
	from user_snapshots
	order by NAME;
spool off

spool ../log/user_snapshot_logs_${COMMAND}_${USER}.lst
select MASTER || ',' || LOG_TABLE
	from user_snapshot_logs
	order by MASTER;
spool off

spool ../log/user_users_${COMMAND}_${USER}.lst
select USERNAME || ',' || DEFAULT_TABLESPACE || ',' || TEMPORARY_TABLESPACE
	from user_users;
spool off

EOF

exit 0
