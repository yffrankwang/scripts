set echo off
set feedback off
set verify off
set linesize 500
set pages 100

REM	----------------------------------------------------------------
REM	File name	: sel_tab.sql
REM	Author		: sai
REM	Description	: TABLE view
REM	----------------------------------------------------------------

clear col

col COL_TNAME       form a30 heading "TABLE_NAME"
col COL_TABTYPE     form a10 heading "TYPE"
col COL_CLUSTERID   form a16 heading "CLUSTER_ID"
col COL_CNT         form 999 heading "COUNT"
col COL_COMMENTS    form a300 heading "COMMENTS"
col USERNAME        new_value COL_USERNAME
col NOWTIME         new_value COL_NOWTIME

set termout off
SELECT to_char(SYSDATE,'yyyy/mm/dd hh24:mi:ss') NOWTIME FROM DUAL
/
SELECT USERNAME FROM USER_USERS
/
set termout on

prompt ********************************* TABLE LIST ***********************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

REM set pause on
REM set pause 'Please enter the key'


SELECT
    T.TNAME     COL_TNAME ,
    T.TABTYPE   COL_TABTYPE,
    CLUSTERID   COL_CLUSTERID,
    C.COMMENTS  COL_COMMENTS
    FROM
      TAB T,
      USER_TAB_COMMENTS C
    WHERE
      T.TNAME = C.TABLE_NAME(+)
/

SELECT TABTYPE COL_TABTYPE, COUNT(*) COL_CNT FROM TAB GROUP BY TABTYPE

/

prompt
prompt ***************************** TABLE LIST END *******************************
prompt

clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on

