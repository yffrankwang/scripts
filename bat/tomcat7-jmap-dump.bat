@echo off

set PID=0
for /f "tokens=2 delims=," %%i in ('tasklist /v /fo csv /nh /fi "IMAGENAME eq Tomcat7.exe"') do set PID=%%~i

set BASEDIR=%~dp0
set YMD=%date:~-10,4%%date:~-5,2%%date:~-2,2%
set time2=%time: =0%
set HMS=%time2:~0,2%%time2:~3,2%%time2:~6,2%
set OUT=%BASEDIR%\heap-%YMD%_%HMS%.bin

jmap.exe -dump:format=b,file=%OUT% %PID% 
