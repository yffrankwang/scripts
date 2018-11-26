set echo off
set feedback off
set verify off
set linesize 500
set pages 100

REM	----------------------------------------------------------------
REM	File name	: sel_dbausers.sql
REM	Author		: sai
REM	Description	: DBA USER view (SYS AS SYSDBA)
REM	----------------------------------------------------------------

clear col

col COL_USERNAME              form a28 head "USER_NAME"
col COL_USER_ID               form 9999 head "USER_ID"
col COL_ACCOUNT_STATUS        form a16 head "ACCOUNT_STATUS"
col COL_LOCK_DATE             form a12 head "LOCK_DATE"
col COL_DEFAULT_TABLESPACE    form a16 head "DEFAULT_TABLESPACE"
col COL_TEMPORARY_TABLESPACE  form a16 head "TEMPORARY_TABLESPACE"
col COL_CREATED               form a12 head "CREATED"
col USERNAME                  new_value COL_USERNAME
col NOWTIME                   new_value COL_NOWTIME

set termout off
SELECT to_char(SYSDATE,'yyyy/mm/dd hh24:mi:ss') NOWTIME FROM DUAL
/
SELECT USERNAME FROM USER_USERS
/
set termout on


prompt
prompt *********************************** DBA USER VIEW ************************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

rem set pause on
rem set pause 'Please enter the key'


SELECT
        USERNAME                        COL_USERNAME ,
        USER_ID                         COL_USER_ID ,
        ACCOUNT_STATUS                  COL_ACCOUNT_STATUS ,
        to_char(LOCK_DATE,'yyyy/mm/dd') COL_LOCK_DATE ,
        DEFAULT_TABLESPACE              COL_DEFAULT_TABLESPACE ,
        TEMPORARY_TABLESPACE            COL_TEMPORARY_TABLESPACE ,
        to_char(CREATED,'yyyy/mm/dd')   COL_CREATED
    FROM
        DBA_USERS
    ORDER BY
        USERNAME
/

prompt
prompt ******************************* DBA USER VIEW END ********************************
prompt

clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on
