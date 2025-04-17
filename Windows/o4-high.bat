@echo off
:: =============================================================
::   Win11‑AIO‑Tools.bat  –  All‑In‑One Windows 11 Maintenance
::   © 2025, Run as Administrator
:: =============================================================

title Win11 AIO Maintenance & Tweaks
color 0A
setlocal EnableDelayedExpansion

:: --- FUNCTION BLOCKS ----------------------------------------
:func_WindowsUpdate
    echo [Updating Windows...]
    net stop wuauserv /y
    UsoClient StartScan
    wuauclt.exe /updatenow
    net start wuauserv
    echo Done. & pause >nul
    goto :menu

:func_DisableWU
    echo [Disabling Windows Update Service...]
    sc config wuauserv start=disabled
    sc stop wuauserv
    sc config UsoSvc   start=disabled
    sc stop UsoSvc
    :: บล็อก Auto‑Update ทางนโยบาย
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions     /t REG_DWORD /d 1 /f
    echo Done. & pause >nul
    goto :menu

:func_EnableWU
    echo [Enabling Windows Update Service...]
    sc config wuauserv start=auto
    sc start  wuauserv
    sc config UsoSvc   start=auto
    sc start  UsoSvc
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 0 /f
    echo Done. & pause >nul
    goto :menu

:func_Defender
    echo [Updating Defender & Full Scan...]
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
    echo Done. & pause >nul
    goto :menu

:func_DisableDefender
    echo [Disabling Defender Real‑Time Protection...]
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
    powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
    echo Done. & pause >nul
    goto :menu

:func_EnableDefender
    echo [Enabling Defender Real‑Time Protection...]
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /f
    powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
    echo Done. & pause >nul
    goto :menu

:func_AppDriverUpdate
    echo [Updating apps (winget + choco)...]
    winget upgrade --all --silent
    choco upgrade all -y
    echo [Updating drivers from C:\Drivers...]
    for /f %%i in ('dir /b /s "C:\Drivers\*.inf"') do (
        pnputil /add-driver "%%i" /install
    )
    pnputil /scan-devices
    echo Done. & pause >nul
    goto :menu

:func_ImageRepair
    echo [DISM + SFC + chkdsk...]
    DISM /Online /Cleanup-Image /RestoreHealth
    sfc  /scannow
    chkdsk C: /F /R
    echo Done (chkdsk on reboot). & pause >nul
    goto :menu

:func_Cleanup
    echo [Disk Cleanup + Temp/Prefetch...]
    cleanmgr /sageset:1 >nul
    cleanmgr /sagerun:1
    rmdir /s /q C:\Windows\Prefetch      && mkdir C:\Windows\Prefetch
    rmdir /s /q "%SystemRoot%\Temp"      && mkdir "%SystemRoot%\Temp"
    rmdir /s /q "%USERPROFILE%\AppData\Local\Temp" && mkdir "%USERPROFILE%\AppData\Local\Temp"
    echo Done. & pause >nul
    goto :menu

:func_EventLogs
    echo [Clearing Event Logs...]
    for /f %%G in ('wevtutil el') do (
        wevtutil cl "%%G"
    )
    echo Done. & pause >nul
    goto :menu

:func_OptimizeDisk
    echo [Defrag / TRIM Optimization...]
    defrag C: /O /X
    echo Done. & pause >nul
    goto :menu

:func_RebuildCaches
    echo [Rebuilding Search & Font Caches...]
    net stop wsearch
    del "%ProgramData%\Microsoft\Search\Data\Applications\Windows\windows.edb" /f /q
    net start wsearch
    net stop FontCache
    del /f /q "%WinDir%\ServiceProfiles\LocalService\AppData\Local\FontCache*"
    net start FontCache
    echo Done. & pause >nul
    goto :menu

:func_PowerPlan
    echo [High‑Performance Power Plan...]
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    echo Done. & pause >nul
    goto :menu

:func_NetworkTweaks
    echo [Network Tweaks (TCP & DNS)...]
    netsh int tcp set global autotuninglevel=disabled
    ipconfig /flushdns
    echo Done. & pause >nul
    goto :menu

:func_Debloat
    echo [Debloating Windows 11...]
    powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://git.io/debloat11 | iex"
    echo Done. & pause >nul
    goto :menu

:func_TaskCleanup
    echo [Scheduled Tasks Cleanup...]
    echo   1. Delete ALL tasks
    echo   2. Delete specific task
    set /p tchoice="Select option: "
    if "%tchoice%"=="1" (
        schtasks /delete /tn * /f
    ) else (
        set /p tname="Task Name: "
        schtasks /delete /tn "%tname%" /f
    )
    echo Done. & pause >nul
    goto :menu

:func_Tweaks
    echo [Applying Visual & System Tweaks...]
    :: Visual Effects (best perf)
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"              /v VisualFXSetting        /t REG_DWORD /d 2 /f
    reg add "HKCU\Control Panel\Desktop\WindowMetrics"                                            /v MinAnimate             /t REG_SZ   /d 0 /f
    reg add "HKCU\Control Panel\Desktop"                                                          /v MenuShowDelay          /t REG_SZ   /d 100 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"                   /v EnableTransparency     /t REG_DWORD /d 0 /f
    :: Power & Memory
    powercfg /hibernate off  :: disable hibernate 0
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"             /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True
    :: Game Mode & GPU Scheduling
    reg add "HKLM\SYSTEM\GameConfigStore"                                                         /v GameDVR_Enabled        /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"                              /v HwSchMode              /t REG_DWORD /d 2 /f 
    :: Disable unwanted services
    sc config DiagTrack         start=disabled & sc stop DiagTrack
    sc config dmwappushservice  start=disabled & sc stop dmwappushservice
    sc config SysMain           start=disabled & sc stop SysMain
    echo Done. & pause >nul
    goto :menu

:func_RunAll
    call :func_DisableWU
    call :func_EnableWU
    call :func_WindowsUpdate
    call :func_DisableDefender
    call :func_EnableDefender
    call :func_Defender
    call :func_AppDriverUpdate
    call :func_ImageRepair
    call :func_Cleanup
    call :func_EventLogs
    call :func_OptimizeDisk
    call :func_RebuildCaches
    call :func_PowerPlan
    call :func_NetworkTweaks
    call :func_Debloat
    call :func_TaskCleanup
    call :func_Tweaks
    echo ===== All functions executed. Please reboot. =====
    pause >nul
    goto :eof

:: --- MAIN MENU --------------------------------------------
:menu
    cls
    echo ==============================================
    echo      Windows 11 AIO Maintenance & Tweaks
    echo ==============================================
    echo  1.  Run Windows Update
    echo  2.  Disable Windows Update
    echo  3.  Enable Windows Update
    echo  4.  Update Defender & Scan
    echo  5.  Disable Defender Real‑Time Protection
    echo  6.  Enable Defender Real‑Time Protection
    echo  7.  Update Apps & Drivers
    echo  8.  DISM/SFC/chkdsk Repair
    echo  9.  Disk Cleanup + Temp/Prefetch
    echo 10.  Clear Event Logs
    echo 11.  Defrag / TRIM Optimize
    echo 12.  Rebuild Search & Font Cache
    echo 13.  High‑Performance Power Plan
    echo 14.  Network Tweaks (TCP & DNS)
    echo 15.  Debloat Windows 11
    echo 16.  Scheduled Tasks Cleanup
    echo 17.  Visual & System Tweaks
    echo 18.  Run ALL Functions
    echo  0.  Exit
    set /p choice="Select [0-18]: "
    if "%choice%"=="1"  goto :func_WindowsUpdate
    if "%choice%"=="2"  goto :func_DisableWU
    if "%choice%"=="3"  goto :func_EnableWU
    if "%choice%"=="4"  goto :func_Defender
    if "%choice%"=="5"  goto :func_DisableDefender
    if "%choice%"=="6"  goto :func_EnableDefender
    if "%choice%"=="7"  goto :func_AppDriverUpdate
    if "%choice%"=="8"  goto :func_ImageRepair
    if "%choice%"=="9"  goto :func_Cleanup
    if "%choice%"=="10" goto :func_EventLogs
    if "%choice%"=="11" goto :func_OptimizeDisk
    if "%choice%"=="12" goto :func_RebuildCaches
    if "%choice%"=="13" goto :func_PowerPlan
    if "%choice%"=="14" goto :func_NetworkTweaks
    if "%choice%"=="15" goto :func_Debloat
    if "%choice%"=="16" goto :func_TaskCleanup
    if "%choice%"=="17" goto :func_Tweaks
    if "%choice%"=="18" goto :func_RunAll
    if "%choice%"=="0"  exit
    goto :menu
