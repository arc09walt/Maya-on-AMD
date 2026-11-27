@echo off
if exist "%~dp0maya-app.ico" goto build
echo maya-app.ico is not in this folder yet.
echo Drop maya-app.ico in here, then run this again.
pause
exit /b 1
:build
> "%~dp0desktop.ini" echo [.ShellClassInfo]
>> "%~dp0desktop.ini" echo IconResource=maya-app.ico,0
>> "%~dp0desktop.ini" echo IconFile=maya-app.ico
>> "%~dp0desktop.ini" echo IconIndex=0
attrib +s +h "%~dp0desktop.ini"
attrib +r "%~dp0."
echo Done - this folder now wears the M.
echo If it does not show, close this window and open the folder again.
pause
