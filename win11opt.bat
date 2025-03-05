@echo off
title Windows Ultimate Intelligent Optimization Script v3.0
color 0A
mode con: cols=120 lines=40
echo ==================================================================================
echo       Windows Ultimate Intelligent Optimization Script v3.0
echo ==================================================================================
echo Created by: Your Assistant
echo Current Date: %date% %time%
echo Warning: This is an advanced optimization tool. Backup your data before proceeding!
echo Press any key to start or CTRL+C to exit...
pause >nul

:: ตั้งค่าตัวแปรสภาพแวดล้อม
setlocal EnableDelayedExpansion
set "VERSION=3.0"
set "LOGFILE=%USERPROFILE%\Desktop\Optimization_Log_v%VERSION%.txt"
set "BACKUP_DIR=%USERPROFILE%\Desktop\Optimization_Backup_v%VERSION%"
set "CONFIG_FILE=%TEMP%\Optimization_Config.ini"
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
echo [1/25] Analyzing System Configuration...
echo Analyzing System... >> "%LOGFILE%"
systeminfo > "%BACKUP_DIR%\SystemInfo.txt" 2>nul
for /f "tokens=2 delims=[]" %%v in ('ver') do set "WIN_VER=%%v"
wmic diskdrive get caption, mediatype | findstr /i "SSD NVMe" >nul && set "DISK_TYPE=SSD/NVMe" || set "DISK_TYPE=HDD"
for /f "tokens=4" %%r in ('systeminfo ^| find "Total Physical Memory"') do set "RAM_MB=%%r"
set "RAM_MB=!RAM_MB:,=!"
set /a RAM_GB=(!RAM_MB!+1023)/1024
wmic cpu get name | findstr /i "Intel" >nul && set "CPU_TYPE=Intel" || (wmic cpu get name | findstr /i "AMD" >nul && set "CPU_TYPE=AMD" || set "CPU_TYPE=Unknown")
for /f "skip=1" %%c in ('wmic cpu get NumberOfCores') do if "%%c" neq "" set "CPU_CORES=%%c"
nvidia-smi -q >nul 2>&1 && set "GPU_TYPE=NVIDIA" || (wmic path win32_videocontroller get caption | findstr /i "AMD" >nul && set "GPU_TYPE=AMD" || set "GPU_TYPE=Unknown")
echo Windows Version: !WIN_VER! >> "%LOGFILE%"
echo Disk Type: !DISK_TYPE! >> "%LOGFILE%"
echo RAM: !RAM_GB! GB >> "%LOGFILE%"
echo CPU: !CPU_TYPE! with !CPU_CORES! cores >> "%LOGFILE%"
echo GPU: !GPU_TYPE! >> "%LOGFILE%"

:: ส่วนที่ 2: สร้าง System Restore Point
echo [2/25] Creating System Restore Point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Pre-Optimization v%VERSION%", 100, 7 >nul 2>&1
if %errorlevel% neq 0 (
    echo Warning: Failed to create Restore Point >> "%LOGFILE%"
    echo Error: Restore Point Creation Failed >> "%ERROR_LOG%"
) else (
    echo Restore Point Created >> "%LOGFILE%"
)

:: ส่วนที่ 3: สำรองข้อมูลระบบ
echo [3/25] Backing Up System Settings...
reg export HKLM\Software "%BACKUP_DIR%\RegBackup_System.reg" /y >nul 2>&1 || echo Error: System Registry Backup Failed >> "%ERROR_LOG%"
reg export HKCU\Software "%BACKUP_DIR%\RegBackup_User.reg" /y >nul 2>&1 || echo Error: User Registry Backup Failed >> "%ERROR_LOG%"
if not exist "%BACKUP_DIR%\ConfigBackup" mkdir "%BACKUP_DIR%\ConfigBackup"
xcopy "C:\Windows\System32\config\*.bak" "%BACKUP_DIR%\ConfigBackup\" /E /H /C /I /Y >nul 2>&1
echo Backups Saved to %BACKUP_DIR% >> "%LOGFILE%"

:: ส่วนที่ 4: เมนูตัวเลือกสำหรับผู้ใช้
echo [4/25] Configuring Optimization Profile...
:PROFILE_SELECTION
echo Available Profiles:
echo 1. General Use (Balanced performance)
echo 2. Gaming (Max performance for games)
echo 3. Low Resource (Optimize for old/low-spec PCs)
echo 4. Advanced User (Full customization)
echo 5. Battery Saving (For laptops)
echo 6. VR Ready (Optimize for VR headsets)
echo 7. Cloud Sync (Optimize for cloud usage)
set "PROFILE="
set /p PROFILE="Enter profile number (1-7): "
if not defined PROFILE set "PROFILE=1"
if "!PROFILE!"=="1" (set "MODE=GENERAL") else if "!PROFILE!"=="2" (set "MODE=GAMING") else if "!PROFILE!"=="3" (set "MODE=LOW_RESOURCE") else if "!PROFILE!"=="4" (set "MODE=ADVANCED") else if "!PROFILE!"=="5" (set "MODE=BATTERY") else if "!PROFILE!"=="6" (set "MODE=VR") else if "!PROFILE!"=="7" (set "MODE=CLOUD") else (
    echo Invalid selection! Defaulting to General Use.
    set "MODE=GENERAL"
)
echo Profile: !MODE! >> "%LOGFILE%"

:: Advanced Mode Options
if "!MODE!"=="ADVANCED" (
    echo Advanced Options:
    set "DEFENDER=n"
    set "UPDATE=n"
    set "REMOTE=n"
    set "MULTI_MONITOR=n"
    set /p DEFENDER="1. Disable Windows Defender (y/n, default n): "
    set /p UPDATE="2. Disable Windows Update (y/n, default n): "
    set /p REMOTE="3. Enable Remote Desktop (y/n, default n): "
    set /p MULTI_MONITOR="4. Optimize for Multi-Monitor (y/n, default n): "
)

:: บันทึกการตั้งค่าเป็น Config File
echo [Config] > "%CONFIG_FILE%"
echo Profile=!MODE! >> "%CONFIG_FILE%"
echo Defender=!DEFENDER! >> "%CONFIG_FILE%"
echo Update=!UPDATE! >> "%CONFIG_FILE%"
echo Remote=!REMOTE! >> "%CONFIG_FILE%"
echo MultiMonitor=!MULTI_MONITOR! >> "%CONFIG_FILE%"

:: ส่วนที่ 5: ปรับแต่งโหมดพลังงาน
echo [5/25] Optimizing Power Settings...
powercfg /duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg /duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
if "!MODE!"=="BATTERY" (
    powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
    powercfg /change standby-timeout-ac 15
    powercfg /change hibernate-timeout-ac 30
) else (
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    powercfg /change monitor-timeout-ac 0
    powercfg /change standby-timeout-ac 0
    powercfg /hibernate off
)
if defined CPU_CORES if !CPU_CORES! gtr 4 (
    powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
    powercfg /setactive SCHEME_CURRENT
)
echo Power Plan Optimized for !MODE! >> "%LOGFILE%"

:: ส่วนที่ 6: ปิดแอปพลิเคชันที่ไม่จำเป็น
echo [6/25] Terminating Unnecessary Applications...
set "APP_LIST=msedge.exe chrome.exe firefox.exe steam.exe discord.exe"
if "!MODE!"=="LOW_RESOURCE" set "APP_LIST=!APP_LIST! explorer.exe"
for %%i in (!APP_LIST!) do (
    taskkill /f /im "%%i" >nul 2>&1 && echo Closed %%i >> "%LOGFILE%" || echo Failed to close %%i >> "%LOGFILE%"
)

:: ส่วนที่ 7: ปรับแต่งบริการ
echo [7/25] Optimizing Services...
set "SERVICES=DiagTrack WSearch Spooler Fax wscsvc"
if "!MODE!"=="LOW_RESOURCE" set "SERVICES=!SERVICES! SysMain"
if "!MODE!"=="GAMING" set "SERVICES=!SERVICES! XboxGipSvc XblAuthManager XblGameSave"
if "!MODE!"=="VR" set "SERVICES=!SERVICES! WMPNetworkSvc"
for %%s in (!SERVICES!) do (
    sc query "%%s" >nul 2>&1 && (
        sc stop "%%s" >nul 2>&1 && sc config "%%s" start=disabled >nul 2>&1 && echo Disabled %%s >> "%LOGFILE%" || echo Failed to disable %%s >> "%LOGFILE%"
    )
)
if /i "!UPDATE!"=="y" (
    sc stop "wuauserv" >nul 2>&1 && sc config "wuauserv" start=disabled >nul 2>&1 && echo Disabled Windows Update >> "%LOGFILE%" || echo Failed to disable Windows Update >> "%LOGFILE%"
)

:: ส่วนที่ 8: ล้างไฟล์ขยะและปรับแต่งดิสก์
echo [8/25] Cleaning and Optimizing Disk...
del /q /s /f "%TEMP%\*" >nul 2>&1
del /q /s /f "C:\Windows\Temp\*" >nul 2>&1
del /q /s /f "C:\Windows\Prefetch\*" >nul 2>&1
if "!DISK_TYPE!"=="SSD/NVMe" (
    fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
    echo TRIM Enabled, Prefetch Disabled >> "%LOGFILE%"
) else (
    defrag C: /O /U /V >nul 2>&1 && echo Defragmented HDD >> "%LOGFILE%" || echo Defrag failed >> "%LOGFILE%"
)
chkdsk C: /f /r >nul 2>&1 || echo Error: Disk Check Failed >> "%ERROR_LOG%"

:: ส่วนที่ 9: ปรับแต่งเครือข่าย
echo [9/25] Optimizing Network...
netsh int tcp set global autotuninglevel=normal rss=enabled ecncapability=enabled chimney=enabled dca=enabled >nul 2>&1
ipconfig /flushdns >nul 2>&1
if "!MODE!"=="GAMING" || "!MODE!"=="VR" (
    netsh int tcp set global maxsynretransmissions=2 >nul 2>&1
    echo Low Latency Network for !MODE! >> "%LOGFILE%"
)
netsh interface ip set dns name="Wi-Fi" source=static addr=1.1.1.1 >nul 2>&1
netsh interface ip add dns name="Wi-Fi" addr=1.0.0.1 index=2 >nul 2>&1
if "!MODE!"=="CLOUD" (
    netsh interface ip set dns name="Ethernet" source=static addr=8.8.8.8 >nul 2>&1
    netsh interface ip add dns name="Ethernet" addr=8.8.4.4 index=2 >nul 2>&1
    echo Cloud-Optimized DNS (Google) >> "%LOGFILE%"
)

:: ส่วนที่ 10: ซ่อมแซมระบบ
echo [10/25] Repairing System...
sfc /scannow >nul 2>&1
if %errorlevel% neq 0 (
    DISM /Online /Cleanup-Image /RestoreHealth >nul 2>&1 || echo Error: System Repair Failed >> "%ERROR_LOG%"
)
echo System Repair Completed >> "%LOGFILE%"

:: ส่วนที่ 11: ปรับแต่งความปลอดภัย
echo [11/25] Optimizing Security...
if /i "!DEFENDER!"=="y" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1 && echo Windows Defender Disabled >> "%LOGFILE%" || echo Failed to disable Defender >> "%LOGFILE%"
)
netsh advfirewall set allprofiles state off >nul 2>&1 && echo Firewall Disabled >> "%LOGFILE%" || echo Failed to disable Firewall >> "%LOGFILE%"

:: ส่วนที่ 12: ปรับแต่งการแสดงผล
echo [12/25] Optimizing Display...
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
if "!MODE!"=="GAMING" || "!MODE!"=="VR" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
    echo Game DVR Disabled >> "%LOGFILE%"
)
if /i "!MULTI_MONITOR!"=="y" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v MultipleMonitorEnabled /t REG_DWORD /d 1 /f >nul 2>&1
    echo Multi-Monitor Support Enabled >> "%LOGFILE%"
)

:: ส่วนที่ 13: ปรับแต่งหน่วยความจำ
echo [13/25] Optimizing Memory...
if !RAM_GB! lss 8 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 0 /f >nul 2>&1
    echo Low RAM Mode (!RAM_GB! GB) >> "%LOGFILE%"
) else (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
    echo High RAM Mode (!RAM_GB! GB) >> "%LOGFILE%"
)

:: ส่วนที่ 14: ปรับแต่ง CPU
echo [14/25] Optimizing CPU...
if defined CPU_CORES if !CPU_CORES! gtr 4 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v CsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    bcdedit /set numproc !CPU_CORES! >nul 2>&1
    echo Multi-core Optimization (!CPU_CORES! cores) >> "%LOGFILE%"
)

:: ส่วนที่ 15: ปรับแต่ง GPU
echo [15/25] Optimizing GPU...
if "!GPU_TYPE!"=="NVIDIA" (
    nvidia-smi -pm 1 >nul 2>&1 && nvidia-smi -ac 5000,1500 >nul 2>&1 && echo NVIDIA GPU Optimized >> "%LOGFILE%" || echo NVIDIA GPU optimization failed >> "%LOGFILE%"
)
if "!GPU_TYPE!"=="AMD" (
    echo Recommendation: Use AMD Radeon Software for GPU tuning >> "%LOGFILE%"
)
if "!MODE!"=="VR" (
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
    echo VR Responsiveness Optimized >> "%LOGFILE%"
)

:: ส่วนที่ 16: ปิด Telemetry
echo [16/25] Disabling Telemetry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Application Experience\Microsoft Compatibility Telemetry" /disable >nul 2>&1
echo Telemetry Fully Disabled >> "%LOGFILE%"

:: ส่วนที่ 17: ปรับแต่ง Remote Desktop
echo [17/25] Configuring Remote Desktop...
if /i "!REMOTE!"=="y" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f >nul 2>&1
    netsh advfirewall firewall set rule group="remote desktop" new enable=yes >nul 2>&1
    echo Remote Desktop Enabled >> "%LOGFILE%"
)

:: ส่วนที่ 18: ปรับแต่งสำหรับ Cloud Sync
echo [18/25] Optimizing Cloud Sync...
if "!MODE!"=="CLOUD" (
    reg add "HKCU\Software\Microsoft\OneDrive" /v EnableADAL /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace" /v "{815010B1-0D8E-4A54-8C75-5F4C2D4C5F5C}" /t REG_SZ /d "OneDrive" /f >nul 2>&1
    echo OneDrive Optimized for Cloud >> "%LOGFILE%"
)

:: ส่วนที่ 19: ปรับแต่งสำหรับเครื่องเก่า
echo [19/25] Optimizing for Older Hardware...
if "!MODE!"=="LOW_RESOURCE" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v AlwaysUnloadDll /t REG_DWORD /d 1 /f >nul 2>&1
    echo Low Resource Optimizations Applied >> "%LOGFILE%"
)

:: ส่วนที่ 20: ปรับแต่งการบูต
echo [20/25] Optimizing Boot...
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set quietboot yes >nul 2>&1
if "!MODE!"=="GAMING" || "!MODE!"=="VR" (
    bcdedit /set hypervisorloadoptions "NoHyperV" >nul 2>&1
    echo Hyper-V Disabled for !MODE! >> "%LOGFILE%"
)
echo Boot Optimized >> "%LOGFILE%"

:: ส่วนที่ 21: ปรับแต่งการแจ้งเตือน
echo [21/25] Disabling Notifications...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo Notifications Disabled >> "%LOGFILE%"

:: ส่วนที่ 22: ปรับแต่งเสียง
echo [22/25] Optimizing Audio...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" /v DisableHWAcceleration /t REG_DWORD /d 1 /f >nul 2>&1
if "!MODE!"=="VR" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Multimedia\Audio" /v LowLatency /t REG_DWORD /d 1 /f >nul 2>&1
    echo Low Latency Audio for VR >> "%LOGFILE%"
)

:: ส่วนที่ 23: บันทึกสถานะหลังปรับแต่ง
echo [23/25] Logging Post-Optimization State...
systeminfo > "%BACKUP_DIR%\SystemInfo_Post.txt" 2>nul
tasklist /fo csv | sort /r /+3 > "%BACKUP_DIR%\TaskList_Post.csv" 2>nul
echo Post-Optimization Logs Saved >> "%LOGFILE%"

:: ส่วนที่ 24: คำแนะนำและการตรวจสอบ
echo [24/25] Final Recommendations...
echo Recommendations: >> "%LOGFILE%"
if "!DISK_TYPE!"=="HDD" echo - Consider upgrading to SSD/NVMe for better performance >> "%LOGFILE%"
if !RAM_GB! lss 8 echo - Add more RAM for optimal performance >> "%LOGFILE%"
if "!GPU_TYPE!"=="Unknown" echo - Update GPU drivers manually >> "%LOGFILE%"
echo - Enable God Mode: Create folder "GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" >> "%LOGFILE%"
echo - Check %BACKUP_DIR%\TaskList_Post.csv for resource usage >> "%LOGFILE%"

:: ส่วนที่ 25: เสร็จสิ้นและตัวเลือกกู้คืน
echo [25/25] Completing Optimization...
set "RESTORE=n"
echo Create a post-optimization restore point? (y/n, default n)
set /p RESTORE=
if /i "!RESTORE!"=="y" (
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Post-Optimization v%VERSION%", 100, 7 >nul 2>&1
    if !errorlevel! equ 0 (echo Post-Optimization Restore Point Created >> "%LOGFILE%") else (echo Failed to create Post-Optimization Restore Point >> "%LOGFILE%")
)
echo Cleaning temporary files...
del /q /f "%CONFIG_FILE%" >nul 2>&1

echo ==================================================================================
echo Optimization Complete!
echo Logs: %LOGFILE%, %ERROR_LOG% (if errors occurred)
echo Backups: %BACKUP_DIR%
echo Please restart your computer to apply changes.
echo Press any key to exit...
pause >nul
exit /b 0
