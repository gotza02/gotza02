@echo off
setlocal enabledelayedexpansion

:: -------------------------------------------------------------------------
::                      Windows Optimization Script v3.5
::                      Efficiency & Speed - Enhanced Edition - Optimized
:: -------------------------------------------------------------------------

:: ** WARNING ** : This script is optimized for Windows 11.
:: Windows 10 or older may have compatibility issues.

ver | findstr /i "Version 10.0." >nul 2>&1
if %errorlevel% equ 0 (
    echo.
    echo [!] ======================================================================= [!]
    echo [!] **WARNING:** This script is optimized for Windows 11. Windows 10    [!]
    echo [!] or older may have compatibility issues.                                  [!]
    echo [!] ======================================================================= [!]
    echo.
    pause
)

:: Check Administrator Rights (Function)
call :checkAdmin

:: Function to Retrieve System Status (Improved Efficiency)
call :getSystemStatus

:mainMenu
cls
echo.
echo  ╔══════════════════════════════════════════════════════════════════╗
echo  ║                      ** System Status Dashboard **                      ║
echo  ╠══════════════════════════════════════════════════════════════════╣
echo  ║ Windows Defender     : !defender_status!                                 ║
echo  ║ Windows Update       : !update_status!                                   ║
echo  ║ Power Plan           : !powerplan_name!                                  ║
echo  ║ Dark Mode            : !darkmode_status!                                   ║
echo  ║ GPU Scheduling       : !gpu_scheduling_status!                             ║
echo  ╚══════════════════════════════════════════════════════════════════╝
echo.
echo  ╔══════════════════════════════════════════════════════════════════╗
echo  ║             Windows Optimization Script v3.5 - Enhanced Edition             ║
echo  ╠══════════════════════════════════════════════════════════════════╣
echo  ║ Please select an option:                                                  ║
echo  ║                                                                          ║
echo  ║  [1] Optimize Display Performance      [11] Activate Windows (KMS - **RISKY!**)  [21] Optimize Network       ║
echo  ║  [2] Manage Windows Defender            [12] Manage Power Settings                 [22] Exit Program           ║
echo  ║  [3] Optimize System Features           [13] Enable Dark Mode                      [23] Disable Transparency Effects ║
echo  ║  [4] Optimize CPU Performance          [14] Manage Partitions (**Data Loss Risk!**)  [24] Disable Extra Animations   ║
echo  ║  [5] Optimize Internet Performance     [15] Clean Up Disk Junk Files              [25] Optimize Storage Sense     ║
echo  ║  [6] Manage Windows Update              [16] Manage Startup Programs              [26] Disable Startup Sound      ║
echo  ║  [7] Set Auto-login (**Security Risk!**) [17] Backup & Restore Settings          [27] Optimize Paging File (**Advanced!**)║
echo  ║  [8] Clear System Cache                 [18] System Information                  [28] Disable Widget Features (Win11)║
echo  ║  [9] Optimize Disk                      [19] Optimize Privacy Settings             [29] Optimize Game Mode Settings  ║
echo  ║  [10] Check and Repair System Files     [20] Manage Windows Services               [30] Return to Main Menu        ║
echo  ║                                                                          ║
echo  ║ **WARNINGS**:                                                               ║
echo  ║  - Option [11] KMS Activation:  **High security and legal risk!**           ║
echo  ║  - Option [14] Manage Partitions: **High risk of permanent data loss! Backup data first!** ║
echo  ║  - Options [7, 27, 4, 20, 21] are advanced options, use with caution.        ║
echo  ╚══════════════════════════════════════════════════════════════════╝
echo.

set /p choice=  Please select an option (1-30):

:: Check User Input (Improved)
if not defined choice (
    echo.
    echo [!] **Error:** Please enter an option.
    echo.
    pause
    goto mainMenu
)

if "%choice%"=="?" (
    call :showHelpMenu
    goto mainMenu
)

if %choice% GEQ 1 AND %choice% LEQ 30 (
    goto option_%choice%
) else (
    echo.
    echo [!] **Error:** Invalid option. Please try again.
    echo.
    pause
    goto mainMenu
)

:option_1  & call :optimizeDisplay & goto mainMenu
:option_2  & call :manageDefender & goto mainMenu
:option_3  & call :optimizeFeatures & goto mainMenu
:option_4  & call :optimizeCPU & goto mainMenu
:option_5  & call :optimizeInternet & goto mainMenu
:option_6  & call :windowsUpdate & goto mainMenu
:option_7  & call :autoLogin & goto mainMenu
:option_8  & call :clearCache & goto mainMenu
:option_9  & call :optimizeDisk & goto mainMenu
:option_10 & call :checkRepair & goto mainMenu
:option_11 & call :windowsActivate & goto mainMenu
:option_12 & call :managePower & goto mainMenu
:option_13 & call :enableDarkMode & goto mainMenu
:option_14 & call :managePartitions & goto mainMenu
:option_15 & goto cleanup_system & goto mainMenu
:option_16 & call :manageStartup & goto mainMenu
:option_17 & call :backupRestore & goto mainMenu
:option_18 & call :systemInfo & goto mainMenu
:option_19 & call :optimizePrivacy & goto mainMenu
:option_20 & call :manageServices & goto mainMenu
:option_21 & call :networkOptimization & goto mainMenu
:option_22 & goto endexit
:option_23 & call :disableTransparency & goto mainMenu
:option_24 & call :disableAnimationsExtra & goto mainMenu
:option_25 & call :optimizeStorageSenseMenu & goto mainMenu
:option_26 & call :disableStartupSound & goto mainMenu
:option_27 & call :optimizePagingFileMenu & goto mainMenu
:option_28 & call :disableWidgets & goto mainMenu
:option_29 & call :optimizeGameModeMenu & goto mainMenu
:option_30 & goto mainMenu

:: ========================= Functions =========================

:checkAdmin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [!] **Error:** Administrator rights are required. Please Run as administrator.
    echo.
    pause
    exit /b 1
)
exit /b 0

:getSystemStatus
:: Retrieve all status information at once for efficiency
(
    :: Windows Defender Status
    call :getDefenderStatusInternal
    set "defender_status=!defender_internal_status!"

    :: Windows Update Status
    call :getUpdateStatusInternal
    set "update_status=!update_internal_status!"

    :: Power Plan Status
    call :getPowerPlanStatusInternal
    set "powerplan_name=!powerplan_internal_name!"

    :: Dark Mode Status
    call :getDarkModeStatusInternal
    set "darkmode_status=!darkmode_internal_status!"

    :: GPU Scheduling Status
    call :getGPUSchedulingStatusInternal
    set "gpu_scheduling_status=!gpu_scheduling_internal_status!"
)
exit /b 0

:getDefenderStatusInternal
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" 2^>nul ^| find "REG_DWORD"') do set "defender_dword=%%a"
    if "!defender_dword!"=="0x1" ( set "defender_internal_status=Disabled (Policy)" ) else ( set "defender_internal_status=Enabled (Policy)" )
) else if exist "%ProgramFiles%\Windows Defender\MpCmdRun.exe" (
    sc query windefend >nul 2>&1
    if %errorlevel% equ 0 ( set "defender_internal_status=Enabled (Service Running)" ) else ( set "defender_internal_status=Disabled (Service Stopped)" )
) else ( set "defender_internal_status=Not Available" )
exit /b 0

:getUpdateStatusInternal
sc query wuauserv >nul 2>&1
if %errorlevel% equ 0 (
    sc query wuauserv | findstr /i "STATE" | findstr /i "DISABLED" >nul 2>&1
    if %errorlevel% equ 0 ( set "update_internal_status=Disabled" ) else ( set "update_internal_status=Enabled" )
) else ( set "update_internal_status=Unknown" )
exit /b 0

:getPowerPlanStatusInternal
for /f "tokens=3*" %%a in ('powercfg /getactivescheme') do set "active_guid=%%a"
for /f "tokens=2*" %%a in ('powercfg /query %active_guid% /name ^| findstr Scheme name') do set "powerplan_internal_name=%%b"
if not defined powerplan_internal_name set "powerplan_internal_name=Unknown"
exit /b 0

:getDarkModeStatusInternal
reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" | find "REG_DWORD" | find "0x0" >nul 2>&1
if %errorlevel% equ 0 (
    reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" | find "REG_DWORD" | find "0x0" >nul 2>&1
    if %errorlevel% equ 0 ( set "darkmode_internal_status=Enabled" ) else ( set "darkmode_internal_status=Disabled" )
) else ( set "darkmode_internal_status=Disabled" )
exit /b 0

:getGPUSchedulingStatusInternal
ver | findstr /i "Version 10.0.19041" >nul 2>&1
if %errorlevel% equ 0 (
    reg query "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" | find "REG_DWORD" | find "0x2" >nul 2>&1
    if %errorlevel% equ 0 ( set "gpu_scheduling_internal_status=Enabled (Supported)" ) else ( set "gpu_scheduling_internal_status=Disabled (Supported)" )
) else ( set "gpu_scheduling_internal_status=Not Supported" )
exit /b 0

:optimizeDisplay
echo.
echo [>] Optimizing display...
call :modifyRegistry "HKCU\Control Panel\Desktop" "UserPreferencesMask" "REG_BINARY" "9012078010000000"
call :modifyRegistry "HKCU\Control Panel\Desktop" "MenuShowDelay" "REG_SZ" "0"
call :modifyRegistry "HKCU\Control Panel\Desktop\WindowMetrics" "MinAnimate" "REG_SZ" "0"
call :modifyRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewAlphaSelect" "REG_DWORD" "0"
call :modifyRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewShadow" "REG_DWORD" "0"
call :modifyRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" "REG_DWORD" "0"
call :modifyRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" "EnableAeroPeek" "REG_DWORD" "0"
echo [>] Display optimized.
echo.
pause
goto mainMenu

:manageDefender
:manageDefenderMenu
cls
echo.
echo  ╔════════════════════════ Windows Defender Management ══════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] Check Status           [4] Update Defender         [7] Manage Real-time Protection  [10] View Threat History ║
echo  ║  [2] Enable               [5] Quick Scan              [8] Manage Cloud Protection      [11] Return to Main Menu        ║
echo  ║  [3] Disable (**Not Recommended**) [6] Full Scan             [9] Manage Sample Submission                               ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p def_choice=  Please select an option (1-11):
echo.

if "%def_choice%"=="1" ( call :checkDefenderStatus ) else
if "%def_choice%"=="2" ( call :enableDefender ) else
if "%def_choice%"=="3" ( call :disableDefender ) else
if "%def_choice%"=="4" ( call :updateDefender ) else
if "%def_choice%"=="5" ( call :quickScanDefender ) else
if "%def_choice%"=="6" ( call :fullScanDefender ) else
if "%def_choice%"=="7" ( call :manageRealtimeProtection ) else
if "%def_choice%"=="8" ( call :manageCloudProtection ) else
if "%def_choice%"=="9" ( call :manageSampleSubmission ) else
if "%def_choice%"=="10" ( call :viewThreatHistory ) else
if "%def_choice%"=="11" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto manageDefenderMenu
)
goto manageDefenderMenu

:checkDefenderStatus
echo [>] Checking Defender status...
sc query windefend
echo.
pause
goto mainMenu

:enableDefender
echo [>] Enabling Defender...
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "0"
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "Disable*" "REG_DWORD" "0"
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "1"
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "1"
echo [>] Defender enabled.
echo.
pause
goto mainMenu

:disableDefender
echo.
echo [!] **Warning:** Disabling Defender will reduce system security.
set /p confirm_disable=  Do you want to continue? (Y/N):
if /i "%confirm_disable%"=="Y" (
    echo [>] Disabling Defender...
    call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "1"
    call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "Disable*" "REG_DWORD" "1"
    call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
    call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "2"
    echo [>] Defender disabled. **Security risk!**
    echo.
    pause
) else (
    echo [>] Disabling Defender cancelled.
    echo.
    pause
)
goto mainMenu

:updateDefender
echo [>] Updating Defender...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
if %errorlevel% equ 0 (
    echo [>] Defender updated.
) else (
    echo [!] **Error:** Update failed. Please check internet connection.
)
echo.
pause
goto mainMenu

:quickScanDefender
echo [>] Performing quick scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
echo [>] Quick scan completed.
echo.
pause
goto mainMenu

:fullScanDefender
echo [>] Performing full scan (may take a long time)...
start "" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
echo [>] Full scan started in the background. Please check Windows Security for progress.
echo.
pause
goto mainMenu

:manageRealtimeProtection & call :toggleDefenderFeature "Real-Time Protection" "DisableRealtimeMonitoring" & goto manageDefenderMenu
:manageCloudProtection    & call :toggleDefenderFeature "Cloud-delivered Protection" "SpynetReporting" & goto manageDefenderMenu
:manageSampleSubmission & call :toggleDefenderFeature "Automatic Sample Submission" "SubmitSamplesConsent" & goto manageDefenderMenu
:viewThreatHistory
echo [>] Viewing threat history...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -GetFiles
echo [>] Threat history displayed.
echo.
pause
goto mainMenu

:toggleDefenderFeature
echo.
echo [>] Current status of %~1:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v %~2 2>nul || reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v %~2
set /p choice=  Do you want to Enable (E) or Disable (D) %~1? (E/D):
if /i "%choice%"=="E" (
    reg delete "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v %~2 /f 2>nul || reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v %~2 /t REG_DWORD /d "2" /f
    echo [>] %~1 Enabled.
) else if /i "%choice%"=="D" (
    call :modifyRegistry "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" %~2 "REG_DWORD" "1" || call :modifyRegistry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" %~2 "REG_DWORD" "0"
    echo [>] %~1 Disabled.
) else (
    echo [!] **Error:** Invalid option.
)
echo.
pause
goto manageDefenderMenu

:optimizeFeatures
echo.
echo [>] Optimizing system features...
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" "0" & echo [>] - Activity Feed disabled.
call :modifyRegistry "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" "REG_DWORD" "1" & echo [>] - Background apps disabled.
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "0" & echo [>] - Cortana disabled.
call :disableGameDVRBar  & echo [>] - Game DVR and Game Bar disabled.
call :modifyRegistry "HKCU\Control Panel\Accessibility\StickyKeys" "Flags" "REG_SZ" "506" & echo [>] - Sticky Keys prompt disabled.
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" "1" & echo [>] - Windows Tips disabled.
call :modifyRegistry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "0" & echo [>] - Start Menu suggestions disabled.
call :modifyRegistry "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HiberbootEnabled" "REG_DWORD" "1" & echo [>] - Fast Startup enabled.
echo [>] System features optimized.
echo.
pause
goto mainMenu

:disableGameDVRBar
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" "REG_DWORD" "0"
call :modifyRegistry "HKCU\System\GameConfigStore" "GameDVR_Enabled" "REG_DWORD" "0"
exit /b 0

:optimizeCPU
:optimizeCPUMenu
cls
echo.
echo  ╔══════════════════════════ CPU Optimization ══════════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] High Performance Plan       [4] Disable Core Parking    [7] Disable Services (**Advanced**) ║
echo  ║  [2] Disable Throttling          [5] Adjust Power Mgmt       [8] Adjust Visual Effects         ║
echo  ║  [3] Optimize Scheduling         [6] Enable GPU Scheduling   [9] Return to Main Menu                ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p cpu_choice=  Please select an option (1-9):
echo.

if "%cpu_choice%"=="1" ( call :setHighPerformancePlan ) else
if "%cpu_choice%"=="2" ( call :disableCPUThrottling ) else
if "%cpu_choice%"=="3" ( call :optimizeScheduling ) else
if "%cpu_choice%"=="4" ( call :disableCoreParking ) else
if "%cpu_choice%"=="5" ( call :adjustPowerManagement ) else
if "%cpu_choice%"=="6" ( call :enableGPUScheduling ) else
if "%cpu_choice%"=="7" ( call :disableServicesMenu ) else
if "%cpu_choice%"=="8" ( call :adjustVisualEffects ) else
if "%cpu_choice%"=="9" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto optimizeCPUMenu
)
goto optimizeCPUMenu

:setHighPerformancePlan
echo [>] Setting High Performance plan...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
if %errorlevel% neq 0 (
    echo [!] **Error:** Failed to set. Creating new plan...
    powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    for /f "tokens=4" %%i in ('powercfg -list ^| findstr /i "High performance"') do set hp_guid=%%i
    if defined hp_guid powercfg -setactive %hp_guid%
)
echo [>] High Performance plan set.
echo.
pause
goto mainMenu

:disableCPUThrottling
echo [>] Disabling CPU throttling...
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100
powercfg -setactive scheme_current
echo [>] CPU throttling disabled.
echo.
pause
goto mainMenu

:optimizeScheduling
echo [>] Optimizing processor scheduling...
call :modifyRegistry "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "REG_DWORD" "38"
echo [>] Processor scheduling optimized.
echo.
pause
goto mainMenu

:disableCoreParking
echo [>] Disabling CPU core parking...
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
powercfg -setactive scheme_current
echo [>] CPU core parking disabled.
echo.
pause
goto mainMenu

:adjustPowerManagement
echo [>] Adjusting power management...
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100
powercfg -setacvalueindex scheme_current sub_processor PERFINCPOL 2
powercfg -setacvalueindex scheme_current sub_processor PERFDECPOL 1
powercfg -setactive scheme_current
echo [>] Power management adjusted.
echo.
pause
goto mainMenu

:enableGPUScheduling
echo [>] Enabling GPU scheduling...
ver | findstr /i "Version 10.0.19041" >nul 2>&1
if %errorlevel% equ 0 (
    call :modifyRegistry "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" "2"
    echo [>] GPU scheduling enabled. Restart required.
    echo.
    pause
) else (
    echo [!] **Error:** GPU scheduling not supported on this Windows version.
    echo.
    pause
)
goto mainMenu

:disableServicesMenu
:disableServicesSubMenu
cls
echo.
echo  ╔══════════ Disable System Services (Advanced) ══════════╗
echo  ║                                                          ║
echo  ║ **Warning:** Disabling services may cause system instability. ║
echo  ║ Please proceed with caution!                             ║
echo  ║                                                          ║
echo  ║  [1] Disable SysMain (Superfetch)    [3] Disable WSearch (Windows Search)  [5] Return to CPU Menu ║
echo  ║  [2] Disable DiagTrack (Diagnostics) [4] Disable ALL above (Aggressive)      ║
echo  ║                                                          ║
echo  ╚══════════════════════════════════════════════╝
echo.
set /p svc_choice=  Please select an option (1-5):
echo.

if "%svc_choice%"=="1" ( call :disableService "SysMain" "Superfetch" ) else
if "%svc_choice%"=="2" ( call :disableService "DiagTrack" "Diagnostic Tracking" ) else
if "%svc_choice%"=="3" ( call :disableService "WSearch" "Windows Search" ) else
if "%svc_choice%"=="4" ( call :disableMultipleServices ) else
if "%svc_choice%"=="5" ( goto optimizeCPUMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto disableServicesSubMenu
)
goto disableServicesSubMenu

:disableService
echo [>] Disabling %~2 (%~1)...
sc config "%~1" start= disabled
sc stop "%~1" 2>nul
echo [>] %~2 disabled.
echo.
pause
goto disableServicesMenu

:disableMultipleServices
echo [>] Disabling SysMain, DiagTrack, WSearch...
call :disableService "SysMain" "Superfetch"
call :disableService "DiagTrack" "Diagnostic Tracking"
call :disableService "WSearch" "Windows Search"
echo [>] Multiple services disabled. **Please check system after restart!**
echo.
pause
goto disableServicesMenu

:adjustVisualEffects
echo [>] Adjusting visual effects for performance...
call :modifyRegistry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "REG_DWORD" "2"
echo [>] Visual effects adjusted for performance.
echo.
pause
goto mainMenu

:optimizeInternet
:optimizeInternetMenu
cls
echo.
echo  ╔══════════════════════════ Internet Optimization ══════════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] Basic Optimizations          [4] Network Adapter Tuning (**Advanced**)      ║
echo  ║  [2] Advanced TCP Optimizations     [5] Clear Network Cache                     ║
echo  ║  [3] DNS Optimization             [6] Return to Main Menu                            ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p net_choice=  Please select an option (1-6):
echo.

if "%net_choice%"=="1" ( call :basicInternetOptimizations ) else
if "%net_choice%"=="2" ( call :advancedTCPOptimizations ) else
if "%net_choice%"=="3" ( call :dnsOptimization ) else
if "%net_choice%"=="4" ( call :adapterTuning ) else
if "%net_choice%"=="5" ( call :clearNetworkCache ) else
if "%net_choice%"=="6" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto optimizeInternetMenu
)
goto optimizeInternetMenu

:basicInternetOptimizations
echo [>] Performing basic optimizations...
netsh int tcp set global autotuninglevel=normal & netsh int tcp set global chimney=enabled & netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled & netsh int tcp set global ecncapability=enabled & netsh int tcp set global timestamps=disabled & netsh int tcp set global rss=enabled
echo [>] Basic optimizations completed.
echo.
pause
goto mainMenu

:advancedTCPOptimizations
echo [>] Performing advanced TCP optimizations (**Advanced User**)...
netsh int tcp set global congestionprovider=ctcp & netsh int tcp set global ecncapability=enabled & netsh int tcp set heuristics disabled
netsh int tcp set global rss=enabled & netsh int tcp set global fastopen=enabled & netsh int tcp set global hystart=disabled & netsh int tcp set global pacingprofile=off
call :modifyRegistry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPNoDelay" "REG_DWORD" "1"
call :modifyRegistry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPDelAckTicks" "REG_DWORD" "0"
echo [>] Advanced TCP optimizations completed.
echo.
pause
goto mainMenu

:dnsOptimization
echo [>] Optimizing DNS settings...
ipconfig /flushdns
for /f "tokens=3*" %%a in ('netsh int show interface ^| findstr /i "Connected"') do set "interface_name=%%b"
if defined interface_name (
    netsh int ip set dns name="%interface_name%" source=static address=8.8.8.8 register=primary
    netsh int ip add dns name="%interface_name%" address=8.8.4.4 index=2
    echo [>] DNS optimized (8.8.8.8, 8.8.4.4).
) else (
    echo [!] **Error:** No active interface found. DNS optimization failed.
)
echo.
pause
goto mainMenu

:adapterTuning
echo [>] Tuning network adapter (**Advanced - May require further tuning**)...
for /f "tokens=3*" %%a in ('netsh int show interface ^| findstr /i "Connected"') do set "interface_name=%%b"
if defined interface_name (
    netsh int ip set interface name="%interface_name%" dadtransmits=0 store=persistent
    netsh int ip set interface name="%interface_name%" routerdiscovery=disabled store=persistent
    powershell -Command "Get-NetAdapter -Name '%interface_name%' | Set-NetAdapterAdvancedProperty -RegistryKeyword '*FlowControl' -RegistryValue 0; Set-NetAdapterAdvancedProperty -RegistryKeyword '*InterruptModeration' -RegistryValue 0; Set-NetAdapterAdvancedProperty -RegistryKeyword '*PriorityVLANTag' -RegistryValue 3; Set-NetAdapterAdvancedProperty -RegistryKeyword '*SpeedDuplex' -RegistryValue 0"
    echo [>] Adapter tuned. **May require further tuning in Device Manager.**
) else (
    echo [!] **Error:** No active interface found. Adapter tuning failed.
)
echo.
pause
goto mainMenu

:clearNetworkCache
echo [>] Clearing network cache...
ipconfig /flushdns & arp -d * & nbtstat -R & nbtstat -RR & netsh int ip reset & netsh winsock reset
echo [>] Network cache cleared.
echo.
pause
goto mainMenu

:windowsUpdate
:windowsUpdateMenu
cls
echo.
echo  ╔══════════════════════ Windows Update Management ══════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] Enable Updates                  [3] Check for Updates                    ║
echo  ║  [2] Disable Updates (**Not Recommended**) [4] Return to Main Menu                ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p update_choice=  Please select an option (1-4):
echo.

if "%update_choice%"=="1" ( call :enableWindowsUpdate ) else
if "%update_choice%"=="2" ( call :disableWindowsUpdate ) else
if "%update_choice%"=="3" ( call :checkWindowsUpdates ) else
if "%update_choice%"=="4" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto windowsUpdateMenu
)
goto windowsUpdateMenu

:enableWindowsUpdate
echo [>] Enabling Windows Update...
sc config wuauserv start= auto
sc start wuauserv
if %errorlevel% equ 0 (
    echo [>] Updates enabled.
) else (
    echo [!] **Error:** Enabling failed. Please check permissions.
)
echo.
pause
goto mainMenu

:disableWindowsUpdate
echo.
echo [!] **Warning:** Disabling updates is a security risk.
set /p confirm_disable_update=  Do you want to continue? (Y/N):
if /i "%confirm_disable_update%"=="Y" (
    echo [>] Disabling Windows Update...
    sc config wuauserv start= disabled
    sc stop wuauserv
    if %errorlevel% equ 0 (
        echo [>] Updates disabled. **Security risk!**
    ) else (
        echo [!] **Error:** Disabling failed. Please check permissions.
    )
    echo.
    pause
) else (
    echo [>] Disabling Updates cancelled.
    echo.
    pause
)
goto mainMenu

:checkWindowsUpdates
echo [>] Checking for updates...
powershell -Command "(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()"
echo [>] Update check initiated. Please see Settings > Windows Update.
echo.
pause
goto mainMenu

:autoLogin
echo.
echo [>] Setting Auto-login (**Security Risk!**)...
echo [!] **Security Warning:** Auto-login bypasses login screen, reduces security.
echo [!] Please use only on secure, personal machines.
set /p username=  Please enter username:
set /p password=  Please enter password:
call :modifyRegistry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "REG_SZ" "%username%"
call :modifyRegistry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "REG_SZ" "%password%"
call :modifyRegistry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "REG_SZ" "1"
echo [>] Auto-login set. **Security risk!**
echo.
pause
goto mainMenu

:clearCache
echo [>] Clearing system cache...
del /q /f /s %TEMP%\* 2>nul
del /q /f /s C:\Windows\Temp\* 2>nul
echo [>] System cache cleared.
echo.
pause
goto mainMenu

:optimizeDisk
:optimizeDiskMenu
cls
echo.
echo  ╔══════════════════════════ Disk Optimization ══════════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] Analyze Disk              [3] Check Disk Errors         [5] Clean Up System Files        ║
echo  ║  [2] Optimize/Defrag           [4] Trim SSD                  [6] Return to Main Menu                ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p disk_choice=  Please select an option (1-6):
echo.

if "%disk_choice%"=="1" ( call :analyzeDisk ) else
if "%disk_choice%"=="2" ( call :optimizeDefrag ) else
if "%disk_choice%"=="3" ( call :checkDiskErrors ) else
if "%disk_choice%"=="4" ( call :trimSSD ) else
if "%disk_choice%"=="5" ( goto cleanup_system ) else
if "%disk_choice%"=="6" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto optimizeDiskMenu
)
goto optimizeDiskMenu

:analyzeDisk
echo [>] Analyzing disk...
defrag C: /A
echo [>] Disk analysis completed.
echo.
pause
goto mainMenu

:optimizeDefrag
echo [>] Optimizing/Defragmenting disk...
defrag C: /O
echo [>] Disk optimization completed.
echo.
pause
goto mainMenu

:checkDiskErrors
echo [>] Scheduling disk check for next restart...
echo [!] **Disk check will run on next system restart.**
chkdsk C: /F /R /X
echo.
pause
goto mainMenu

:trimSSD
echo [>] Enabling SSD TRIM...
fsutil behavior set disabledeletenotify 0
echo [>] SSD TRIM enabled.
echo.
pause
goto mainMenu

:cleanup_system
echo [>] Cleaning up system files...
if not exist "%USERPROFILE%\AppData\Local\Microsoft\CleanMgr\StateMgr\CustomState_1.ini" (
    echo [>] Disk Cleanup settings not found. Setting defaults...
    cleanmgr /sageset:1
    echo [!] Please select items to clean and click OK.
    pause
)
echo [>] Running Disk Cleanup...
cleanmgr /sagerun:1
echo [>] System file cleanup completed.
echo.
pause
goto mainMenu

:checkRepair
:checkRepairMenu
cls
echo.
echo  ╔══════════════ Check & Repair System Files ══════════════╗
echo  ║                                                            ║
echo  ║  [1] Run SFC                 [3] Check Disk Health          [5] Return to Main Menu ║
echo  ║  [2] Run DISM                [4] Verify System Files                         ║
echo  ║                                                            ║
echo  ╚══════════════════════════════════════════════════╝
echo.
set /p repair_choice=  Please select an option (1-5):
echo.

if "%repair_choice%"=="1" ( call :runSFC ) else
if "%repair_choice%"=="2" ( call :runDISM ) else
if "%repair_choice%"=="3" ( call :checkDiskHealth ) else
if "%repair_choice%"=="4" ( call :verifySFCFiles ) else
if "%repair_choice%"=="5" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto checkRepairMenu
)
goto checkRepairMenu

:runSFC
echo [>] Running System File Checker...
sfc /scannow
echo [>] SFC scan completed.
echo.
pause
goto mainMenu

:runDISM
echo [>] Running DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo [>] DISM repair completed.
echo.
pause
goto mainMenu

:checkDiskHealth
echo [>] Checking disk health...
wmic diskdrive get status
echo [>] Disk health check completed.
echo.
pause
goto mainMenu

:verifySFCFiles
echo [>] Verifying system files (sfcdetails.txt on Desktop)...
Findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log >"%userprofile%\Desktop\sfcdetails.txt"
echo [>] Verification completed. Results in sfcdetails.txt on Desktop.
echo.
pause
goto mainMenu

:windowsActivate
:windowsActivateMenu
cls
echo.
echo  ╔══════════ Windows Activation (KMS - **RISKY!**) ══════════╗
echo  ║                                                                 ║
echo  ║ **High Security and Legal Risk Warning:** KMS Activators         ║
echo  ║ are untrusted sources. Usage is **strongly NOT recommended**         ║
echo  ║ due to security threats and software piracy.                   ║
echo  ║                                                                 ║
echo  ║ **Proceed at your own risk!** By proceeding,                 ║
echo  ║ you acknowledge and accept all potential risks.               ║
echo  ║                                                                 ║
echo  ║  [1] Check Activation Status         [4] Input Product Key         [6] Return to Main Menu ║
echo  ║  [2] Activate using KMS (**HIGH RISK!**) [5] Remove Product Key                    ║
echo  ║  [3] Activate Digital License                                    ║
echo  ║                                                                 ║
echo  ╚══════════════════════════════════════════════════╝
echo.
set /p activate_choice=  Please select an option (1-6):
echo.

if "%activate_choice%"=="1" ( call :checkActivationStatus ) else
if "%activate_choice%"=="2" ( call :kmsActivateWarn ) else
if "%activate_choice%"=="3" ( call :digitalActivate ) else
if "%activate_choice%"=="4" ( call :manualProductKey ) else
if "%activate_choice%"=="5" ( call :removeProductKey ) else
if "%activate_choice%"=="6" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto windowsActivateMenu
)
goto windowsActivateMenu

:checkActivationStatus
echo [>] Checking activation status...
slmgr /xpr
echo.
pause
goto mainMenu

:kmsActivateWarn
cls
echo.
echo  ╔══════════ KMS Activation - **CONFIRM RISK!** ══════════╗
echo  ║                                                          ║
echo  ║ **You are about to use KMS ACTIVATION - HIGH RISK!**         ║
echo  ║ **Please confirm you understand and accept the security    ║
echo  ║ and legal risks (Y/N):**                                     ║
echo  ║                                                          ║
echo  ╚══════════════════════════════════════════════════╝
echo.
set /p confirm_kms_risk=  Confirm to proceed (Y/N):
if /i "%confirm_kms_risk%"=="Y" ( call :kmsActivate ) else (
    echo [>] KMS Activation cancelled.
    echo.
    pause
    goto windowsActivateMenu
)
goto windowsActivateMenu

:kmsActivate
echo [>] Attempting KMS activation (**HIGH RISK!**)...
net session >nul 2>&1 || (
    echo [!] **Error:** Administrator rights required.
    pause
    exit /b 1
)
powershell -command "irm https://get.activated.win | iex"
echo.
pause
goto mainMenu

:digitalActivate
echo [>] Attempting digital license activation...
slmgr /ato
if %errorlevel% neq 0 (
    echo [!] **Error:** Digital license activation failed.
) else (
    echo [>] Digital license activation attempted. Please check status.
)
echo.
pause
goto mainMenu

:manualProductKey
set /p product_key=  Please enter 25-character product key (XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
echo [>] Installing product key...
slmgr /ipk %product_key%
if %errorlevel% neq 0 (
    echo [!] **Error:** Key install failed. Invalid product key?
) else (
    echo [>] Key installed. Attempting activation...
    slmgr /ato
    if %errorlevel% neq 0 (
        echo [!] **Error:** Activation failed. Please check key.
    ) else (
        echo [>] Activation attempted. Please check status.
    )
)
echo.
pause
goto mainMenu

:removeProductKey
echo [>] Removing product key...
slmgr /upk
if %errorlevel% neq 0 (
    echo [!] **Error:** Key removal failed. Permissions?
) else (
    echo [>] Product key removed.
)
echo.
pause
goto mainMenu

:managePower
:managePowerMenu
cls
echo.
echo  ╔══════════════════════ Power Settings Management ══════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] List Power Plans             [4] Delete Power Plan (**Caution!**)       [7] Adjust Display/Sleep Timeouts ║
echo  ║  [2] Set Power Plan              [5] Adjust Sleep Settings                 [8] Configure Lid Close Action     ║
echo  ║  [3] Create Power Plan             [6] Configure Hibernation                 [9] Configure Power Button Action║
echo  ║                                                            [10] Return to Main Menu                ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p power_choice=  Please select an option (1-10):
echo.

if "%power_choice%"=="1" ( call :listPowerPlans ) else
if "%power_choice%"=="2" ( call :setPowerPlanMenu ) else
if "%power_choice%"=="3" ( call :createPowerPlanMenu ) else
if "%power_choice%"=="4" ( call :deletePowerPlanMenu ) else
if "%power_choice%"=="5" ( call :adjustSleepSettings ) else
if "%power_choice%"=="6" ( call :configureHibernationMenu ) else
if "%power_choice%"=="7" ( call :adjustTimeoutsMenu ) else
if "%power_choice%"=="8" ( call :lidCloseActionMenu ) else
if "%power_choice%"=="9" ( call :powerButtonActionMenu ) else
if "%power_choice%"=="10" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto managePowerMenu
)
goto managePowerMenu

:listPowerPlans
echo [>] Listing power plans...
powercfg /list
echo.
pause
goto mainMenu

:setPowerPlanMenu
echo [>] Available power plans:
powercfg /list
set /p plan_guid=  Please enter plan GUID to set:
call :setPowerPlan "%plan_guid%"
goto managePowerMenu

:setPowerPlan
powercfg /setactive %~1
if %errorlevel% neq 0 (
    echo [!] **Error:** Failed to set plan. Please check GUID.
) else (
    echo [>] Power plan set.
)
echo.
pause
goto managePowerMenu

:createPowerPlanMenu
set /p plan_name=  Please enter new power plan name:
call :createPowerPlan "%plan_name%"
goto managePowerMenu

:createPowerPlan
powercfg /duplicatescheme scheme_balanced
if %errorlevel% equ 0 (
    powercfg /changename %~1
    echo [>] Power plan created.
) else (
    echo [!] **Error:** Plan creation failed.
)
echo.
pause
goto managePowerMenu

:deletePowerPlanMenu
echo [>] Available power plans:
powercfg /list
set /p del_guid=  Please enter plan GUID to delete (**Caution!**):
call :deletePowerPlan "%del_guid%"
goto managePowerMenu

:deletePowerPlan
echo.
echo [!] **Warning:** Deleting power plan may delete active plan.
set /p confirm_delete_plan=  Do you want to continue? (Y/N):
if /i "%confirm_delete_plan%"=="Y" (
    powercfg /delete %~1
    if %errorlevel% equ 0 (
        echo [>] Power plan deleted.
    ) else (
        echo [!] **Error:** Plan deletion failed. Please check GUID.
    )
    echo.
    pause
) else (
    echo [>] Plan deletion cancelled.
    echo.
    pause
)
goto managePowerMenu

:adjustSleepSettings
set /p sleep_time=  Minutes before sleep (0=never):
powercfg /change standby-timeout-ac %sleep_time%
powercfg /change standby-timeout-dc %sleep_time%
echo [>] Sleep settings adjusted.
echo.
pause
goto managePowerMenu

:configureHibernationMenu
:configureHibernationSubMenu
cls
echo.
echo  ╔══════════════ Configure Hibernation ══════════════╗
echo  ║                                                      ║
echo  ║  [1] Enable Hibernation      [2] Disable Hibernation  [3] Return to Power Menu ║
echo  ║                                                      ║
echo  ╚══════════════════════════════════════════════╝
echo.
set /p hib_choice=  Please select an option (1-3):
echo.

if "%hib_choice%"=="1" ( call :enableHibernation ) else
if "%hib_choice%"=="2" ( call :disableHibernation ) else
if "%hib_choice%"=="3" ( goto managePowerMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto configureHibernationSubMenu
)
goto configureHibernationSubMenu

:enableHibernation
powercfg /hibernate on
echo [>] Hibernation enabled.
echo.
pause
goto configureHibernationMenu

:disableHibernation
powercfg /hibernate off
echo [>] Hibernation disabled.
echo.
pause
goto configureHibernationMenu

:adjustTimeoutsMenu
set /p display_ac=  Minutes to turn off display (AC):
set /p display_dc=  Minutes to turn off display (Battery):
set /p sleep_ac=    Minutes before sleep (AC):
set /p sleep_dc=    Minutes before sleep (Battery):
call :adjustTimeouts "%display_ac%" "%display_dc%" "%sleep_ac%" "%sleep_dc%"
goto managePowerMenu

:adjustTimeouts
powercfg /change monitor-timeout-ac %~1
powercfg /change monitor-timeout-dc %~2
powercfg /change standby-timeout-ac %~3%
powercfg /change standby-timeout-dc %~4%
echo [>] Display/sleep timeouts adjusted.
echo.
pause
goto managePowerMenu

:lidCloseActionMenu & call :powerActionMenu "lid" "Lid Close" & goto managePowerMenu
:powerButtonActionMenu & call :powerActionMenu "pbutton" "Power Button" & goto managePowerMenu

:powerActionMenu
:powerActionSubMenu_%~1
cls
echo.
echo  ╔══════════ Configure %~2 Action ══════════╗
echo  ║                                              ║
echo  ║  [1] Do Nothing  [2] Sleep  [3] Hibernate  [4] Shut Down  [5] Return to Power Menu ║
echo  ║                                              ║
echo  ╚══════════════════════════════════════════╝
echo.
set /p action_choice=  Please select an option (1-5):
echo.

if "%action_choice%"=="1" ( set action=0 ) else
if "%action_choice%"=="2" ( set action=1 ) else
if "%action_choice%"=="3" ( set action=2 ) else
if "%action_choice%"=="4" ( set action=3 ) else
if "%action_choice%"=="5" ( goto managePowerMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto powerActionSubMenu_%~1
)
if defined action ( call :setPowerAction %~1action% %action% & pause )
goto powerActionMenu

:setPowerAction
powercfg /setacvalueindex scheme_current sub_buttons %~1 %~2
powercfg /setdcvalueindex scheme_current sub_buttons %~1 %~2
powercfg /setactive scheme_current
echo [>] %~1 action set.
echo.
goto powerActionMenu

:enableDarkMode
echo [>] Enabling Dark Mode...
call :modifyRegistry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "REG_DWORD" "0"
call :modifyRegistry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "REG_DWORD" "0"
echo [>] Dark Mode enabled.
echo.
pause
goto mainMenu

:managePartitions
:managePartitionsMenu
cls
echo.
echo  ╔══════ Partition Management (**DATA LOSS RISK!**) ══════╗
echo  ║                                                          ║
echo  ║ **Warning:** Partition management may cause **permanent data loss**.   ║
echo  ║ Please backup all important data!                             ║
echo  ║                                                          ║
echo  ║  [1] List Partitions        [3] Delete Partition (**DATA LOSS!**)  [5] Return to Main Menu ║
echo  ║  [2] Create Partition (**DATA LOSS RISK!**) [4] Format Partition (**DATA LOSS!**)    ║
echo  ║                                                          ║
echo  ╚══════════════════════════════════════════════╝
echo.
set /p part_choice=  Please select an option (1-5):
echo.

if "%part_choice%"=="1" ( call :listPartitions ) else
if "%part_choice%"=="2" ( call :createPartitionMenu ) else
if "%part_choice%"=="3" ( call :deletePartitionMenu ) else
if "%part_choice%"=="4" ( call :formatPartitionMenu ) else
if "%part_choice%"=="5" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto managePartitionsMenu
)
goto managePartitionsMenu

:listPartitions
echo [>] Listing Partitions...
echo list disk > list_disk.txt
echo list volume >> list_disk.txt
diskpart /s list_disk.txt
del list_disk.txt
echo.
pause
goto managePartitionsMenu

:createPartitionMenu
echo [!] **Data Loss Risk! Please backup data!**
set /p disk_num=  Please enter disk number:
set /p part_size=  Please enter partition size (MB):
call :createPartition "%disk_num%" "%part_size%"
goto managePartitionsMenu

:createPartition
echo [>] Creating Partition (**Data Loss Risk!**)...
(
    echo select disk %~1
    echo create partition primary size=%~2
) > create_part.txt
diskpart /s create_part.txt
del create_part.txt
echo [>] Partition created. **Please check Disk Management.**
echo.
pause
goto managePartitionsMenu

:deletePartitionMenu
echo [!] **Permanent Data Loss Warning! Please backup data!**
set /p disk_num=  Please enter disk number:
set /p part_num=  Please enter partition number:
call :deletePartition "%disk_num%" "%part_num%"
goto managePartitionsMenu

:deletePartition
echo [>] Deleting Partition (**Permanent Data Loss!**)...
echo [!] **Warning: Data will be permanently lost! Do you want to continue? (Y/N)**
set /p confirm_delete_part=  Confirm partition deletion (Y/N):
if /i "%confirm_delete_part%"=="Y" (
    (
        echo select disk %~1
        echo select partition %~2
        echo delete partition override
    ) > delete_part.txt
    diskpart /s delete_part.txt
    del delete_part.txt
    echo [>] Partition deleted. **Permanent data loss! Please check Disk Management.**
    echo.
    pause
) else (
    echo [>] Partition deletion cancelled.
    echo.
    pause
)
goto managePartitionsMenu

:formatPartitionMenu
echo [!] **Data Loss Warning! Please backup data!**
set /p disk_num=  Please enter disk number:
set /p part_num=  Please enter partition number:
set /p fs=       Please enter file system (NTFS/FAT32):
call :formatPartition "%disk_num%" "%part_num%" "%fs%"
goto managePartitionsMenu

:formatPartition
echo [>] Formatting Partition (**Data Loss!**)...
echo [!] **Warning: Data will be lost! Do you want to continue? (Y/N)**
set /p confirm_format_part=  Confirm partition formatting (Y/N):
if /i "%confirm_format_part%"=="Y" (
    (
        echo select disk %~1
        echo select partition %~2
        echo format fs=%~3% quick
    ) > format_part.txt
    diskpart /s format_part.txt
    del format_part.txt
    echo [>] Partition formatted. **Data lost! Please check Disk Management.**
    echo.
    pause
) else (
    echo [>] Partition formatting cancelled.
    echo.
    pause
)
goto managePartitionsMenu

:manageStartup
echo [>] Managing startup programs...
start msconfig
echo [>] Please use System Configuration utility to manage startup programs.
echo.
pause
goto mainMenu

:backupRestore
:backupRestoreMenu
cls
echo.
echo  ╔══════════ Backup & Restore Settings ══════════╗
echo  ║                                              ║
echo  ║  [1] Create Restore Point    [2] Restore from Restore Point  [3] Return to Main Menu ║
echo  ║                                              ║
echo  ╚══════════════════════════════════════════╝
echo.
set /p backup_choice=  Please select an option (1-3):
echo.

if "%backup_choice%"=="1" ( call :createRestorePoint ) else
if "%backup_choice%"=="2" ( call :restoreFromPoint ) else
if "%backup_choice%"=="3" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto backupRestoreMenu
)
goto backupRestoreMenu

:createRestorePoint
echo [>] Creating system restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Manual Restore Point", 100, 7
echo [>] System restore point created.
echo.
pause
goto mainMenu

:restoreFromPoint
echo [>] Restoring from restore point...
rstrui.exe
echo [>] Please follow on-screen instructions to restore system.
echo.
pause
goto mainMenu

:systemInfo
echo [>] Displaying system information...
systeminfo
echo.
pause
goto mainMenu

:optimizePrivacy
echo [>] Optimizing privacy settings...
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0" & echo [>] - Telemetry disabled.
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "1" & echo [>] - Advertising ID disabled.
call :modifyRegistry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" "REG_DWORD" "0" & echo [>] - Additional Telemetry disabled.
echo [>] Privacy settings optimized.
echo.
pause
goto mainMenu

:manageServices
:manageServicesMenu
cls
echo.
echo  ╔══════════ Windows Services Management ══════════╗
echo  ║                                                ║
echo  ║  [1] List All Services         [4] Start Service         [7] Change Startup Type  [10] Return to Main Menu ║
echo  ║  [2] List Running Services     [5] Stop Service          [8] Search for Service                 ║
echo  ║  [3] List Stopped Services     [6] Restart Service       [9] View Service Details               ║
echo  ║                                                ║
echo  ╚══════════════════════════════════════════════╝
echo.
set /p service_choice=  Please select an option (1-10):
echo.

if "%service_choice%"=="1" ( call :listAllServices ) else
if "%service_choice%"=="2" ( call :listRunningServices ) else
if "%service_choice%"=="3" ( call :listStoppedServices ) else
if "%service_choice%"=="4" ( call :startServiceMenu ) else
if "%service_choice%"=="5" ( call :stopServiceMenu ) else
if "%service_choice%"=="6" ( call :restartServiceMenu ) else
if "%service_choice%"=="7" ( call :changeStartupTypeMenu ) else
if "%service_choice%"=="8" ( call :searchServiceMenu ) else
if "%service_choice%"=="9" ( call :viewServiceDetailsMenu ) else
if "%service_choice%"=="10" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto manageServicesMenu
)
goto manageServicesMenu

:listAllServices
echo [>] Listing all services...
sc query type= service state= all
echo.
pause
goto manageServicesMenu

:listRunningServices
echo [>] Listing running services...
sc query type= service state= running
echo.
pause
goto manageServicesMenu

:listStoppedServices
echo [>] Listing stopped services...
sc query type= service state= stopped
echo.
pause
goto manageServicesMenu

:startServiceMenu
set /p service_name=  Please enter service name to start:
call :startService "%service_name%"
goto manageServicesMenu

:startService
sc start "%~1"
if %errorlevel% neq 0 (
    echo [!] **Error:** Failed to start service. Please check name/permissions.
) else (
    echo [>] Service start attempted. Please check status.
)
echo.
pause
goto manageServicesMenu

:stopServiceMenu
set /p service_name=  Please enter service name to stop:
call :stopService "%service_name%"
goto manageServicesMenu

:stopService
sc stop "%~1"
if %errorlevel% neq 0 (
    echo [!] **Error:** Failed to stop service. Please check name/permissions.
) else (
    echo [>] Service stop attempted. Please check status.
)
echo.
pause
goto manageServicesMenu

:restartServiceMenu
set /p service_name=  Please enter service name to restart:
call :restartService "%service_name%"
goto manageServicesMenu

:restartService
sc stop "%~1"
timeout /t 2 >nul
sc start "%~1"
if %errorlevel% neq 0 (
    echo [!] **Error:** Failed to restart service. Please check name/permissions.
) else (
    echo [>] Service restart attempted. Please check status.
)
echo.
pause
goto manageServicesMenu

:changeStartupTypeMenu
set /p service_name=  Please enter service name:
:changeStartupTypeSubMenu
cls
echo.
echo  ╔══════ Change Service Startup Type ══════╗
echo  ║                                        ║
echo  ║  [1] Automatic        [3] Manual        ║
echo  ║  [2] Automatic (Delayed) [4] Disabled     ║
echo  ║                                        ║
echo  ╚══════════════════════════════════════╝
echo.
set /p startup_choice=  Please select an option (1-4):
echo.

if "%startup_choice%"=="1" ( set start_type=auto ) else
if "%startup_choice%"=="2" ( set start_type=delayed-auto ) else
if "%startup_choice%"=="3" ( set start_type=demand ) else
if "%startup_choice%"=="4" ( set start_type=disabled ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto changeStartupTypeSubMenu
)
if defined start_type ( call :changeServiceStartup "%service_name%" "%start_type%" )
goto changeStartupTypeMenu

:changeServiceStartup
sc config "%~1" start= %~2
if %errorlevel% neq 0 (
    echo [!] **Error:** Failed to change startup type. Please check name/permissions.
) else (
    echo [>] Startup type changed successfully.
)
echo.
pause
goto changeStartupTypeMenu

:searchServiceMenu
set /p search_term=  Please enter service name search term:
call :searchService "%search_term%"
goto manageServicesMenu

:searchService
sc query state= all | findstr /i "%~1"
echo.
pause
goto manageServicesMenu

:viewServiceDetailsMenu
set /p service_name=  Please enter service name for details:
call :viewServiceDetails "%service_name%"
goto manageServicesMenu

:viewServiceDetails
sc qc "%~1"
echo.
echo [>] Current status:
sc query "%~1"
echo.
pause
goto manageServicesMenu

:networkOptimization
:networkOptimizationMenu
cls
echo.
echo  ╔══════════════════════ Network Optimization ══════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] Optimize TCP Settings         [5] Disable IPv6 (**Caution**)           [8] Reset All Network Settings (**Restart Req.**) ║
echo  ║  [2] Reset Winsock (**Restart Req.**) [6] Enable QoS Packet Scheduler       [9] Return to Main Menu                            ║
echo  ║  [3] Clear DNS Cache               [7] Set Static DNS Servers                                   ║
echo  ║  [4] Optimize Adapter (**Advanced**)                                                          ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p net_choice=  Please select an option (1-9):
echo.

if "%net_choice%"=="1" ( call :optimizeTCPSettings ) else
if "%net_choice%"=="2" ( call :resetWinsock ) else
if "%net_choice%"=="3" ( call :clearDNSCache ) else
if "%net_choice%"=="4" ( call :optimizeAdapterSettings ) else
if "%net_choice%"=="5" ( call :disableIPv6Menu ) else
if "%net_choice%"=="6" ( call :enableQoSPacketScheduler ) else
if "%net_choice%"=="7" ( call :setStaticDNSMenu ) else
if "%net_choice%"=="8" ( call :resetNetworkSettings ) else
if "%net_choice%"=="9" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto networkOptimizationMenu
)
goto networkOptimizationMenu

:optimizeTCPSettings
echo [>] Optimizing TCP settings...
netsh int tcp set global autotuninglevel=normal & netsh int tcp set global congestionprovider=ctcp & netsh int tcp set global ecncapability=enabled & netsh int tcp set heuristics disabled
netsh int tcp set global rss=enabled & netsh int tcp set global fastopen=enabled & netsh int tcp set global timestamps=disabled & netsh int tcp set global initialRto=2000 & netsh int tcp set global nonsackrttresiliency=disabled
echo [>] TCP settings optimized.
echo.
pause
goto mainMenu

:resetWinsock
echo [>] Resetting Winsock...
netsh winsock reset
echo [>] Winsock reset. **Please Restart computer!**
echo.
pause
goto mainMenu

:clearDNSCache
echo [>] Clearing DNS cache...
ipconfig /flushdns
echo [>] DNS cache cleared.
echo.
pause
goto mainMenu

:optimizeAdapterSettings
echo [>] Optimizing adapter settings (**Advanced - Use with caution**)...
for /f "tokens=3*" %%a in ('netsh int show interface ^| findstr /i "connected"') do set "interface_name=%%b"
if defined interface_name (
    netsh int ip set interface name="%interface_name%" dadtransmits=0 store=persistent
    netsh int ip set interface name="%interface_name%" routerdiscovery=disabled store=persistent
    echo [>] Disabling TCP Security features (**May reduce security**)...
    netsh int tcp set security mpp=disabled & netsh int tcp set security profiles=disabled
    powershell -Command "Get-NetAdapter -Name '%interface_name%' | Set-NetAdapterAdvancedProperty -RegistryKeyword '*FlowControl' -RegistryValue 0; Set-NetAdapterAdvancedProperty -RegistryKeyword '*InterruptModeration' -RegistryValue 0; Set-NetAdapterAdvancedProperty -RegistryKeyword '*PriorityVLANTag' -RegistryValue 3; Set-NetAdapterAdvancedProperty -RegistryKeyword '*SpeedDuplex' -RegistryValue 0"
    echo [>] Adapter settings optimized. **Please check connection after tuning.**
) else (
    echo [!] **Error:** No active interface found. Adapter optimization failed.
)
echo.
pause
goto mainMenu

:disableIPv6Menu
echo.
echo [!] **Warning:** Disabling IPv6 may cause network issues.
set /p confirm_ipv6_disable=  Do you want to continue? (Y/N):
if /i "%confirm_ipv6_disable%"=="Y" ( call :disableIPv6 ) else (
    echo [>] IPv6 disabling cancelled.
    echo.
    pause
    goto networkOptimizationMenu
)
goto networkOptimizationMenu

:disableIPv6
echo [>] Disabling IPv6...
netsh interface ipv6 set global randomizeidentifiers=disabled
netsh interface ipv6 set privacy state=disabled
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f
echo [>] IPv6 disabled. **Please Restart computer! Check connection.**
echo.
pause
goto mainMenu

:enableQoSPacketScheduler
echo [>] Enabling QoS Packet Scheduler...
netsh int tcp set global packetcoalescinginbound=disabled
sc config "Qwave" start= auto
net start Qwave
echo [>] QoS Packet Scheduler enabled.
echo.
pause
goto mainMenu

:setStaticDNSMenu
set /p primary_dns=   Please enter primary DNS (e.g., 8.8.8.8):
set /p secondary_dns= Please enter secondary DNS (e.g., 8.8.4.4):
call :setStaticDNS "%primary_dns%" "%secondary_dns%"
goto networkOptimizationMenu

:setStaticDNS
for /f "tokens=3*" %%a in ('netsh int show interface ^| findstr /i "connected"') do set "interface_name=%%b"
if defined interface_name (
    netsh interface ip set dns name="%interface_name%" source=static address=%~1 register=primary
    netsh interface ip add dns name="%interface_name%" address=%~2 index=2
    echo [>] Static DNS set.
) else (
    echo [!] **Error:** No active interface found. Static DNS failed.
)
echo.
pause
goto mainMenu

:resetNetworkSettings
echo [>] Resetting all network settings (**Restart Required**)...
netsh winsock reset & netsh int ip reset & netsh advfirewall reset & ipconfig /release & ipconfig /renew & ipconfig /flushdns
echo [>] All network settings reset. **Please Restart computer!**
echo.
pause
goto mainMenu

:disableTransparency
echo [>] Disabling Transparency Effects...
call :modifyRegistry "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency" "REG_DWORD" "0"
echo [>] Transparency Effects disabled.
echo.
pause
goto mainMenu

:disableAnimationsExtra
echo [>] Disabling Extra Animation Effects...
call :modifyRegistry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Animations" "REG_DWORD" "0"
call :modifyRegistry "HKCU\Control Panel\Desktop" "DragFullWindows" "REG_SZ" "1"
echo [>] Extra Animations disabled.
echo.
pause
goto mainMenu

:optimizeStorageSenseMenu
:optimizeStorageSenseSubMenu
cls
echo.
echo  ╔══════════ Storage Sense Optimization ══════════╗
echo  ║                                              ║
echo  ║  [1] Enable Storage Sense      [3] Configure Recycle Bin Cleanup  [5] Return to Main Menu ║
echo  ║  [2] Set Cleanup Frequency     [4] Configure Temp Files Cleanup                  ║
echo  ║                                              ║
echo  ╚══════════════════════════════════════════╝
echo.
set /p ss_choice=  Please select an option (1-5):
echo.

if "%ss_choice%"=="1" ( call :enableStorageSense ) else
if "%ss_choice%"=="2" ( call :configCleanupFrequencyMenu ) else
if "%ss_choice%"=="3" ( call :configRecycleBinCleanup ) else
if "%ss_choice%"=="4" ( call :configTempFilesCleanup ) else
if "%ss_choice%"=="5" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto optimizeStorageSenseSubMenu
)
goto optimizeStorageSenseSubMenu

:enableStorageSense
echo [>] Enabling Storage Sense...
call :modifyRegistry "HKCU\Software\Microsoft\Windows\StorageSense" "Enabled" "REG_DWORD" "1"
echo [>] Storage Sense enabled.
echo.
pause
goto mainMenu

:configCleanupFrequencyMenu
:configCleanupFrequencySubMenu
cls
echo.
echo  ╔══════════ Cleanup Frequency ══════════╗
echo  ║                                       ║
echo  ║  [1] Every Day    [3] Every Month      ║
echo  ║  [2] Every Week   [4] Low Disk Space   ║
echo  ║                                       ║
echo  ╚══════════════════════════════════════╝
echo.
set /p freq_choice=  Please select an option (1-4):
echo.

if "%freq_choice%"=="1" ( set freq_val=1 ) else
if "%freq_choice%"=="2" ( set freq_val=7 ) else
if "%freq_choice%"=="3" ( set freq_val=30 ) else
if "%freq_choice%"=="4" ( set freq_val=0 ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto configCleanupFrequencySubMenu
)
if defined freq_val ( call :configCleanupFrequency "%freq_val%" )
goto configCleanupFrequencyMenu

:configCleanupFrequency
call :modifyRegistry "HKCU\Software\Microsoft\Windows\StorageSense" "CleanupFrequency" "REG_DWORD" "%~1"
echo [>] Cleanup frequency set.
echo.
pause
goto mainMenu

:configRecycleBinCleanup
set /p rb_days=  Days for Recycle Bin cleanup (0=disable):
call :modifyRegistry "HKCU\Software\Microsoft\Windows\StorageSense" "DaysToRunRecycleBinCleanup" "REG_DWORD" "%rb_days%"
echo [>] Recycle Bin cleanup set.
echo.
pause
goto mainMenu

:configTempFilesCleanup
set /p temp_days=  Days for Temp Files cleanup (0=disable):
call :modifyRegistry "HKCU\Software\Microsoft\Windows\StorageSense" "DaysToRunTempFilesCleanup" "REG_DWORD" "%temp_days%"
echo [>] Temp files cleanup set.
echo.
pause
goto mainMenu

:disableStartupSound
echo [>] Disabling Startup Sound...
call :modifyRegistry "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\Explorer\WindowsLogon\.Current" ".Default" "REG_SZ" "%SystemRoot%\media\Windows Logon.wav"
call :modifyRegistry "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\Explorer\WindowsLogon\.Current" "ExcludeFromCPL" "REG_DWORD" "1"
echo [>] Startup Sound disabled.
echo.
pause
goto mainMenu

:optimizePagingFileMenu
:optimizePagingFileSubMenu
cls
echo.
echo  ╔══════ Paging File (Virtual Memory) Optimization (**Advanced**) ══════╗
echo  ║                                                                      ║
echo  ║ **Advanced Warning:** Incorrect Paging File settings can harm system stability.   ║
echo  ║ Please proceed with caution and research information!                        ║
echo  ║                                                                      ║
echo  ║  [1] System Managed Size (**Recommended**) [3] Disable Paging File (**NOT Recommended!**) [5] Return to Main Menu ║
echo  ║  [2] Custom Size                               [4] Return to CPU Menu                       ║
echo  ║                                                                      ║
echo  ╚══════════════════════════════════════════════════════════╝
echo.
set /p pf_choice=  Please select an option (1-5):
echo.

if "%pf_choice%"=="1" ( call :systemManagedPagingFile ) else
if "%pf_choice%"=="2" ( call :customSizePagingFileMenu ) else
if "%pf_choice%"=="3" ( call :disablePagingFileWarn ) else
if "%pf_choice%"=="4" ( goto optimizeCPUMenu ) else
if "%pf_choice%"=="5" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto optimizePagingFileSubMenu
)
goto optimizePagingFileSubMenu

:systemManagedPagingFile
echo [>] Setting Paging File to System Managed Size (**Recommended**)...
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True
echo [>] Paging File set to System Managed.
echo.
pause
goto mainMenu

:customSizePagingFileMenu
set /p initial_size=  Please enter initial size (MB):
set /p max_size=      Please enter maximum size (MB):
call :customSizePagingFile "%initial_size%" "%max_size%"
goto optimizePagingFileMenu

:customSizePagingFile
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=%~1,MaximumSize=%~2
echo [>] Paging File set to Custom Size (Initial: %~1MB, Max: %~2MB).
echo.
pause
goto mainMenu

:disablePagingFileWarn
cls
echo.
echo  ╔══════ Disable Paging File - **CONFIRM RISK!** ══════╗
echo  ║                                                          ║
echo  ║ **You are about to DISABLE PAGING FILE - NOT Recommended!**             ║
echo  ║ **Please confirm you understand SYSTEM STABILITY risks (Y/N):** ║
echo  ║                                                          ║
echo  ╚══════════════════════════════════════════════╝
echo.
set /p confirm_pf_disable=  Confirm to proceed (Y/N):
if /i "%confirm_pf_disable%"=="Y" ( call :disablePagingFile ) else (
    echo [>] Paging File disabling cancelled.
    echo.
    pause
    goto optimizePagingFileMenu
)
goto optimizePagingFileMenu

:disablePagingFile
echo [>] Disabling Paging File (**NOT Recommended!**)...
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False
wmic pagefileset where name="C:\\pagefile.sys" delete
echo [>] Paging File disabled. **System instability risk! Restart & test system.**
echo.
pause
goto mainMenu

:disableWidgets
echo [>] Disabling Widget Features (Windows 11)...
call :modifyRegistry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarDa" "REG_DWORD" "0"
call :modifyRegistry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarMn" "REG_DWORD" "0"
echo [>] Widget Features disabled. (**Restart Explorer or PC recommended.**)
echo.
pause
goto mainMenu

:optimizeGameModeMenu
:optimizeGameModeSubMenu
cls
echo.
echo  ╔══════════ Game Mode Optimization ══════════╗
echo  ║                                             ║
echo  ║  [1] Enable Game Mode         [3] Disable Game DVR & Bar (Option 3) [5] Return to Main Menu ║
echo  ║  [2] Disable GameBar Service   [4] Return to CPU Menu                       ║
echo  ║                                             ║
echo  ╚══════════════════════════════════════════╝
echo.
set /p game_choice=  Please select an option (1-5):
echo.

if "%game_choice%"=="1" ( call :enableGameMode ) else
if "%game_choice%"=="2" ( call :disableGameBarService ) else
if "%game_choice%"=="3" ( call :disableGameDVRBar & pause & goto mainMenu ) else
if "%game_choice%"=="4" ( goto optimizeCPUMenu ) else
if "%game_choice%"=="5" ( goto mainMenu ) else (
    echo [!] **Error:** Invalid option.
    pause
    goto optimizeGameModeSubMenu
)
goto optimizeGameModeSubMenu

:enableGameMode
echo [>] Enabling Game Mode...
call :modifyRegistry "HKCU\Software\Microsoft\GameBar" "AllowAutoGameMode" "REG_DWORD" "1"
echo [>] Game Mode enabled.
echo.
pause
goto mainMenu

:disableGameBarService
echo [>] Disabling Game Bar Presence Writer Service...
sc config "GameBarSvc" start= disabled
sc stop "GameBarSvc" 2>nul
echo [>] Game Bar Presence Writer Service disabled.
echo.
pause
goto mainMenu

:showHelpMenu
cls
echo.
echo  ╔══════════════════════════ Help Menu ══════════════════════════╗
echo  ║                                                                              ║
echo  ║  Windows Optimization Script v3.5 - Enhanced Edition - Help                   ║
echo  ║                                                                              ║
echo  ║  Usage Instructions:                                                         ║
echo  ║  - Enter the option number (1-30) to select a menu.                          ║
echo  ║  - Options with **warnings** should be used with caution.                      ║
echo  ║  - Read instructions and warnings carefully before proceeding.                 ║
echo  ║  - If issues occur, please check administrator rights and Restart machine.     ║
echo  ║                                                                              ║
echo  ║  **Additional Information:**                                                  ║
echo  ║  - This script improves the efficiency and speed of Windows.                   ║
echo  ║  - Optimized for Windows 11 (may have compatibility issues with older Windows). ║
echo  ║  - Some optimizations may require a system Restart to take effect.              ║
echo  ║                                                                              ║
echo  ║  **Developer Contact:** [GT Singtaro]                                         ║
echo  ║  **Version:** 3.5 - Enhanced Edition                                          ║
echo  ║                                                                              ║
echo  ║  Press any key to return to the main menu...                                   ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
pause
goto mainMenu


:endexit
echo.
echo  ╔══════════════════════════════════════════════════════════════════╗
echo  ║         Thank you for using Windows Optimization Script! - Enhanced Edition         ║
echo  ║               Script developed by [GT Singtaro]                                 ║
echo  ║              Version 3.5 - Enhanced Edition - Main Menu                     ║
echo  ╚══════════════════════════════════════════════════════════════════╝
echo.
pause
exit

:: Function to modify registry with error handling (No changes needed)
:modifyRegistry
reg add %1 /v %2 /t %3 /d %4 /f 2>nul
if %errorlevel% neq 0 (
    echo [!] **Error:** Unable to modify registry key: %1\%2
    pause
)
exit /b 0
