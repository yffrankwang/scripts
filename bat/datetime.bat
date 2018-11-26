set fdate=%date:~-10,4%%date:~-5,2%%date:~-2,2%
set time2=%time: =0%
set ftime=%time2:~0,2%%time2:~3,2%%time2:~6,2%

echo %fdate%_%ftime%

