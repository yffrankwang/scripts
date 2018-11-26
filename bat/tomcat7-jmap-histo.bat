@echo off

set PID=0
for /f "tokens=2 delims=," %%i in ('tasklist /v /fo csv /nh /fi "IMAGENAME eq Tomcat7.exe"') do set PID=%%~i

echo Tomcat7.exe: %PID%

set BASEDIR=%~dp0
set OUT=%BASEDIR%\tomcat7-histo.log
echo ------------------------------------------- >> %OUT%
echo [%date% %time%]  >> %OUT%
jmap.exe -histo %PID% >> %OUT%

