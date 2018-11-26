set echo off
set feedback off
set verify off
set linesize 500
set pages 100

REM	----------------------------------------------------------------
REM	File name	: select_userindexes.sql
REM	Author		: sai
REM	Description	: INDEX list detail view
REM	----------------------------------------------------------------

clear col

col COL_INDEX_NAME        form a30 head "INDEX_NAME"
col COL_INDEX_TYPE        form a10 head "INDEX_TYPE"
col COL_TABLE_OWNER       form a10 head "OWNER"
col COL_TABLE_NAME        form a30 head "TABLE_NAME"
col COL_TABLE_TYPE        form a10 head "TABLE_TYPE"
col COL_UNIQUENESS        form a10 head "UNIQUE"
col COL_TABLESPACE_NAME   form a10 head "TABLESPACE"
col COL_INI_TRANS         form 9999 head "INI_TRANS"
col COL_MAX_TRANS         form 9999 head "MAX_TRNAS"
col USERNAME              new_value COL_USERNAME
col NOWTIME               new_value COL_NOWTIME

set termout off
SELECT to_char(SYSDATE,'yyyy/mm/dd hh24:mi:ss') NOWTIME FROM DUAL
/
SELECT USERNAME FROM USER_USERS
/
set termout on


prompt
prompt ******************************* INDEX LIST DETAIL VIEW *********************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

REM set pause on
REM set pause 'Please enter the key'

SELECT
         INDEX_NAME       COL_INDEX_NAME ,
         INDEX_TYPE       COL_INDEX_TYPE ,
         TABLE_OWNER      COL_TABLE_OWNER ,
         TABLE_NAME       COL_TABLE_NAME ,
         TABLE_TYPE       COL_TABLE_TYPE ,
         UNIQUENESS       COL_UNIQUENESS ,
         TABLESPACE_NAME  COL_TABLESPACE_NAME ,
         INI_TRANS        COL_INI_TRANS ,
         MAX_TRANS        COL_MAX_TRANS
    FROM USER_INDEXES
    ORDER BY INDEX_NAME
/

prompt
prompt *************************** INDEX LIST DETAIL END *****************************
prompt

clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on
