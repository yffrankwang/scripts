set echo off
set feedback off
set verify off
set linesize 500
set pages 100

REM	----------------------------------------------------------------
REM	File name	: sel_userindcolumns.sql
REM	Author		: sai
REM	Description	: INDEX list view
REM	----------------------------------------------------------------

clear col

col COL_INDEX_NAME        form a30      head "INDEX_NAME"
col COL_TABLE_NAME        form a30      head "TABLE_NAME"
col COL_COLUMN_NAME       form a16      head "COLUMN_NAME"
col COL_COLUMN_POSITION   form 99999999 head "POSITION"
col COL_COLUMN_LENGTH     form 99999999 head "COLUMN_LENGTH"
col COL_CHAR_LENGTH       form 99999999 head "COLUMN_CHAR_LENGTH"
col COL_DESCEND           form  a10     head "DESCEND"
col USERNAME              new_value COL_USERNAME
col NOWTIME               new_value COL_NOWTIME

set termout off
SELECT to_char(SYSDATE,'yyyy/mm/dd hh24:mi:ss') NOWTIME FROM DUAL
/
SELECT USERNAME FROM USER_USERS
/
set termout on


prompt
prompt ********************************* INDEX LIST VIEW ***********************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

REM set pause on
REM set pause 'Please enter the key'

SELECT
        INDEX_NAME       COL_INDEX_NAME ,
        TABLE_NAME       COL_TABLE_NAME ,
        COLUMN_NAME      COL_COLUMN_NAME ,
        COLUMN_POSITION  COL_COLUMN_POSITION ,
        COLUMN_LENGTH    COL_COLUMN_LENGTH ,
--        CHAR_LENGTH      COL_CHAR_LENGTH ,
        DESCEND          COL_DESCEND
    FROM
        USER_IND_COLUMNS
    ORDER BY
        INDEX_NAME
/

prompt
prompt ***************************** INDEX LIST END *******************************
prompt

clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on
