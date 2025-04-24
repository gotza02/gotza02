@echo off
setlocal enabledelayedexpansion

:: Request Administrator Privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs"
    pushd "%CD%"
    CD /D "%~dp0"

:MainMenu
title Windows 11 AIO Tools & Tweaks (Categorized)
cls
echo =============================================
echo  Windows 11 All-In-One Tools & Tweaks
echo =============================================
echo  IMPORTANT: Run as Administrator.
echo  WARNING: Use tweaks & reset with caution.
echo           Backup data & create Restore Point!
echo =============================================
echo.
echo  --- Main Menu ---
echo   1. System Maintenance
echo   2. Network Tools
echo   3. Performance Tweaks
echo   4. System Configuration (Update/Defender)
echo   5. System Information & Tools
echo   6. System Recovery (Reset PC - CAUTION!)
echo.
echo   0. Exit
echo.
set /p mainchoice="Enter your choice: "

if "%mainchoice%"=="1" goto MaintenanceMenu
if "%mainchoice%"=="2" goto NetworkMenu
if "%mainchoice%"=="3" goto PerfTweaksMenu
if "%mainchoice%"=="4" goto ConfigMenu
if "%mainchoice%"=="5" goto SysToolsMenu
if "%mainchoice%"=="6" goto RecoveryMenu
if "%mainchoice%"=="0" goto ExitScript

echo Invalid choice. Press any key to return to menu.
pause > nul
goto MainMenu

:: ============================
:: === System Maintenance Menu ===
:: ============================
:MaintenanceMenu
cls
echo =============================================
echo  System Maintenance
echo =============================================
echo   1. Disk Cleanup
echo   2. System File Checker (SFC /scannow)
echo   3. DISM Check Health
echo   4. DISM Scan Health
echo   5. DISM Restore Health
echo   6. Defragment/Optimize Drives
echo   7. Check Disk (Current Drive - Read Only)
echo   8. Check Disk (Current Drive - Fix Errors - May need restart)
echo.
echo   B. Back to Main Menu
echo.
set /p choice="Enter choice: "
if "%choice%"=="1" goto DiskCleanup
if "%choice%"=="2" goto SFCScan
if "%choice%"=="3" goto DISMCheck
if "%choice%"=="4" goto DISMScan
if "%choice%"=="5" goto DISMRestore
if "%choice%"=="6" goto Defrag
if "%choice%"=="7" goto ChkDskReadOnly
if "%choice%"=="8" goto ChkDskFix
if /i "%choice%"=="B" goto MainMenu
echo Invalid choice.
pause
goto MaintenanceMenu

:: --- Maintenance Actions ---
:DiskCleanup
echo Starting Disk Cleanup...
cleanmgr /sageset:1
cleanmgr /sagerun:1
echo Disk Cleanup finished.
goto PauseReturnMaint

:SFCScan
echo Starting System File Checker... This may take a while.
sfc /scannow
echo SFC scan finished. Check output for results.
goto PauseReturnMaint

:DISMCheck
echo Starting DISM CheckHealth...
dism /Online /Cleanup-Image /CheckHealth
echo DISM CheckHealth finished.
goto PauseReturnMaint

:DISMScan
echo Starting DISM ScanHealth... This may take a while.
dism /Online /Cleanup-Image /ScanHealth
echo DISM ScanHealth finished.
goto PauseReturnMaint

:DISMRestore
echo Starting DISM RestoreHealth... Requires internet, may take long.
dism /Online /Cleanup-Image /RestoreHealth
echo DISM RestoreHealth finished.
goto PauseReturnMaint

:Defrag
echo Starting Drive Optimization...
start dfrgui.exe
echo Drive Optimization tool opened.
goto PauseReturnMaint

:ChkDskReadOnly
echo Starting Check Disk (Read-Only) on %SystemDrive%...
chkdsk %SystemDrive%
echo Check Disk (Read-Only) finished.
goto PauseReturnMaint

:ChkDskFix
echo Starting Check Disk (Fix Errors) on %SystemDrive%...
echo This may require a restart.
chkdsk %SystemDrive% /F /R /X
echo Check Disk (Fix Errors) scheduled or finished. Check output.
goto PauseReturnMaint

:PauseReturnMaint
echo.
pause
goto MaintenanceMenu

:: ============================
:: === Network Tools Menu ===
:: ============================
:NetworkMenu
cls
echo =============================================
echo  Network Tools
echo =============================================
echo   1. Show IP Configuration
echo   2. Flush DNS Cache
echo   3. Ping Google DNS (8.8.8.8)
echo   4. Reset TCP/IP Stack (Restart recommended)
echo   5. Change DNS Servers Submenu
echo.
echo   B. Back to Main Menu
echo.
set /p choice="Enter choice: "
if "%choice%"=="1" goto IPConfig
if "%choice%"=="2" goto FlushDNS
if "%choice%"=="3" goto PingTest
if "%choice%"=="4" goto ResetTCP
if "%choice%"=="5" goto DnsSubMenu
if /i "%choice%"=="B" goto MainMenu
echo Invalid choice.
pause
goto NetworkMenu

:: --- Network Actions ---
:IPConfig
echo Displaying IP Configuration...
ipconfig /all
goto PauseReturnNet

:FlushDNS
echo Flushing DNS cache...
ipconfig /flushdns
echo DNS cache flushed.
goto PauseReturnNet

:PingTest
echo Pinging Google DNS (8.8.8.8)...
ping 8.8.8.8
goto PauseReturnNet

:ResetTCP
echo Resetting TCP/IP Stack... This may require a restart.
netsh int ip reset
netsh winsock reset
echo TCP/IP Stack reset. A restart is recommended.
goto PauseReturnNet

:: --- DNS Submenu ---
:DnsSubMenu
cls
echo =============================================
echo  Change DNS Servers
echo =============================================
echo   1. Set DNS to Google (8.8.8.8, 8.8.4.4)
echo   2. Set DNS to Cloudflare (1.1.1.1, 1.0.0.1)
echo   3. Set DNS to Automatic (DHCP)
echo.
echo   B. Back to Network Menu
echo.
set /p dnschoice="Enter choice: "
if "%dnschoice%"=="1" goto SetGoogleDNS
if "%dnschoice%"=="2" goto SetCloudflareDNS
if "%dnschoice%"=="3" goto SetAutoDNS
if /i "%dnschoice%"=="B" goto NetworkMenu
echo Invalid choice.
pause
goto DnsSubMenu

:SetGoogleDNS
echo Setting DNS Servers to Google DNS...
echo Finding active network adapters...
for /f "tokens=3,*" %%a in ('netsh interface show interface ^| findstr /i "connected dedicated ethernet wi-fi"') do (
    echo Setting DNS for: %%b
    netsh interface ipv4 set dns name="%%b" static 8.8.8.8 primary validate=no
    netsh interface ipv4 add dns name="%%b" 8.8.4.4 index=2 validate=no
    netsh interface ipv6 set dns name="%%b" static 2001:4860:4860::8888 primary validate=no
    netsh interface ipv6 add dns name="%%b" 2001:4860:4860::8844 index=2 validate=no
)
ipconfig /flushdns
echo DNS set to Google DNS for active adapters. Flushed DNS cache.
goto PauseReturnDNS

:SetCloudflareDNS
echo Setting DNS Servers to Cloudflare DNS...
echo Finding active network adapters...
for /f "tokens=3,*" %%a in ('netsh interface show interface ^| findstr /i "connected dedicated ethernet wi-fi"') do (
    echo Setting DNS for: %%b
    netsh interface ipv4 set dns name="%%b" static 1.1.1.1 primary validate=no
    netsh interface ipv4 add dns name="%%b" 1.0.0.1 index=2 validate=no
    netsh interface ipv6 set dns name="%%b" static 2606:4700:4700::1111 primary validate=no
    netsh interface ipv6 add dns name="%%b" 2606:4700:4700::1001 index=2 validate=no
)
ipconfig /flushdns
echo DNS set to Cloudflare DNS for active adapters. Flushed DNS cache.
goto PauseReturnDNS

:SetAutoDNS
echo Setting DNS Servers to Automatic (DHCP)...
echo Finding active network adapters...
for /f "tokens=3,*" %%a in ('netsh interface show interface ^| findstr /i "connected dedicated ethernet wi-fi"') do (
    echo Setting DNS to DHCP for: %%b
    netsh interface ipv4 set dns name="%%b" source=dhcp
    netsh interface ipv6 set dns name="%%b" source=dhcp
)
ipconfig /flushdns
echo DNS set to Automatic (DHCP) for active adapters. Flushed DNS cache.
goto PauseReturnDNS

:PauseReturnDNS
echo.
pause
goto DnsSubMenu

:PauseReturnNet
echo.
pause
goto NetworkMenu


:: ============================
:: === Performance Tweaks Menu ===
:: ============================
:PerfTweaksMenu
cls
echo =============================================
echo  Performance Tweaks (Use with Caution!)
echo =============================================
echo   1. Registry Tweaks Submenu
echo   2. Optimize Services (Basic: Disables MapsBroker, RemoteRegistry, TabletInput)
echo   3. Set Power Plan to High Performance (or Ultimate)
echo   4. Disk Tweaks Submenu (TRIM Check)
echo   5. Network Tweaks Submenu (TCP Auto-Tuning)
echo.
echo   B. Back to Main Menu
echo.
set /p choice="Enter choice: "
if "%choice%"=="1" goto RegTweaksMenu
if "%choice%"=="2" goto OptimizeServices
if "%choice%"=="3" goto HighPerfPowerPlan
if "%choice%"=="4" goto DiskTweaksMenu
if "%choice%"=="5" goto NetTweaksMenu
if /i "%choice%"=="B" goto MainMenu
echo Invalid choice.
pause
goto PerfTweaksMenu

:: --- Performance Actions ---
:OptimizeServices
echo Basic Service Optimization (Disabling MapsBroker, RemoteRegistry, TabletInputService)...
sc config "MapsBroker" start= disabled
sc stop "MapsBroker" > nul 2>&1
sc config "RemoteRegistry" start= disabled
sc stop "RemoteRegistry" > nul 2>&1
sc config "TabletInputService" start= disabled
sc stop "TabletInputService" > nul 2>&1
echo Basic service optimization applied. Review services.msc for more details.
goto PauseReturnPerf

:HighPerfPowerPlan
echo Setting Power Plan to High Performance...
:: Find High Performance GUID
for /f "tokens=4" %%G in ('powercfg /list ^| findstr /C:"High performance"') do set HP_GUID=%%G
if defined HP_GUID (
    echo High Performance GUID: %HP_GUID%
    powercfg /setactive %HP_GUID%
    echo Power Plan set to High Performance.
) else (
    echo High Performance plan not found. Trying Ultimate Performance.
    :: Find Ultimate Performance GUID
    for /f "tokens=4" %%U in ('powercfg /list ^| findstr /C:"Ultimate Performance"') do set UP_GUID=%%U
    if defined UP_GUID (
        echo Ultimate Performance GUID: %UP_GUID%
        powercfg /setactive %UP_GUID%
        echo Power Plan set to Ultimate Performance.
    ) else (
        echo Ultimate Performance plan also not found. No changes made.
        echo You can try importing it: powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    )
)
goto PauseReturnPerf


:: --- Registry Tweaks Submenu ---
:RegTweaksMenu
cls
echo =============================================
echo  Registry Tweaks (Use with Caution!)
echo =============================================
echo  WARNING: Incorrect registry changes can cause system instability.
echo.
echo   1. Disable Cortana (Basic)
echo   2. Enable Cortana
echo   3. Disable Telemetry (Basic)
echo   4. Enable Telemetry (Default)
echo   5. Show File Extensions
echo   6. Hide File Extensions
echo   7. Show Hidden Files/Folders
echo   8. Hide Hidden Files/Folders
echo   9. Disable FSO (Full Screen Optimizations - Gaming)
echo  10. Enable FSO (Default)
echo.
echo   B. Back to Performance Menu
echo.
set /p regchoice="Enter your choice: "
if "%regchoice%"=="1" goto DisableCortana
if "%regchoice%"=="2" goto EnableCortana
if "%regchoice%"=="3" goto DisableTelemetry
if "%regchoice%"=="4" goto EnableTelemetry
if "%regchoice%"=="5" goto ShowExtensions
if "%regchoice%"=="6" goto HideExtensions
if "%regchoice%"=="7" goto ShowHidden
if "%regchoice%"=="8" goto HideHidden
if "%regchoice%"=="9" goto DisableFSO
if "%regchoice%"=="10" goto EnableFSO
if /i "%regchoice%"=="B" goto PerfTweaksMenu
echo Invalid choice.
pause
goto RegTweaksMenu

:DisableCortana
echo Disabling Cortana (Basic Registry Setting)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f
echo Cortana disabled (restart may be needed). Note: Deep integration may remain.
goto PauseReturnReg

:EnableCortana
echo Enabling Cortana...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /f
echo Cortana enabled (restart may be needed).
goto PauseReturnReg

:DisableTelemetry
echo Disabling Telemetry (Basic)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
sc config "DiagTrack" start= disabled
sc stop "DiagTrack" > nul 2>&1
echo Basic Telemetry disabled.
goto PauseReturnReg

:EnableTelemetry
echo Enabling Telemetry (Default)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 1 /f
sc config "DiagTrack" start= auto
sc start "DiagTrack" > nul 2>&1
echo Basic Telemetry enabled (Default).
goto PauseReturnReg

:ShowExtensions
echo Showing File Extensions...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe & start explorer.exe
echo File extensions should now be visible.
goto PauseReturnReg

:HideExtensions
echo Hiding File Extensions...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe & start explorer.exe
echo File extensions should now be hidden.
goto PauseReturnReg

:ShowHidden
echo Showing Hidden Files and Folders...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe & start explorer.exe
echo Hidden files/folders should now be visible.
goto PauseReturnReg

:HideHidden
echo Hiding Hidden Files and Folders...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe & start explorer.exe
echo Hidden files/folders should now be hidden.
goto PauseReturnReg

:DisableFSO
echo Disabling Full Screen Optimizations Globally...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f
echo Full Screen Optimizations disabled globally. Restart may be needed.
goto PauseReturnReg

:EnableFSO
echo Enabling Full Screen Optimizations Globally (Default)...
reg delete "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /f > nul 2>&1
reg delete "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /f > nul 2>&1
reg delete "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /f > nul 2>&1
echo Full Screen Optimizations enabled globally (Default). Restart may be needed.
goto PauseReturnReg

:PauseReturnReg
echo.
echo Registry change applied. A restart might be needed for some changes.
pause
goto RegTweaksMenu

:: --- Disk Tweaks Submenu ---
:DiskTweaksMenu
cls
echo =============================================
echo  Disk Tweaks
echo =============================================
echo   1. Check NVMe/SSD TRIM Status (0 = Enabled)
echo.
echo   B. Back to Performance Menu
echo.
set /p choice="Enter choice: "
if "%choice%"=="1" goto CheckTRIM
if /i "%choice%"=="B" goto PerfTweaksMenu
echo Invalid choice.
pause
goto DiskTweaksMenu

:CheckTRIM
echo Checking TRIM status (0 = Enabled, 1 = Disabled)...
fsutil behavior query DisableDeleteNotify
echo Note: DisableDeleteNotify = 0 means TRIM is ENABLED.
goto PauseReturnDiskT

:PauseReturnDiskT
echo.
pause
goto DiskTweaksMenu

:: --- Network Tweaks Submenu ---
:NetTweaksMenu
cls
echo =============================================
echo  Network Tweaks
echo =============================================
echo   1. Disable TCP Auto-Tuning (Try if unstable connection)
echo   2. Enable TCP Auto-Tuning (Default = normal)
echo.
echo   B. Back to Performance Menu
echo.
set /p choice="Enter choice: "
if "%choice%"=="1" goto DisableTCPAutoTune
if "%choice%"=="2" goto EnableTCPAutoTune
if /i "%choice%"=="B" goto PerfTweaksMenu
echo Invalid choice.
pause
goto NetTweaksMenu

:DisableTCPAutoTune
echo Disabling TCP Auto-Tuning...
netsh int tcp set global autotuninglevel=disabled
echo TCP Auto-Tuning disabled. Test your connection stability.
goto PauseReturnNetT

:EnableTCPAutoTune
echo Enabling TCP Auto-Tuning (Setting to Normal)...
netsh int tcp set global autotuninglevel=normal
echo TCP Auto-Tuning set to normal (Default).
goto PauseReturnNetT

:PauseReturnNetT
echo.
pause
goto NetTweaksMenu

:PauseReturnPerf
echo.
pause
goto PerfTweaksMenu


:: ===============================================
:: === System Configuration (Update/Defender) Menu ===
:: ===============================================
:ConfigMenu
cls
echo =============================================
echo  System Configuration
echo =============================================
echo  WARNING: Disabling Updates/Defender poses SECURITY RISKS!
echo.
echo  --- Windows Update ---
echo   1. Disable Windows Update Services (Risky!)
echo   2. Enable Windows Update Services
echo.
echo  --- Windows Defender (Use with EXTREME CAUTION!) ---
echo   3. Attempt to Disable Windows Defender (Risky! Needs Tamper Protection OFF)
echo   4. Attempt to Enable Windows Defender
echo.
echo   B. Back to Main Menu
echo.
set /p choice="Enter choice: "
if "%choice%"=="1" goto DisableWinUpdate
if "%choice%"=="2" goto EnableWinUpdate
if "%choice%"=="3" goto DisableDefender
if "%choice%"=="4" goto EnableDefender
if /i "%choice%"=="B" goto MainMenu
echo Invalid choice.
pause
goto ConfigMenu

:: --- Config Actions ---
:DisableWinUpdate
echo WARNING: Disabling Windows Update can expose your system to security risks!
echo Disabling Windows Update services...
sc config "wuauserv" start= disabled
sc stop "wuauserv" > nul 2>&1
sc config "BITS" start= disabled
sc stop "BITS" > nul 2>&1
sc config "UsoSvc" start= disabled
sc stop "UsoSvc" > nul 2>&1
sc config "DoSvc" start= disabled
sc stop "DoSvc" > nul 2>&1
echo Windows Update services (wuauserv, BITS, UsoSvc, DoSvc) disabled.
echo Note: Windows may attempt to re-enable these services.
goto PauseReturnConfig

:EnableWinUpdate
echo Enabling Windows Update services...
sc config "DoSvc" start= auto
sc start "DoSvc" > nul 2>&1
sc config "UsoSvc" start= auto
sc start "UsoSvc" > nul 2>&1
sc config "BITS" start= delayed-auto
sc start "BITS" > nul 2>&1
sc config "wuauserv" start= auto
sc start "wuauserv" > nul 2>&1
echo Windows Update services enabled and started. Check for updates manually if needed.
goto PauseReturnConfig

:DisableDefender
cls
echo ==================================================================
echo  EXTREME CAUTION: DISABLING WINDOWS DEFENDER
echo ==================================================================
echo WARNING: Disabling your primary antivirus leaves your system
echo          HIGHLY VULNERABLE to malware and threats.
echo          This is STRONGLY DISCOURAGED for most users.
echo.
echo NOTE: Windows actively protects Defender. These changes may be
echo       temporary or reverted. Tamper Protection in Windows
echo       Security might need to be disabled MANUALLY first.
echo ==================================================================
echo.
set /p confirm="Are you absolutely sure you want to attempt this? (Y/N): "
if /i not "%confirm%"=="Y" goto ConfigMenu

echo Attempting to disable Windows Defender via Registry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 1 /f

echo Attempting to disable related services...
sc config "WinDefend" start= disabled
sc stop "WinDefend" > nul 2>&1
sc config "WdNisSvc" start= disabled
sc stop "WdNisSvc" > nul 2>&1
sc config "Sense" start= disabled
sc stop "Sense" > nul 2>&1

echo Attempted to disable Windows Defender components.
echo A RESTART IS REQUIRED. Verify status in Windows Security after restart.
echo Remember to disable Tamper Protection first if changes don't stick.
goto PauseReturnConfig

:EnableDefender
echo Enabling Windows Defender...
echo Removing registry overrides...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /f > nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /f > nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /f > nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /f > nul 2>&1

echo Setting services back to default startup...
sc config "Sense" start= auto
sc start "Sense" > nul 2>&1
sc config "WdNisSvc" start= auto
sc start "WdNisSvc" > nul 2>&1
sc config "WinDefend" start= auto
sc start "WinDefend" > nul 2>&1

echo Attempted to enable Windows Defender components.
echo A RESTART IS RECOMMENDED. Verify status in Windows Security.
goto PauseReturnConfig

:PauseReturnConfig
echo.
pause
goto ConfigMenu


:: ====================================
:: === System Information & Tools Menu ===
:: ====================================
:SysToolsMenu
cls
echo =============================================
echo  System Information & Tools
echo =============================================
echo   1. Open Task Manager
echo   2. Open Services
echo   3. Open Event Viewer
echo   4. Open System Information
echo   5. Open Registry Editor
echo   6. Open System Restore
echo   7. Open Control Panel (Classic)
echo   8. Open Windows Security
echo.
echo   B. Back to Main Menu
echo.
set /p choice="Enter choice: "
if "%choice%"=="1" start taskmgr & goto SysToolsMenu
if "%choice%"=="2" start services.msc & goto SysToolsMenu
if "%choice%"=="3" start eventvwr.msc & goto SysToolsMenu
if "%choice%"=="4" start msinfo32 & goto SysToolsMenu
if "%choice%"=="5" start regedit & goto SysToolsMenu
if "%choice%"=="6" start rstrui.exe & goto SysToolsMenu
if "%choice%"=="7" start control & goto SysToolsMenu
if "%choice%"=="8" start ms-settings:windowsdefender & goto SysToolsMenu
if /i "%choice%"=="B" goto MainMenu
echo Invalid choice.
pause
goto SysToolsMenu


:: ====================================
:: === System Recovery Menu ===
:: ====================================
:RecoveryMenu
cls
echo =============================================
echo  System Recovery
echo =============================================
echo  *** EXTREME CAUTION ADVISED! ***
echo.
echo   1. Start "Reset this PC" Wizard
echo      (!!! WILL REINSTALL WINDOWS !!!)
echo      (You can choose to keep files or remove everything)
echo      (Applications and settings WILL BE REMOVED)
echo      (!!! THIS IS A MAJOR ACTION - BACKUP FIRST !!!)
echo.
echo   B. Back to Main Menu
echo.
set /p choice="Enter choice: "
if "%choice%"=="1" goto ResetPC
if /i "%choice%"=="B" goto MainMenu
echo Invalid choice.
pause
goto RecoveryMenu

:: --- Recovery Actions ---
:ResetPC
cls
echo ==================================================================
echo                          RESET THIS PC
echo ==================================================================
echo  WARNING: YOU ARE ABOUT TO START THE WINDOWS RESET PROCESS.
echo.
echo  * This will reinstall Windows.
echo  * You will have options to keep personal files or remove everything.
echo  * ALL applications and settings WILL BE REMOVED regardless of choice.
echo  * This process can take a significant amount of time.
echo  * Ensure your device is plugged into power.
echo  * Make absolutely sure you have backed up important data!
echo ==================================================================
echo.
set /p confirm1="ARE YOU ABSOLUTELY SURE YOU WANT TO PROCEED? (Type YES to confirm): "
if /i not "%confirm1%"=="YES" goto RecoveryMenu
echo.
set /p confirm2="FINAL CONFIRMATION: This will launch the Reset PC wizard. Type YES again: "
if /i not "%confirm2%"=="YES" goto RecoveryMenu

echo Starting the 'Reset this PC' wizard... The script will now exit.
systemreset -cleanpc
echo If the wizard doesn't start, search for "Reset this PC" in Windows Settings.
pause
goto ExitScript


:: ============================
:: === Exit Script ===
:: ============================
:ExitScript
echo Exiting...
endlocal
exit /B
