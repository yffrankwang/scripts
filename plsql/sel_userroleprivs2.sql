set echo off
set feedback off
set verify off
set linesize 500
set pages 100

REM	----------------------------------------------------------------
REM	File name	: sel_userroleprivs2.sql
REM	Author		: sai
REM	Description	: USER PRIVILEGE view (SYS AS SYSDBA)
REM	----------------------------------------------------------------

clear col

col COL_USERNAME        form a30 head "USER_NAME"
col COL_GRANTED_ROLE    form a20 head "GRANTED_ROLE"
col COL_PRIVILEGE       form a30 head "PRIVILEGE"
col USERNAME            new_value COL_USERNAME
col NOWTIME             new_value COL_NOWTIME

set termout off
SELECT to_char(SYSDATE,'yyyy/mm/dd hh24:mi:ss') NOWTIME FROM DUAL
/
SELECT USERNAME FROM USER_USERS
/
set termout on


prompt
prompt ******************************* USER PRIVILEGE VIEW *********************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

rem set pause on
rem set pause 'Please enter the key'


SELECT
        U.USERNAME      COL_USERNAME ,
        U.GRANTED_ROLE  COL_GRANTED_ROLE,
        R.PRIVILEGE     COL_PRIVILEGE
    FROM
        USER_ROLE_PRIVS U, ROLE_SYS_PRIVS R
    WHERE
        U.GRANTED_ROLE = R.ROLE(+)
    GROUP BY
        U.USERNAME,
        U.GRANTED_ROLE,
        R.PRIVILEGE
/

prompt
prompt *********************** USER PRIVILEGE VIEW END *****************************
prompt

clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on
