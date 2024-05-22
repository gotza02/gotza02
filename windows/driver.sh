@echo off
:: Check if the script is running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrator privileges.
    pause
    exit
)

:: Enable Windows Update service
sc config wuauserv start= auto
net start wuauserv

:: Use PowerShell to update drivers
powershell -NoProfile -ExecutionPolicy Bypass -Command "Install-Module -Name PSWindowsUpdate -Force"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Import-Module PSWindowsUpdate; Get-WUInstall -MicrosoftUpdate -AcceptAll -IgnoreReboot"

:: Disable Windows Update service after update
net stop wuauserv
sc config wuauserv start= demand

echo Driver update completed.
pause
