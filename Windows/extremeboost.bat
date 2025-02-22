@echo off
setlocal EnableDelayedExpansion
title Windows 11 Optimizer Pro
color 0A
echo Windows 11 Optimizer Pro - Enhanced Edition
echo Current Date: %date% %time%
echo Requires Administrator privileges.
echo.

:: Check for administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Administrative privileges required. Please run as administrator.
    pause
    exit /b 1
)

:: Log file setup
set "LogFile=Win11OptimizerPro_Log_%date:~-4%%date:~3,2%%date:~0,2%.txt"
echo [%date% %time%] Tool started > "%LogFile%"

:: Main Menu
:MainMenu
cls
echo Windows 11 Optimizer Pro
echo ---------------------------------------------
echo 1. Maximize Performance (Extreme Speed)
echo 2. Windows Features Customization
echo 3. Exit
echo ---------------------------------------------
set "choice="
set /p choice=Select an option (1-3): 
if not defined choice (
    echo [ERROR] No input provided. Please enter a number.
    pause
    goto MainMenu
)
if "%choice%"=="1" goto MaxPerformance
if "%choice%"=="2" goto WindowsFeatures
if "%choice%"=="3" goto ExitScript
echo [ERROR] Invalid option. Please select 1, 2, or 3.
pause
goto MainMenu

:: -------------------
:: Maximize Performance
:: -------------------
:MaxPerformance
cls
echo Optimizing for Extreme Speed...
echo WARNING: This applies aggressive tweaks for maximum performance.
echo Press any key to proceed, or Ctrl+C to cancel.
pause >nul

:: Preliminary Checks
echo Checking system specs...
for /f "tokens=2 delims==" %%a in ('wmic memorychip get Capacity /value ^| find "Capacity"') do (
    set "RAMBytes=%%a"
    set /a RAMMB=(%%a/1048576)
)
if not defined RAMMB (
    echo [WARNING] Could not detect RAM size. Defaulting to 8192 MB.
    set "RAMMB=8192"
    echo [%date% %time%] RAM detection failed, defaulted to 8192 MB >> "%LogFile%"
)
set /a RAMInitial=%RAMMB%*1.5
set /a RAMMax=%RAMMB%*3
echo [INFO] Detected RAM: %RAMMB% MB >> "%LogFile%"

for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /value ^| find "NumberOfCores"') do set "CPUCores=%%a"
if not defined CPUCores (
    echo [WARNING] Could not detect CPU cores. Defaulting to 4.
    set "CPUCores=4"
    echo [%date% %time%] CPU core detection failed, defaulted to 4 >> "%LogFile%"
)
echo [INFO] Detected CPU Cores: %CPUCores% >> "%LogFile%"

:: CPU Optimization
echo Optimizing CPU...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 99999999-9999-9999-9999-999999999999 2>nul
powercfg -setactive 99999999-9999-9999-9999-999999999999 2>nul || powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
if errorlevel 1 (
    echo [WARNING] Failed to set power plan. Continuing with default.
    echo [%date% %time%] Power plan setting failed >> "%LogFile%"
)
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLESCALING 0
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLE 0
powercfg -setactive SCHEME_CURRENT
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v IRQ8Priority /t REG_DWORD /d 1 /f >nul 2>&1
echo [%date% %time%] CPU optimized for maximum speed >> "%LogFile%"

:: RAM Optimization
echo Optimizing RAM...
for %%p in (OneDrive.exe Skype.exe Teams.exe Steam.exe Discord.exe) do (
    taskkill /f /im %%p 2>nul
    if not errorlevel 1 echo [%date% %time%] Process %%p terminated >> "%LogFile%"
)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v IoPageLockLimit /t REG_DWORD /d 1048576 /f >nul 2>&1
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=%RAMInitial%,MaximumSize=%RAMMax% >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Failed to set virtual memory. Check disk space or permissions.
    echo [%date% %time%] Virtual memory setting failed >> "%LogFile%"
)
echo [%date% %time%] RAM optimized: Virtual Memory set to %RAMInitial%-%RAMMax% MB >> "%LogFile%"

:: GPU Optimization (Indirect)
echo Optimizing GPU (Indirect)...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v NoHardwareAcceleration /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v Composition /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 0 /f >nul 2>&1
echo [%date% %time%] GPU load reduced: Visual effects disabled >> "%LogFile%"

:: Storage Optimization
echo Optimizing Storage...
for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        echo Optimizing drive %%d:...
        defrag %%d: /O /V >> "%LogFile%" 2>&1
        if errorlevel 1 echo [WARNING] Failed to optimize drive %%d >> "%LogFile%"
    )
)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisableLastAccessUpdate /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisable8dot3NameCreation /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Disk" /v TimeOutValue /t REG_DWORD /d 10 /f >nul 2>&1
echo [%date% %time%] Storage optimized: All drives processed >> "%LogFile%"

:: Internet Optimization
echo Optimizing Internet...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| find "Default Gateway" ^| find /v "0.0.0.0"') do (
    set "NetInterface=%%a"
    set "NetInterface=!NetInterface:~1!"
    goto :SetNet
)
:SetNet
if not defined NetInterface (
    echo [WARNING] Could not detect network interface. Defaulting to Ethernet.
    set "NetInterface=Ethernet"
    echo [%date% %time%] Network interface detection failed, defaulted to Ethernet >> "%LogFile%"
)
netsh interface ipv4 set subinterface "!NetInterface!" mtu=1500 store=persistent >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=enabled >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global congestionprovider=ctcp >nul 2>&1
netsh int tcp set global maxsynretransmissions=2 >nul 2>&1
netsh int tcp set global initialRto=1500 >nul 2>&1
netsh int tcp set global nonsackrttresiliency=enabled >nul 2>&1
netsh int tcp set global rsc=enabled >nul 2>&1
if errorlevel 1 echo [WARNING] Some network tweaks failed. Check network adapter status. >> "%LogFile%"
echo [%date% %time%] Internet optimized: Interface !NetInterface! tweaked >> "%LogFile%"

:: Service Optimization
echo Optimizing Services...
for %%s in (DiagTrack dmwappushservice SysMain WSearch WMPNetworkSvc XboxGipSvc XblAuthManager XblGameSave MapsBroker DoSvc WdiSystemHost) do (
    sc config %%s start= disabled >nul 2>&1
    if errorlevel 1 echo [WARNING] Failed to disable service %%s >> "%LogFile%"
)
echo [%date% %time%] Services optimized >> "%LogFile%"

:: System-Wide Tweaks
echo Applying System-Wide Tweaks...
powercfg -h off >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 500 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 500 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 1000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
del /q /f /s "%temp%\*.*" 2>nul
del /q /f /s "C:\Windows\Temp\*.*" 2>nul
del /q /f /s "C:\Windows\Prefetch\*.*" 2>nul
bcdedit /timeout 0 >nul 2>&1
echo [%date% %time%] System-wide tweaks applied >> "%LogFile%"

echo Optimization complete. Please restart your PC to apply changes.
echo [%date% %time%] Performance optimization completed >> "%LogFile%"
pause
goto MainMenu

:: -------------------
:: Windows Features Customization
:: -------------------
:WindowsFeatures
cls
echo Windows Features Customization
echo ---------------------------------------------
echo 1. Enable Windows Defender (Permanent)
echo 2. Disable Windows Defender (Permanent)
echo 3. Enable Windows Update (Permanent)
echo 4. Disable Windows Update (Permanent)
echo 5. Check for Updates Now
echo 6. Enable Hibernate
echo 7. Disable Hibernate
echo 8. Clear Temporary Files
echo 9. Back to Main Menu
echo ---------------------------------------------
set "choice="
set /p choice=Select an option (1-9): 
if not defined choice (
    echo [ERROR] No input provided. Please enter a number.
    pause
    goto WindowsFeatures
)

if "%choice%"=="1" (
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /f >nul 2>&1
    sc config WinDefend start= auto >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Failed to enable Windows Defender.
        echo [%date% %time%] Failed to enable Windows Defender >> "%LogFile%"
    ) else (
        echo Windows Defender enabled permanently.
        echo [%date% %time%] Windows Defender enabled permanently >> "%LogFile%"
    )
    pause
    goto WindowsFeatures
)
if "%choice%"=="2" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1
    sc config WinDefend start= disabled >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Failed to disable Windows Defender.
        echo [%date% %time%] Failed to disable Windows Defender >> "%LogFile%"
    ) else (
        echo Windows Defender disabled permanently.
        echo [%date% %time%] Windows Defender disabled permanently >> "%LogFile%"
    )
    pause
    goto WindowsFeatures
)
if "%choice%"=="3" (
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /f >nul 2>&1
    sc config wuauserv start= auto >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Failed to enable Windows Update.
        echo [%date% %time%] Failed to enable Windows Update >> "%LogFile%"
    ) else (
        echo Windows Update enabled permanently.
        echo [%date% %time%] Windows Update enabled permanently >> "%LogFile%"
    )
    pause
    goto WindowsFeatures
)
if "%choice%"=="4" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul 2>&1
    sc config wuauserv start= disabled >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Failed to disable Windows Update.
        echo [%date% %time%] Failed to disable Windows Update >> "%LogFile%"
    ) else (
        echo Windows Update disabled permanently.
        echo [%date% %time%] Windows Update disabled permanently >> "%LogFile%"
    )
    pause
    goto WindowsFeatures
)
if "%choice%"=="5" (
    wuauclt /detectnow >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Failed to check for updates.
        echo [%date% %time%] Update check failed >> "%LogFile%"
    ) else (
        echo Checking for updates...
        echo [%date% %time%] Checking for Windows Updates >> "%LogFile%"
    )
    pause
    goto WindowsFeatures
)
if "%choice%"=="6" (
    powercfg -h on >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Failed to enable Hibernate.
        echo [%date% %time%] Hibernate enable failed >> "%LogFile%"
    ) else (
        echo Hibernate enabled.
        echo [%date% %time%] Hibernate enabled >> "%LogFile%"
    )
    pause
    goto WindowsFeatures
)
if "%choice%"=="7" (
    powercfg -h off >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Failed to disable Hibernate.
        echo [%date% %time%] Hibernate disable failed >> "%LogFile%"
    ) else (
        echo Hibernate disabled.
        echo [%date% %time%] Hibernate disabled >> "%LogFile%"
    )
    pause
    goto WindowsFeatures
)
if "%choice%"=="8" (
    del /q /f /s "%temp%\*.*" 2>nul
    del /q /f /s "C:\Windows\Temp\*.*" 2>nul
    del /q /f /s "C:\Windows\Prefetch\*.*" 2>nul
    if errorlevel 1 (
        echo [WARNING] Some temporary files could not be cleared.
        echo [%date% %time%] Temporary file clearing partially failed >> "%LogFile%"
    ) else (
        echo Temporary files cleared.
        echo [%date% %time%] Temporary files cleared >> "%LogFile%"
    )
    pause
    goto WindowsFeatures
)
if "%choice%"=="9" goto MainMenu
echo [ERROR] Invalid option. Please select 1-9.
pause
goto WindowsFeatures

:: -------------------
:: Exit Script
:: -------------------
:ExitScript
echo Exiting tool...
echo [%date% %time%] Tool exited >> "%LogFile%"
pause
exit /b 0
