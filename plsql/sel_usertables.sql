set echo off
set feedback off
set verify off
set linesize 500
set pages 100

REM	----------------------------------------------------------------
REM	File name	: sel_usertables.sql
REM	Author		: sai
REM	Description	: TABLE DETAIL view
REM	----------------------------------------------------------------

clear col

col COL_TABLE_NAME      form a30 head "TABLE_NAME"
col COL_TABLESPACE_NAME form a12 head "TABLESPACE"
col COL_NUM_ROWS        form 99999999 head "NUM_ROWS"
col COL_LAST_ANALYZED   form a10 head "LAST_ANALYZED"
col COL_INITIAL_EXTENT  form 999999999 head "INITIAL|EXTENT"
col COL_NEXT_EXTENT     form 999999999 head "NEXT|EXTENT"
col COL_MIN_EXTENTS     form 999 head "MIN|EXTENTS"
col COL_MAX_EXTENTS     form 9999999999 head "MAX|EXTENTS"
col COL_PCT_INCREASE    form 999 head "PCT|INCREASE"
col COL_FREELISTS       form 999 head "FREELISTS"
col COL_FREELIST_GROUPS form 999 head "FREELIST|GROUPS"
col USERNAME            new_value COL_USERNAME
col NOWTIME             new_value COL_NOWTIME

set termout off
SELECT to_char(SYSDATE,'yyyy/mm/dd hh24:mi:ss') NOWTIME FROM DUAL
/
SELECT USERNAME FROM USER_USERS
/
set termout on


prompt
prompt ******************************* TABLE LIST DETAIL VIEW *********************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

REM set pause on
REM set pause 'Please enter the key'

SELECT
        TABLE_NAME      COL_TABLE_NAME,
        TABLESPACE_NAME COL_TABLESPACE_NAME,
        NUM_ROWS        COL_NUM_ROWS,
        INITIAL_EXTENT  COL_INITIAL_EXTENT,
        NEXT_EXTENT     COL_NEXT_EXTENT,
        MIN_EXTENTS     COL_MIN_EXTENTS,
        MAX_EXTENTS     COL_MAX_EXTENTS,
        PCT_INCREASE    COL_PCT_INCREASE,
        FREELISTS       COL_FREELISTS,
        FREELIST_GROUPS COL_FREELIST_GROUPS,
        LAST_ANALYZED   COL_LAST_ANALYZED
    FROM
        USER_TABLES
    ORDER BY
        TABLE_NAME
/

prompt
prompt *************************** TABLE LIST DETAIL VIEW END *****************************
prompt

clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on
