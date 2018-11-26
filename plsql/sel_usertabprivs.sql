set echo off
set feedback off
set verify off
set linesize 500
set pages 100

REM	----------------------------------------------------------------
REM	File name	: sel_usertabprivs.sql
REM	Author		: sai
REM	Description	: USER TABLE PRIVILEGE view 
REM	----------------------------------------------------------------

clear col

col COL_TABLE_NAME      form a30 head "TABLE_NAME"
col COL_PRIVILEGE       form a30 head "PRIVILEGE"
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
prompt ******************************* &COL_USERNAME TABLE PRIVILEGE VIEW *********************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

rem set pause on
rem set pause 'Please enter the key'


SELECT
      TABLE_NAME  COL_TABLE_NAME ,
      OWNER       COL_OWNER,
      PRIVILEGE   COL_PRIVILEGE
    FROM
      USER_TAB_PRIVS
/

prompt
prompt ************************** &COL_USERNAME TABLE PRIVILEGE VIEW END ******************************
prompt

clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on

