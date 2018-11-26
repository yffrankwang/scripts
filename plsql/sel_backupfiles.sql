set echo off
set feedback off
set verify off
set linesize 500
set pages 100
set long 1000
set longchunksize 1000

REM	----------------------------------------------------------------
REM	File name	: sel_backupfiles.sql
REM	Author		: sai
REM	Description	: BACKUP FILES view (SYS AS SYSDBA)
REM	----------------------------------------------------------------

clear col

col COL_FILE_NAME       form a40            head "FILE_NAME"
col COL_FILE_ID         form 9999           head "FILE_ID"
col COL_TABLESPACE_NAME form a10            head "TABLESPACE"
col COL_BYTES           form 999999999      head "SIZE(KB)"
col COL_BLOCKS          form 999999         head "BLOCKS"
col COL_STATUS          form a10            head "STATUS"
col COL_NAME            form a40            head "NAME"
col COL_GROUP           form 99             head "GROUP"
col COL_MEMBER          form a40            head "MEMBER"
col COL_TYPE            form a10            head "TYPE"
col USERNAME            new_value COL_USERNAME
col NOWTIME             new_value COL_NOWTIME

set termout off
SELECT to_char(SYSDATE,'yyyy/mm/dd hh24:mi:ss') NOWTIME FROM DUAL
/
SELECT USERNAME FROM USER_USERS
/
set termout on

prompt
prompt *********************************** DATE FILES VIEW ************************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

rem set pause on
rem set pause 'Please enter the key'

SELECT
      FILE_NAME       COL_FILE_NAME,
      TABLESPACE_NAME COL_TABLESPACE_NAME,
      BYTES           COL_BYTES,
      BLOCKS          COL_BLOCKS,
      STATUS          COL_STATUS
    FROM
      DBA_DATA_FILES
/

prompt
prompt ************************************ CONTROL FILES VIEW ************************************
prompt

SELECT
      NAME COL_NAME,
      STATUS COL_STATUS
    FROM
      V$CONTROLFILE
/

prompt
prompt ********************************** REDO LOG FILES VIEW **********************************
prompt

SELECT
      MEMBER    COL_MEMBER,
      GROUP#    COL_GROUP,
      STATUS    COL_STATUS,
      TYPE      COL_TYPE
    FROM
      V$LOGFILE
/


clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on
