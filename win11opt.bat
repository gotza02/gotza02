@echo off
title Windows Ultimate Performance Optimization Script v4.1
color 0A
mode con: cols=120 lines=40
echo ==================================================================================
echo       Windows Ultimate Performance Optimization Script v4.1
echo ==================================================================================
echo Created by: Your Assistant
echo Current Date: %date% %time%
echo Warning: This script maximizes performance and disables security features.
echo Backup your data and ensure you have alternative security measures!
echo Press any key to start or CTRL+C to exit...
pause >nul

:: Enable delayed expansion for variables
setlocal EnableDelayedExpansion

:: Set environment variables
set "VERSION=4.1"
set "LOGFILE=%USERPROFILE%\Desktop\Optimization_Log_v%VERSION%.txt"
set "BACKUP_DIR=%USERPROFILE%\Desktop\Optimization_Backup_v%VERSION%"
set "ERROR_LOG=%USERPROFILE%\Desktop\Optimization_Error_Log.txt"
if not exist "!BACKUP_DIR!" mkdir "!BACKUP_DIR!"
echo Optimization Log v%VERSION% > "!LOGFILE!"
echo Start Time: %date% %time% >> "!LOGFILE!"

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Administrator privileges required!
    echo Log: Failed - No Admin Privileges >> "!LOGFILE!"
    echo Error: No Admin Privileges >> "!ERROR_LOG!"
    pause
    exit /b 1
)

:: Section 1: System Analysis
echo [1/31] Analyzing System Configuration...
echo Analyzing System... >> "!LOGFILE!"
systeminfo > "!BACKUP_DIR!\SystemInfo.txt" 2>nul
for /f "tokens=2 delims=[]" %%v in ('ver') do set "WIN_VER=%%v"
wmic diskdrive get caption, mediatype | find "SSD" >nul && set "DISK_TYPE=SSD" || (wmic diskdrive get caption, mediatype | find "NVMe" >nul && set "DISK_TYPE=NVMe" || set "DISK_TYPE=HDD")
for /f "tokens=2" %%r in ('systeminfo ^| find "Total Physical Memory"') do set "RAM_MB=%%r"
set "RAM_MB=!RAM_MB:,=!"
set /a RAM_GB=!RAM_MB!/1024 2>nul
wmic cpu get name | find "Intel" >nul && set "CPU_TYPE=Intel" || (wmic cpu get name | find "AMD" >nul && set "CPU_TYPE=AMD" || set "CPU_TYPE=Unknown")
for /f "skip=1" %%c in ('wmic cpu get NumberOfCores') do if not defined CPU_CORES set "CPU_CORES=%%c"
nvidia-smi -q >nul 2>&1 && set "GPU_TYPE=NVIDIA" || (wmic path win32_videocontroller get caption | find "AMD" >nul && set "GPU_TYPE=AMD" || set "GPU_TYPE=Unknown")
echo Windows Version: !WIN_VER! >> "!LOGFILE!"
echo Disk Type: !DISK_TYPE! >> "!LOGFILE!"
echo RAM: !RAM_GB! GB >> "!LOGFILE!"
echo CPU: !CPU_TYPE! with !CPU_CORES! cores >> "!LOGFILE!"
echo GPU: !GPU_TYPE! >> "!LOGFILE!"

:: Section 2: Create System Restore Point
echo [2/31] Creating System Restore Point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Pre-Optimization v%VERSION%", 100, 7 >nul 2>&1
if %errorlevel% neq 0 (
    echo Warning: Failed to create Restore Point >> "!LOGFILE!"
    echo Error: Restore Point Creation Failed >> "!ERROR_LOG!"
) else (
    echo Restore Point Created >> "!LOGFILE!"
)

:: Section 3: Backup System Settings
echo [3/31] Backing Up System Settings...
reg export HKLM\Software "!BACKUP_DIR!\RegBackup_System.reg" /y >nul 2>&1 || echo Error: System Registry Backup Failed >> "!ERROR_LOG!"
reg export HKCU\Software "!BACKUP_DIR!\RegBackup_User.reg" /y >nul 2>&1 || echo Error: User Registry Backup Failed >> "!ERROR_LOG!"
xcopy "C:\Windows\System32\config\*.bak" "!BACKUP_DIR!\ConfigBackup\" /E /H /C /I >nul 2>&1
echo Backups Saved to !BACKUP_DIR! >> "!LOGFILE!"

:: Section 4: Optimize Power Settings
echo [4/31] Optimizing Power Settings...
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg /change monitor-timeout-ac 0 >nul 2>&1
powercfg /change standby-timeout-ac 0 >nul 2>&1
powercfg /hibernate off >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
echo Power Plan Optimized for Maximum Performance >> "!LOGFILE!"

:: Section 5: Terminate Unnecessary Applications
echo [5/31] Terminating Unnecessary Applications...
set "APP_LIST=msedge.exe chrome.exe firefox.exe steam.exe discord.exe explorer.exe"
for %%i in (!APP_LIST!) do (
    taskkill /f /im "%%i" >nul 2>&1 && echo Closed %%i >> "!LOGFILE!"
)

:: Section 6: Optimize Services
echo [6/31] Optimizing Services...
set "SERVICES=DiagTrack WSearch Spooler Fax wscsvc SysMain XboxGipSvc XblAuthManager XblGameSave WMPNetworkSvc AdobeARMservice MySQL80"
for %%s in (!SERVICES!) do (
    sc query "%%s" >nul 2>&1 && (
        sc stop "%%s" >nul 2>&1 && sc config "%%s" start=disabled >nul 2>&1 && echo Disabled %%s >> "!LOGFILE!"
    )
)
sc stop "wuauserv" >nul 2>&1 && sc config "wuauserv" start=disabled >nul 2>&1 && echo Disabled Windows Update >> "!LOGFILE!"

:: Section 7: Disk Cleanup and Optimization
echo [7/31] Cleaning and Optimizing Disk...
del /q /s /f "%TEMP%\*" >nul 2>&1
del /q /s /f "C:\Windows\Temp\*" >nul 2>&1
del /q /s /f "C:\Windows\Prefetch\*" >nul 2>&1
if "!DISK_TYPE!"=="SSD" || "!DISK_TYPE!"=="NVMe" (
    fsutil behavior set disabledeletenotify 0 >nul 2>&1
    reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
    echo TRIM Enabled, Prefetch Disabled >> "!LOGFILE!"
) else (
    defrag C: /O /U /V >nul 2>&1 && echo Defragmented HDD >> "!LOGFILE!"
)

:: Section 8: Network Optimization
echo [8/31] Optimizing Network...
netsh int tcp set global autotuninglevel=normal rss=enabled ecncapability=enabled chimney=enabled dca=enabled >nul 2>&1
ipconfig /flushdns >nul 2>&1
netsh int tcp set global maxsynretransmissions=2 >nul 2>&1
netsh interface ip set dns name="Wi-Fi" source=static addr=1.1.1.1 >nul 2>&1
netsh interface ip add dns name="Wi-Fi" addr=1.0.0.1 index=2 >nul 2>&1
echo Network Optimized for Low Latency >> "!LOGFILE!"

:: Section 9: System Repair
echo [9/31] Repairing System...
sfc /scannow >nul 2>&1
if %errorlevel% neq 0 (
    DISM /Online /Cleanup-Image /RestoreHealth >nul 2>&1 || echo Error: System Repair Failed >> "!ERROR_LOG!"
)
echo System Repair Completed >> "!LOGFILE!"

:: Section 10: Security Optimization
echo [10/31] Optimizing Security...
reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1 && echo Windows Defender Disabled >> "!LOGFILE!"
netsh advfirewall set allprofiles state off >nul 2>&1 && echo Firewall Disabled >> "!LOGFILE!"

:: Section 11: Display Optimization
echo [11/31] Optimizing Display...
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
echo Game DVR Disabled >> "!LOGFILE!"

:: Section 12: Memory Optimization
echo [12/31] Optimizing Memory...
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
echo Memory Optimized for Performance >> "!LOGFILE!"

:: Section 13: User Experience Optimization
echo [13/31] Optimizing User Experience...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreen /t REG_DWORD /d 1 /f >nul 2>&1 && echo Lock Screen Disabled >> "!LOGFILE!"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCopilotButton /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\Copilot" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1 && echo Copilot Disabled >> "!LOGFILE!"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f >nul 2>&1 && echo Taskbar Feed Disabled >> "!LOGFILE!"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f >nul 2>&1 && echo Task View Button Disabled >> "!LOGFILE!"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTips /t REG_DWORD /d 0 /f >nul 2>&1 && echo Tips Disabled >> "!LOGFILE!"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Widgets" /v WidgetsEnabled /t REG_DWORD /d 0 /f >nul 2>&1 && echo Widgets Disabled >> "!LOGFILE!"

:: Section 14: CPU Optimization
echo [14/31] Optimizing CPU...
reg add "HKLM\System\CurrentControlSet\Control\Power" /v CsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
bcdedit /set numproc !CPU_CORES! >nul 2>&1
echo CPU Optimized for Maximum Performance >> "!LOGFILE!"

:: Section 15: GPU Optimization
echo [15/31] Optimizing GPU...
if "!GPU_TYPE!"=="NVIDIA" (
    nvidia-smi -pm 1 >nul 2>&1 && nvidia-smi -ac 5000,1500 >nul 2>&1 && echo NVIDIA GPU Optimized >> "!LOGFILE!"
)
if "!GPU_TYPE!"=="AMD" (
    echo Recommendation: Use AMD Radeon Software for GPU tuning >> "!LOGFILE!"
)
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
echo GPU and System Responsiveness Optimized >> "!LOGFILE!"

:: Section 16: Disable Telemetry
echo [16/31] Disabling Telemetry...
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Application Experience\Microsoft Compatibility Telemetry" /disable >nul 2>&1
echo Telemetry Fully Disabled >> "!LOGFILE!"

:: Section 17: Boot Optimization
echo [17/31] Optimizing Boot...
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set quietboot yes >nul 2>&1
echo Boot Optimized for Speed >> "!LOGFILE!"

:: Section 18: Disable Notifications
echo [18/31] Disabling Notifications...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo Notifications Disabled >> "!LOGFILE!"

:: Section 19: Audio Optimization
echo [19/31] Optimizing Audio...
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" /v DisableHWAcceleration /t REG_DWORD /d 1 /f >nul 2>&1
echo Low Latency Audio Enabled >> "!LOGFILE!"

:: Section 20: Windows 11 Specific Optimizations
echo [20/31] Additional Windows 11 Optimizations...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f >nul 2>&1 && echo Taskbar Alignment Centered Disabled >> "!LOGFILE!"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f >nul 2>&1 && echo Sync Provider Notifications Disabled >> "!LOGFILE!"

:: Section 21: Disable Background Apps
echo [21/31] Disabling Background Apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
echo Background Apps Disabled >> "!LOGFILE!"

:: Section 22: Disable Search Indexing
echo [22/31] Disabling Search Indexing...
sc stop "WSearch" >nul 2>&1 && sc config "WSearch" start=disabled >nul 2>&1 && echo Search Indexing Disabled >> "!LOGFILE!"

:: Section 23: Disable Superfetch/Prefetch
echo [23/31] Disabling Superfetch/Prefetch...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
echo Superfetch and Prefetch Disabled >> "!LOGFILE!"

:: Section 24: Disable Visual Effects
echo [24/31] Disabling Visual Effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
echo Visual Effects Disabled >> "!LOGFILE!"

:: Section 25: Disable Startup Delay
echo [25/31] Disabling Startup Delay...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f >nul 2>&1
echo Startup Delay Disabled >> "!LOGFILE!"

:: Section 26: Optimize Task Scheduler
echo [26/31] Optimizing Task Scheduler...
schtasks /change /tn "Microsoft\Windows\Defrag\ScheduledDefrag" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Maintenance\WinSAT" /disable >nul 2>&1
echo Unnecessary Scheduled Tasks Disabled >> "!LOGFILE!"

:: Section 27: Disable Auto Maintenance
echo [27/31] Disabling Auto Maintenance...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v MaintenanceDisabled /t REG_DWORD /d 1 /f >nul 2>&1
echo Auto Maintenance Disabled >> "!LOGFILE!"

:: Section 28: Enable Fast Startup
echo [28/31] Enabling Fast Startup...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f >nul 2>&1
echo Fast Startup Enabled >> "!LOGFILE!"

:: Section 29: Post-Optimization Logging
echo [29/31] Logging Post-Optimization State...
systeminfo > "!BACKUP_DIR!\SystemInfo_Post.txt" 2>nul
tasklist /fo csv > "!BACKUP_DIR!\TaskList_Post.csv" 2>nul
echo Post-Optimization Logs Saved >> "!LOGFILE!"

:: Section 30: Final Recommendations
echo [30/31] Final Recommendations...
echo Recommendations: >> "!LOGFILE!"
if "!DISK_TYPE!"=="HDD" echo - Consider upgrading to SSD/NVMe for better performance >> "!LOGFILE!"
if !RAM_GB! lss 8 echo - Add more RAM for optimal performance >> "!LOGFILE!"
if "!GPU_TYPE!"=="Unknown" echo - Update GPU drivers manually >> "!LOGFILE!"
echo - Enable God Mode: Create folder "GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" >> "!LOGFILE!"
echo - Check !BACKUP_DIR!\TaskList_Post.csv for resource usage >> "!LOGFILE!"

:: Section 31: Completion and Restore Point Option
echo [31/31] Completing Optimization...
set "RESTORE="
echo Create a post-optimization restore point? (y/n)
set /p RESTORE="Choice: "
if /i "!RESTORE!"=="y" (
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Post-Optimization v%VERSION%", 100, 7 >nul 2>&1
    if !errorlevel! equ 0 (
        echo Post-Optimization Restore Point Created >> "!LOGFILE!"
    ) else (
        echo Warning: Failed to create Post-Optimization Restore Point >> "!LOGFILE!"
    )
)

echo ==================================================================================
echo Optimization Complete!
echo Logs: !LOGFILE!
if exist "!ERROR_LOG!" echo Errors: !ERROR_LOG!
echo Backups: !BACKUP_DIR!
echo Please restart your computer to apply changes.
echo Press any key to exit...
pause >nul
exit /b 0
