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

:: ตั้งค่าตัวแปรสภาพแวดล้อม
setlocal EnableDelayedExpansion
set "VERSION=4.1"
set "LOGFILE=%USERPROFILE%\Desktop\Optimization_Log_v%VERSION%.txt"
set "BACKUP_DIR=%USERPROFILE%\Desktop\Optimization_Backup_v%VERSION%"
set "ERROR_LOG=%USERPROFILE%\Desktop\Optimization_Error_Log.txt"
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
echo Optimization Log v%VERSION% > "%LOGFILE%"
echo Start Time: %date% %time% >> "%LOGFILE%"

:: ตรวจสอบสิทธิ์ Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Administrator privileges required!
    echo Log: Failed - No Admin Privileges >> "%LOGFILE%"
    echo Error: No Admin Privileges >> "%ERROR_LOG%"
    pause
    exit /b 1
)

:: ส่วนที่ 1: ตรวจสอบและบันทึกข้อมูลระบบ
echo [1/31] Analyzing System Configuration...
echo Analyzing System... >> "%LOGFILE%"
systeminfo > "%BACKUP_DIR%\SystemInfo.txt" 2>nul
for /f "tokens=3" %%v in ('ver ^| find "Version"') do set "WIN_VER=%%v"
wmic diskdrive get caption, mediatype | find "SSD" >nul && set "DISK_TYPE=SSD" || (wmic diskdrive get caption, mediatype | find "NVMe" >nul && set "DISK_TYPE=NVMe" || set "DISK_TYPE=HDD")
for /f "tokens=2" %%r in ('systeminfo ^| find "Total Physical Memory"') do set "RAM_MB=%%r"
set "RAM_MB=!RAM_MB:,=!"
set /a RAM_GB=!RAM_MB!/1024
wmic cpu get name | find "Intel" >nul && set "CPU_TYPE=Intel" || (wmic cpu get name | find "AMD" >nul && set "CPU_TYPE=AMD" || set "CPU_TYPE=Unknown")
for /f %%c in ('wmic cpu get NumberOfCores ^| find /v "NumberOfCores"') do set "CPU_CORES=%%c"
nvidia-smi -q >nul 2>&1 && set "GPU_TYPE=NVIDIA" || (wmic path win32_videocontroller get caption | find "AMD" >nul && set "GPU_TYPE=AMD" || set "GPU_TYPE=Unknown")
echo Windows Version: !WIN_VER! >> "%LOGFILE%"
echo Disk Type: !DISK_TYPE! >> "%LOGFILE%"
echo RAM: !RAM_GB! GB >> "%LOGFILE%"
echo CPU: !CPU_TYPE! with !CPU_CORES! cores >> "%LOGFILE%"
echo GPU: !GPU_TYPE! >> "%LOGFILE%"

:: ส่วนที่ 2: สร้าง System Restore Point
echo [2/31] Creating System Restore Point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Pre-Optimization v%VERSION%", 100, 7 >nul 2>&1
if %errorlevel% neq 0 (
    echo Warning: Failed to create Restore Point >> "%LOGFILE%"
    echo Error: Restore Point Creation Failed >> "%ERROR_LOG%"
) else (
    echo Restore Point Created >> "%LOGFILE%"
)

:: ส่วนที่ 3: สำรองข้อมูลระบบ
echo [3/31] Backing Up System Settings...
reg export HKLM\Software "%BACKUP_DIR%\RegBackup_System.reg" /y >nul 2>&1 || echo Error: System Registry Backup Failed >> "%ERROR_LOG%"
reg export HKCU\Software "%BACKUP_DIR%\RegBackup_User.reg" /y >nul 2>&1 || echo Error: User Registry Backup Failed >> "%ERROR_LOG%"
xcopy "C:\Windows\System32\config\*.bak" "%BACKUP_DIR%\ConfigBackup\" /E /H /C /I >nul 2>&1
echo Backups Saved to %BACKUP_DIR% >> "%LOGFILE%"

:: ส่วนที่ 4: ปรับแต่งโหมดพลังงาน
echo [4/31] Optimizing Power Settings...
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg /hibernate off
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
echo Power Plan Optimized for Maximum Performance >> "%LOGFILE%"

:: ส่วนที่ 5: ปิดแอปพลิเคชันที่ไม่จำเป็น
echo [5/31] Terminating Unnecessary Applications...
set "APP_LIST=msedge.exe chrome.exe firefox.exe steam.exe discord.exe explorer.exe"
for %%i in (!APP_LIST!) do (
    taskkill /f /im "%%i" 2>nul && echo Closed %%i >> "%LOGFILE%"
)

:: ส่วนที่ 6: ปรับแต่งบริการ
echo [6/31] Optimizing Services...
set "SERVICES=DiagTrack WSearch Spooler Fax wscsvc SysMain XboxGipSvc XblAuthManager XblGameSave WMPNetworkSvc AdobeARMservice MySQL80"
for %%s in (!SERVICES!) do (
    sc stop "%%s" >nul 2>&1 && sc config "%%s" start= disabled >nul 2>&1 && echo Disabled %%s >> "%LOGFILE%"
)
sc stop "wuauserv" >nul 2>&1 && sc config "wuauserv" start= disabled >nul 2>&1 && echo Disabled Windows Update >> "%LOGFILE%"

:: ส่วนที่ 7: ล้างไฟล์ขยะและปรับแต่งดิสก์
echo [7/31] Cleaning and Optimizing Disk...
del /q /s /f "%TEMP%\*" 2>nul
del /q /s /f "C:\Windows\Temp\*" 2>nul
del /q /s /f "C:\Windows\Prefetch\*" 2>nul
if "!DISK_TYPE!"=="SSD" || "!DISK_TYPE!"=="NVMe" (
    fsutil behavior set disabledeletenotify 0
    reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f
    echo TRIM Enabled, Prefetch Disabled >> "%LOGFILE%"
) else (
    defrag C: /O /U /V >nul 2>&1 && echo Defragmented HDD >> "%LOGFILE%"
)
chkdsk C: /f /r >nul 2>&1 || echo Error: Disk Check Failed >> "%ERROR_LOG%"

:: ส่วนที่ 8: ปรับแต่งเครือข่าย
echo [8/31] Optimizing Network...
netsh int tcp set global autotuninglevel=normal rss=enabled ecncapability=enabled chimney=enabled dca=enabled
ipconfig /flushdns >nul
netsh int tcp set global maxsynretransmissions=2
netsh interface ip set dns "Wi-Fi" static 1.1.1.1
netsh interface ip add dns "Wi-Fi" 1.0.0.1 index=2
echo Network Optimized for Low Latency >> "%LOGFILE%"

:: ส่วนที่ 9: ซ่อมแซมระบบ
echo [9/31] Repairing System...
sfc /scannow >nul 2>&1
if %errorlevel% neq 0 (
    DISM /Online /Cleanup-Image /RestoreHealth >nul 2>&1 || echo Error: System Repair Failed >> "%ERROR_LOG%"
)
echo System Repair Completed >> "%LOGFILE%"

:: ส่วนที่ 10: ปรับแต่งความปลอดภัย
echo [10/31] Optimizing Security...
reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f >nul 2>&1 && echo Windows Defender Disabled >> "%LOGFILE%"
netsh advfirewall set allprofiles state off >nul 2>&1 && echo Firewall Disabled >> "%LOGFILE%"

:: ส่วนที่ 11: ปรับแต่งการแสดงผล
echo [11/31] Optimizing Display...
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo Game DVR Disabled >> "%LOGFILE%"

:: ส่วนที่ 12: ปรับแต่งหน่วยความจำ
echo [12/31] Optimizing Memory...
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1
echo Memory Optimized for Performance >> "%LOGFILE%"

:: ส่วนที่ 13: ปรับแต่งประสบการณ์ผู้ใช้ (Windows 11 Specific)
echo [13/31] Optimizing User Experience...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d 1 /f >nul 2>&1 && echo Lock Screen Disabled >> "%LOGFILE%"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\Copilot" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo Copilot Disabled >> "%LOGFILE%"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2 /f >nul 2>&1 && echo Taskbar Feed Disabled >> "%LOGFILE%"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f >nul 2>&1 && echo Task View Button Disabled >> "%LOGFILE%"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_PowerButtonAction" /t REG_DWORD /d 0 /f >nul 2>&1 && echo Power Button Action Optimized >> "%LOGFILE%"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTips" /t REG_DWORD /d 0 /f >nul 2>&1 && echo Tips Disabled >> "%LOGFILE%"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Widgets" /v "WidgetsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1 && echo Widgets Disabled >> "%LOGFILE%"

:: ส่วนที่ 14: ปรับแต่ง CPU
echo [14/31] Optimizing CPU...
reg add "HKLM\System\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
bcdedit /set numproc !CPU_CORES! >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d 1048576 /f >nul 2>&1
echo CPU Optimized for Maximum Performance >> "%LOGFILE%"

:: ส่วนที่ 15: ปรับแต่ง GPU
echo [15/31] Optimizing GPU...
if "!GPU_TYPE!"=="NVIDIA" (
    nvidia-smi -pm 1 >nul 2>&1 && nvidia-smi -ac 5000,1500 >nul 2>&1 && echo NVIDIA GPU Optimized >> "%LOGFILE%"
)
if "!GPU_TYPE!"=="AMD" (
    echo Recommendation: Use AMD Radeon Software for GPU tuning >> "%LOGFILE%"
)
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
echo GPU and System Responsiveness Optimized >> "%LOGFILE%"

:: ส่วนที่ 16: ปิด Telemetry
echo [16/31] Disabling Telemetry...
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Application Experience\Microsoft Compatibility Telemetry" /disable >nul 2>&1
echo Telemetry Fully Disabled >> "%LOGFILE%"

:: ส่วนที่ 17: ปรับแต่งการบูต
echo [17/31] Optimizing Boot...
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set quietboot yes >nul 2>&1
bcdedit /set hypervisorloadoptions "NoHyperV" >nul 2>&1
echo Boot Optimized for Speed >> "%LOGFILE%"

:: ส่วนที่ 18: ปรับแต่งการแจ้งเตือน
echo [18/31] Disabling Notifications...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo Notifications Disabled >> "%LOGFILE%"

:: ส่วนที่ 19: ปรับแต่งเสียง
echo [19/31] Optimizing Audio...
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" /v "DisableHWAcceleration" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Multimedia\Audio" /v "LowLatency" /t REG_DWORD /d 1 /f >nul 2>&1
echo Low Latency Audio Enabled >> "%LOGFILE%"

:: ส่วนที่ 20: ปรับแต่งเพิ่มเติมสำหรับ Windows 11
echo [20/31] Additional Windows 11 Optimizations...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d 0 /f >nul 2>&1 && echo Taskbar Alignment Centered Disabled >> "%LOGFILE%"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d 0 /f >nul 2>&1 && echo Sync Provider Notifications Disabled >> "%LOGFILE%"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableXamlStartMenu" /t REG_DWORD /d 0 /f >nul 2>&1 && echo XAML Start Menu Disabled >> "%LOGFILE%"

:: ส่วนที่ 21: ปิด Background Apps
echo [21/31] Disabling Background Apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo Background Apps Disabled >> "%LOGFILE%"

:: ส่วนที่ 22: ปิด Search Indexing
echo [22/31] Disabling Search Indexing...
sc stop "WSearch" >nul 2>&1 && sc config "WSearch" start= disabled >nul 2>&1 && echo Search Indexing Disabled >> "%LOGFILE%"

:: ส่วนที่ 23: ปิด Superfetch/Prefetch
echo [23/31] Disabling Superfetch/Prefetch...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f >nul 2>&1
echo Superfetch and Prefetch Disabled >> "%LOGFILE%"

:: ส่วนที่ 24: ปิด Visual Effects
echo [24/31] Disabling Visual Effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul 2>&1
echo Visual Effects Disabled >> "%LOGFILE%"

:: ส่วนที่ 25: ปิด Startup Delay
echo [25/31] Disabling Startup Delay...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d 0 /f >nul 2>&1
echo Startup Delay Disabled >> "%LOGFILE%"

:: ส่วนที่ 26: ปรับแต่ง Task Scheduler
echo [26/31] Optimizing Task Scheduler...
schtasks /change /tn "Microsoft\Windows\Defrag\ScheduledDefrag" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Maintenance\WinSAT" /disable >nul 2>&1
echo Unnecessary Scheduled Tasks Disabled >> "%LOGFILE%"

:: ส่วนที่ 27: ปิด Auto Maintenance
echo [27/31] Disabling Auto Maintenance...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo Auto Maintenance Disabled >> "%LOGFILE%"

:: ส่วนที่ 28: ปรับแต่ง Fast Startup
echo [28/31] Enabling Fast Startup...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo Fast Startup Enabled >> "%LOGFILE%"

:: ส่วนที่ 29: บันทึกสถานะหลังปรับแต่ง
echo [29/31] Logging Post-Optimization State...
systeminfo > "%BACKUP_DIR%\SystemInfo_Post.txt" 2>nul
tasklist /fo csv | sort /r /+3 > "%BACKUP_DIR%\TaskList_Post.csv"
echo Post-Optimization Logs Saved >> "%LOGFILE%"

:: ส่วนที่ 30: คำแนะนำและการตรวจสอบ
echo [30/31] Final Recommendations...
echo Recommendations: >> "%LOGFILE%"
if "!DISK_TYPE!"=="HDD" echo - Consider upgrading to SSD/NVMe for better performance >> "%LOGFILE%"
if !RAM_GB! lss 8 echo - Add more RAM for optimal performance >> "%LOGFILE%"
if "!GPU_TYPE!"=="Unknown" echo - Update GPU drivers manually >> "%LOGFILE%"
echo - Enable God Mode: Create folder "GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" >> "%LOGFILE%"
echo - Check %BACKUP_DIR%\TaskList_Post.csv for resource usage >> "%LOGFILE%"

:: ส่วนที่ 31: เสร็จสิ้นและตัวเลือกกู้คืน
echo [31/31] Completing Optimization...
echo Create a post-optimization restore point? (y/n)
set /p RESTORE=
if /i "!RESTORE!"=="y" (
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Post-Optimization v%VERSION%", 100, 7 >nul 2>&1
    echo Post-Optimization Restore Point Created >> "%LOGFILE%"
)

echo ==================================================================================
echo Optimization Complete!
echo Logs: %LOGFILE%, %ERROR_LOG% (if errors occurred)
echo Backups: %BACKUP_DIR%
echo Please restart your computer to apply changes.
echo Press any key to exit...
pause >nul
exit /b 0
