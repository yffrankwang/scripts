set echo off
set feedback off
set verify off
set linesize 500
set pages 100

REM	----------------------------------------------------------------
REM	File name	: sel_vparameter2.sql
REM	Author		: sai
REM	Description	: INITIAL PARAMETER view (SYS AS SYSDBA)
REM	----------------------------------------------------------------

clear col

col PARAM_NAME         form a36        head "PARAM_NAME"
col PARAM_VALUE        form a36        head "PARAM_VALUE"
col PARAM_TYPE         form a10        head "PARAM_TYPE"
col SES_MOD            form a12        head "SES_MOD"
col SYS_MOD            form a12        head "SYS_MOD"
col MOD                form a12        head "MOD"
col USERNAME           new_value COL_USERNAME
col NOWTIME            new_value COL_NOWTIME

set termout off
SELECT to_char(SYSDATE,'yyyy/mm/dd hh24:mi:ss') NOWTIME FROM DUAL
/
SELECT USERNAME FROM USER_USERS
/
set termout on

prompt
prompt *********************************** INITIAL PARAMETER LIST ************************************
prompt
prompt USER: &COL_USERNAME        TIME: &COL_NOWTIME
prompt

rem set pause on
rem set pause 'Please enter the key'

SELECT
        NAME PARAM_NAME,
        VALUE PARAM_VALUE,
          to_char(
            case
              WHEN TYPE=1 THEN 'ブール型'
              WHEN TYPE=2 THEN '文字列'
              WHEN TYPE=3 THEN '整数'
              WHEN TYPE=4 THEN 'ファイル'
              ELSE 'その他'
            end
            ) PARAM_TYPE,
        ISSES_MODIFIABLE SES_MOD,
        ISSYS_MODIFIABLE SYS_MOD,
        ISMODIFIED MOD
    FROM
        V$PARAMETER2
    ORDER BY
        NAME
/

prompt
prompt ******************************* INITIAL PARAMETER LIST END ********************************
prompt

clear col
set pause off
set pages 20
set linesize 80
set verify on
set feedback on
set echo on

