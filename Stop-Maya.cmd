@echo off
set "Q=powershell -NoProfile -Command"
set "K=(Get-NetTCPConnection -LocalPort 8080"
set "K=%K% -State Listen -ErrorAction SilentlyContinue)"
set "K=%K%.OwningProcess"
%Q% "%K% | ForEach-Object { Stop-Process -Id $_ -Force }"
echo Maya stopped.
pause
