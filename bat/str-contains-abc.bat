@setlocal enableextensions
@echo off

set str1=%~1

echo %str1%

if not "%str1:abc=%" == "%str1%" echo "%str1%" contains abc

endlocal
