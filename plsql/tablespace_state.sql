SET LINE 1000
REM SPOOL C:\tablespace_state.lst

/****************** TABLESPACE VIEW  **********************/

select  substr(a.TABLESPACE_NAME,1,10) TablespaceName,
 sum(a.bytes/1024/1024) totle_size,
 sum(nvl(b.free_space1/1024/1024,0)) free_space,
 sum(a.bytes/1024/1024)-sum(nvl(b.free_space1/1024/1024,0)) used_space,
 round((sum(a.bytes/1024/1024)-sum(nvl(b.free_space1/1024/1024,0)))*100/sum(a.bytes/1024/1024),2) used_percent
from    dba_data_files a,
 (select sum(nvl(bytes,0)) free_space1,file_id
  from   dba_free_space
  group  by file_id) b
where   a.file_id = b.file_id(+)
group by a.TABLESPACE_NAME
/


REM SPOOL OFF

PROMPT
PROMPT  =======================================================================
PROMPT  Please review the output file:  C:\tablespace_state.lst
PROMPT  =======================================================================



