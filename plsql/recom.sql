set head off

spool tmp2.sql
select 'alter function ' || object_name || ' compile;' pkg
from user_objects
where object_type = 'FUNCTION'
and status = 'INVALID' ;
spool off
@tmp2


spool tmp2.sql
select 'alter procedure ' || object_name || ' compile;' pkg
from user_objects
where object_type = 'PROCEDURE'
and status = 'INVALID' ;
spool off
@tmp2

spool tmp2.sql
select 'alter package ' || object_name || ' compile;' pkg
from user_objects
where object_type = 'PACKAGE'
and status = 'INVALID' ;
spool off
@tmp2

spool tmp2.sql
select 'alter package ' || object_name || ' compile body;' pkg
from user_objects
where object_type = 'PACKAGE BODY'
and status = 'INVALID' ;
spool off
@tmp2

spool tmp2.sql
select 'alter trigger ' || object_name || ' compile;' trg
from user_objects
where object_type = 'TRIGGER'
and status = 'INVALID' ;
spool off
@tmp2

spool tmp2.sql
select 'alter view ' || object_name || ' compile;' 
from user_objects
where object_type = 'VIEW'
and status = 'INVALID' ;
spool off
@tmp2
set head on

spool invalid.lst
select object_type || ':' || object_name invalid_objects
from user_objects
where object_type in ('FUNCTION','PROCEDURE','PACKAGE','PACKAGE BODY', 'TRIGGER', 'VIEW'
)
and status = 'INVALID'
order by object_type,object_name;
spool off

!cat invalid.lst

