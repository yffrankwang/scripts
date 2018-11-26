if "%1" == "" (
  echo Missing service name.
  exit /b 1
)

sc stop %1


:stopq
rem cause a ~10 second sleep before checking the service state
rem ping 127.0.0.1 -n 10 -w 1000 > nul
timeout /t 10

sc query %1 | find /I "STATE" | find "STOPPED"
if errorlevel 1 goto :stopq


sc start %1

:startq
rem cause a ~10 second sleep before checking the service state
rem ping 127.0.0.1 -n 10 -w 1000 > nul
timeout /t 10

sc query %1 | find /I "STATE" | find "RUNNING"
if errorlevel 1 goto :startq

sc query %1
