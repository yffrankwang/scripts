set echo off
set feedback off
set verify off
set linesize 500

REM	----------------------------------------------------------------
REM	File name	ÅFsel_userroleprivs.sql
REM	Author		ÅFsai
REM	Description	ÅFUSER ROLE PRIVILEGE view
REM	----------------------------------------------------------------

clear col

col COL_USERNAME        form a30 head "USER_NAME"
col COL_GRANTED_ROLE    form a30 head "GRANTED_ROLE"
col USERNAME            new_value COL_USERNAME
col NOWTIME             new_value COL_NOWTIME

set termout off
SELECT to_char(SYSDATE,'yyyy/mm/dd hh24:mi:ss') NOWTIME FROM DUAL
/
SELECT USERNAME FROM USER_USERS
/
set termout on


prompt
prompt ******************************* USER GRANTED ROLE VIEW *********************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

rem set pause on
rem set pause 'Please enter the key'

SELECT
        USERNAME      COL_USERNAME ,
        GRANTED_ROLE  COL_GRANTED_ROLE
    FROM
        USER_ROLE_PRIVS
/

prompt
prompt *********************** USER GRANTED ROLE VIEW END *****************************
prompt

clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on
