@echo off
setlocal enabledelayedexpansion

:menu
cls
echo Proxy Configuration Script
echo 1. Disable Proxy
echo 2. Enable Proxy with Default Gateway
echo 3. Exit
set /p choice=Enter your choice (1-3): 

if "%choice%"=="1" goto disable_proxy
if "%choice%"=="2" goto enable_proxy
if "%choice%"=="3" exit
goto menu

:disable_proxy
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f
echo Proxy has been disabled.
pause
goto menu

:enable_proxy
:: Find the default gateway
for /f "tokens=3" %%i in ('route print ^| findstr "\<0.0.0.0\>"') do set "default_gateway=%%i"

if not defined default_gateway (
    echo Unable to find the default gateway. Please check your network connection.
    pause
    goto menu
)

echo Default Gateway (IP Proxy) found: %default_gateway%

set /p proxy_port=Enter Proxy Port: 

:: Validate port number
set "valid=true"
for /f "delims=0123456789" %%i in ("%proxy_port%") do set "valid=false"
if %proxy_port% leq 0 set "valid=false"
if %proxy_port% geq 65536 set "valid=false"

if "%valid%"=="false" (
    echo Invalid port number. Please enter a number between 1 and 65535.
    pause
    goto enable_proxy
)

:: Enable proxy with default gateway as IP and user-specified port
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "%default_gateway%:%proxy_port%" /f

echo Proxy has been enabled with IP %default_gateway% and Port %proxy_port%.
pause
goto menu
