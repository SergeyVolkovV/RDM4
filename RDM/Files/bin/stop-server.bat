@echo off
call "%DQC_HOME%\bin\onlinectl.bat" -config ..\etc\test.serverConfig stop
if not errorlevel 1 goto done
pause "Server shutdown failed. Press any key when ready"
:done