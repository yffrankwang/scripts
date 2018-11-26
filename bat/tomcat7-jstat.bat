set BASEDIR=%~dp0
set FTMP=%BASEDIR%\jstat.tmp
set FOUT=%BASEDIR%\jstat.txt

set PID=0
for /f "tokens=2 delims=," %%i in ('tasklist /v /fo csv /nh /fi "IMAGENAME eq Tomcat7.exe"') do set PID=%%~i

echo ----------------------------------------               >> %FOUT%
echo %DATE% %TIME%                                          >> %FOUT%
echo PID=%PID%                                              >> %FOUT%
jstat.exe -gc %PID% >  %FTMP%
type %FTMP% >> %FOUT%

set SOU=0
set S1U=0
set EU=0
set OU=0
for /f "skip=1 tokens=3" %%i in (%FTMP%) do set S0U=%%~i
for /f "skip=1 tokens=4" %%i in (%FTMP%) do set S1U=%%~i
for /f "skip=1 tokens=6" %%i in (%FTMP%) do set EU=%%~i
for /f "skip=1 tokens=8" %%i in (%FTMP%) do set OU=%%~i
set /a MEM=(S0U+S1U+EU+OU)/1024

echo MEM=%MEM% MB                                           >> %FOUT%

del /y %FTMP%

