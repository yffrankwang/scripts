set echo off
set feedback off
set verify off
set linesize 500
set pages 100

REM	----------------------------------------------------------------
REM	File name	: sel_usertabprivs2.sql
REM	Author		: sai
REM	Description	: USER TABLE PRIVILEGE view (SYS AS SYSDBA)
REM	----------------------------------------------------------------

clear col

ACCEPT USER_NAME char prompt 'USER TABLE PRIVILEGE view ?> '

col COL_TABLE_NAME      form a30 head "TABLE_NAME"
col COL_PRIVILEGE       form a20 head "PRIVILEGE"
col COL_GRANTEE         form a20 head "GRANTEE"
col COL_OWNER           form a20 head "OWNER"
col USERNAME            new_value COL_USERNAME
col NOWTIME             new_value COL_NOWTIME

set termout off
SELECT to_char(SYSDATE,'yyyy/mm/dd hh24:mi:ss') NOWTIME FROM DUAL
/
SELECT USERNAME FROM USER_USERS
/
set termout on


prompt
prompt ******************************* &USER_NAME TABLE PRIVILEGE VIEW *********************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

rem set pause on
rem set pause 'Please enter the key'


SELECT
      GRANTEE     COL_GRANTEE,
      OWNER       COL_OWNER,
      TABLE_NAME  COL_TABLE_NAME,
      PRIVILEGE   COL_PRIVILEGE
    FROM
      DBA_TAB_PRIVS
    WHERE
      GRANTEE = UPPER('&USER_NAME')
    GROUP BY
      GRANTEE,
      OWNER,
      TABLE_NAME,
      PRIVILEGE
/

prompt
prompt ************************** &USER_NAME TABLE PRIVILEGE VIEW END ******************************
prompt

clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on
