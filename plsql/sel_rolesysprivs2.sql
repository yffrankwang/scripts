set echo off
set feedback off
set verify off
set linesize 500
set pages 100

REM	----------------------------------------------------------------
REM	File name	: sel_rolesysprivs2.sql
REM	Author		: sai
REM	Description	: SYSTEM PRIVILEGE view (SYS AS SYSDBA)
REM	----------------------------------------------------------------

clear col

ACCEPT ROLE_NAME char prompt 'SHOW ROLE ?> '

col COL_ROLE        form a30 head "ROLE_NAME"
col COL_PRIVILEGE   form a30 head "SYS_PRIVILEGE"
col USERNAME        new_value COL_USERNAME
col NOWTIME         new_value COL_NOWTIME

set termout off
SELECT to_char(SYSDATE,'yyyy/mm/dd hh24:mi:ss') NOWTIME FROM DUAL
/
SELECT USERNAME FROM USER_USERS
/
set termout on


prompt
prompt ******************************* &ROLE_NAME SYSTEM PRIVILEGE VIEW *********************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

rem set pause on
rem set pause 'Please enter the key'


SELECT
        ROLE      COL_ROLE ,
        PRIVILEGE COL_PRIVILEGE
    FROM
        ROLE_SYS_PRIVS
    WHERE
        ROLE = UPPER('&ROLE_NAME')
    GROUP BY
        ROLE,
        PRIVILEGE

/

prompt
prompt ******************************* &ROLE_NAME SYSTEM PRIVILEGE VIEW END *********************************
prompt

clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on
