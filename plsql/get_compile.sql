set heading   off
set feedback off
spo recompile.sql
select 'set echo on' from dual;

SELECT DISTINCT
   'ALTER '
|| DECODE(SUBSTR(OBJECT_TYPE,1,7),'PACKAGE','PACKAGE',OBJECT_TYPE)
|| ' '||OWNER||'.'
|| OBJECT_NAME
|| ' COMPILE'
|| DECODE(SUBSTR(OBJECT_TYPE,1,7),'PACKAGE',' BODY;',';')    SQL_TEXT
FROM DBA_OBJECTS
WHERE STATUS = 'INVALID'
/

select 'set echo off' from dual;
spo off

