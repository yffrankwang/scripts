set echo off
set feedback off
set verify off
set linesize 500
set pages 100
set long 1000
set longchunksize 1000

REM	----------------------------------------------------------------
REM	File name	: sel_dbadatafiles.sql
REM	Author		: sai
REM	Description	: DBA DATA FILES view (SYS AS SYSDBA)
REM	----------------------------------------------------------------

clear col

col COL_FILE_NAME       form a40            head "FILE_NAME"
col COL_FILE_ID         form 9999           head "FILE_ID"
col COL_TABLESPACE_NAME form a10            head "TABLESPACE"
col COL_BYTES_DF        form 999999999      head "SIZE(KB)"
col COL_BLOCKS          form 999999         head "BLOCKS"
col COL_STATUS          form a10            head "STATUS"
col COL_AUTOEXTENSIBLE  form a8             head "AUTOEXTENSIBLE"
col COL_MAXBYTES        form 99999999999999 head "MAXBYTES"
col COL_MAXBLOCKS       form 999999999      head "MAXBLOCKS"
col COL_BYTES_FS        form 999999999      head "BYTES_FS(KB)"
col COL_PERSENT         form 99.99          head "PERSENT(%)"
col USERNAME            new_value COL_USERNAME
col NOWTIME             new_value COL_NOWTIME

set termout off
SELECT to_char(SYSDATE,'yyyy/mm/dd hh24:mi:ss') NOWTIME FROM DUAL
/
SELECT USERNAME FROM USER_USERS
/
set termout on

prompt
prompt *********************************** TABLESPACE VIEW ************************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

rem set pause on
rem set pause 'Please enter the key'

SELECT
    df.FILE_NAME        COL_FILE_NAME ,
    df.FILE_ID          COL_FILE_ID ,
    df.TABLESPACE_NAME  COL_TABLESPACE_NAME ,
    (df.BYTES/1024)     COL_BYTES_DF ,
    (fs.BYTES/1024)     COL_BYTES_FS ,
    (fs.BYTES/df.BYTES*100) COL_PERSENT ,
    df.BLOCKS           COL_BLOCKS ,
    df.STATUS           COL_STATUS ,
    df.AUTOEXTENSIBLE   COL_AUTOEXTENSIBLE
    FROM DBA_DATA_FILES df ,
     (SELECT
          TABLESPACE_NAME,
          SUM(BYTES) BYTES
        FROM
          DBA_FREE_SPACE
          GROUP BY TABLESPACE_NAME) fs
        WHERE df.TABLESPACE_NAME = fs.TABLESPACE_NAME
        ORDER BY df.FILE_NAME
/

prompt
prompt ******************************* TABLESPACE VIEW END ********************************
prompt

clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on
