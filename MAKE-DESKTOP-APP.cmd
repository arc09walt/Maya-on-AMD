@echo off
if exist "%~dp0maya-app.ico" goto make
echo maya-app.ico is not in this folder yet.
pause
exit /b 1
:make
set "HERE=%~dp0"
set "Q=powershell -NoProfile -Command"
set "L1=$ws = New-Object -ComObject WScript.Shell"
set "L2=$d = [Environment]::GetFolderPath('Desktop')"
set "L3=$sc = $ws.CreateShortcut($d + '\Maya.lnk')"
set "L4=$sc.TargetPath = '%HERE%Start-Maya.cmd'"
set "L5=$sc.WorkingDirectory = '%HERE%'"
set "L6=$sc.IconLocation = '%HERE%maya-app.ico,0'"
set "L7=$sc.Save()"
%Q% "%L1%; %L2%; %L3%; %L4%; %L5%; %L6%; %L7%"
echo Desktop app made - Maya is on the Desktop.
pause
