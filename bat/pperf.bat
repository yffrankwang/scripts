@echo off

:loop

set fdate=%date%
set ftime=%time%

echo [%fdate% %ftime%] >> pperf.txt
wmic path Win32_PerfFormattedData_PerfProc_Process get IDProcess,Name,PercentProcessorTime,PercentUserTime,ThreadCount,WorkingSet >> pperf.txt
timeout /T 60

goto loop
