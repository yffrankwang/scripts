set echo off
set feedback off
set verify off
set linesize 500
set pages 100
set long 1000
set longchunksize 1000
set wrap on

REM	----------------------------------------------------------------
REM	File name	: sel_userviews.sql
REM	Author		: sai
REM	Description	: TABLE VIEW view
REM	----------------------------------------------------------------

clear col

col COL_VIEW_NAME       form a30 head "VIEW_NAME"
col COL_TEXT            form a1000 head "TEXT"
col USERNAME            new_value COL_USERNAME
col NOWTIME             new_value COL_NOWTIME

set termout off
SELECT to_char(SYSDATE,'yyyy/mm/dd hh24:mi:ss') NOWTIME FROM DUAL
/
SELECT USERNAME FROM USER_USERS
/
set termout on


prompt
prompt *********************************** VIEW LIST ************************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

rem set pause on
rem set pause 'Please enter the key'


SELECT
        VIEW_NAME    COL_VIEW_NAME ,
        TEXT         COL_TEXT
    FROM
        USER_VIEWS
    ORDER BY
        VIEW_NAME
/

prompt
prompt ******************************* VIEW LIST END ********************************
prompt

clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on
