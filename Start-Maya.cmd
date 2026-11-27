@echo off
setlocal
set "HERE=%~dp0"
set "Q=powershell -NoProfile -Command"
set "CHK=if (Test-NetConnection 127.0.0.1 -Port 8080"
set "CHK=%CHK% -InformationLevel Quiet)"
set "CHK=%CHK% { exit 0 } else { exit 1 }"
%Q% "%CHK%"
if %errorlevel%==0 goto open
set "P1=Start-Process '%HERE%project-maya\START-MAYA.bat'"
set "P2= -ArgumentList '--backend','hip','--gpu','0'"
set "P3= -WorkingDirectory '%HERE%project-maya'"
set "P3=%P3% -WindowStyle Hidden"
%Q% "%P1%%P2%%P3%"
set /a tries=0
:wait
timeout /t 5 /nobreak >nul
%Q% "%CHK%"
if %errorlevel%==0 goto open
set /a tries+=1
if %tries% lss 60 goto wait
echo Maya did not answer after 5 minutes.
echo Run project-maya\START-MAYA.bat to see the error.
pause
exit /b 1
:open
start "" msedge --app=http://127.0.0.1:8080/
exit /b 0
