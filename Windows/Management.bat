@echo off
:menu
cls
echo ==================================================
echo Please select an option:
echo ==================================================
echo 1. Disable animations and improve display performance
echo 2. Disable Windows Defender
echo 3. Enable Windows Defender
echo 4. Disable unnecessary features
echo 5. Optimize CPU performance
echo 6. Optimize Internet performance
echo 7. Configure Windows Update
echo 8. Enable Auto-login
echo 9. Clear Cache
echo 10. Optimize Disk
echo 11. Check and Repair System Files
echo 12. Activate Windows 10-11
echo 13. Exit
echo ==================================================
set /p choice=Please select an option (1-13): 

if %choice%==1 goto optimize_display
if %choice%==2 goto disable_defender
if %choice%==3 goto enable_defender
if %choice%==4 goto disable_features
if %choice%==5 goto optimize_cpu
if %choice%==6 goto optimize_internet
if %choice%==7 goto windows_update
if %choice%==8 goto auto_login
if %choice%==9 goto clear_cache
if %choice%==10 goto optimize_disk
if %choice%==11 goto check_repair
if %choice%==12 goto windows_activate
if %choice%==13 goto endexit
goto menu


:windows_activate
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /B
)

:: Run your PowerShell command
powershell -Command "Invoke-RestMethod 'https://raw.githubusercontent.com/gotza02/gotza02/main/Windows/activate' | Invoke-Expression"

pause
goto menu

:optimize_display
rem Disable animations and improve display performance
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 90120180 /f
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f
echo Disabled animations and improved display performance.
pause
goto menu

:disable_defender
rem Disable Windows Defender and Real-Time Protection
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SpynetReporting /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 2 /f
echo Disabled Windows Defender.
pause
goto menu

:enable_defender
rem Enable Windows Defender and Real-Time Protection
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SpynetReporting /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 1 /f
echo Enabled Windows Defender.
pause
goto menu

:disable_features
rem Disable unnecessary features
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f
echo Disabled unnecessary features.
pause
goto menu

:optimize_cpu
echo Optimizing CPU performance...

REM Disable power throttling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f
if %errorlevel% neq 0 echo Failed to disable power throttling. & goto :error

REM Set priority to programs over background services
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f
if %errorlevel% neq 0 echo Failed to set priority control. & goto :error

REM Disable CPU core parking
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
powercfg -setactive scheme_current
if %errorlevel% neq 0 echo Failed to disable CPU core parking. & goto :error

REM Set high performance power plan
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
if %errorlevel% neq 0 echo Failed to set high performance power plan. & goto :error

REM Disable dynamic tick
bcdedit /set disabledynamictick yes
if %errorlevel% neq 0 echo Failed to disable dynamic tick. & goto :error

REM Clear CPU instruction cache
wmic cpu get loadpercentage >nul

echo CPU optimization completed successfully.
goto :end

:error
echo An error occurred during optimization.
pause
exit /b 1

:end
echo Press any key to exit...
pause >nul
goto menu

@echo off
setlocal enabledelayedexpansion

:optimize_internet
echo Optimizing Internet performance...

REM TCP/IP Optimization
set "tcp_path=HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
reg add "%tcp_path%" /v "TcpNoDelay" /t REG_DWORD /d 1 /f
reg add "%tcp_path%" /v "TCPDelAckTicks" /t REG_DWORD /d 0 /f
reg add "%tcp_path%" /v "DefaultTTL" /t REG_DWORD /d 64 /f
reg add "%tcp_path%" /v "Tcp1323Opts" /t REG_DWORD /d 1 /f
reg add "%tcp_path%" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f
reg add "%tcp_path%" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d 65535 /f
reg add "%tcp_path%" /v "TcpWindowSize" /t REG_DWORD /d 65535 /f
reg add "%tcp_path%" /v "MaxUserPort" /t REG_DWORD /d 65534 /f
if %errorlevel% neq 0 echo Failed to optimize TCP/IP settings. & goto :error

REM Network Throttling Index
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 0xffffffff /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f
if %errorlevel% neq 0 echo Failed to set Network Throttling Index. & goto :error

REM Disable Windows Telemetry and Activity Feed
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d 0 /f
if %errorlevel% neq 0 echo Failed to disable Windows Telemetry and Activity Feed. & goto :error

REM Disable Content Delivery
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f
if %errorlevel% neq 0 echo Failed to disable Content Delivery. & goto :error

REM Clear DNS Cache
ipconfig /flushdns
if %errorlevel% neq 0 echo Failed to clear DNS cache. & goto :error

REM Reset Winsock catalog
netsh winsock reset
if %errorlevel% neq 0 echo Failed to reset Winsock catalog. & goto :error

REM Disable IPv6 (optional, uncomment if needed)
REM netsh interface ipv6 set state disabled
REM if %errorlevel% neq 0 echo Failed to disable IPv6. & goto :error

REM Set DNS servers to Google's public DNS (optional, uncomment if needed)
REM netsh interface ipv4 set dns name="Ethernet" static 8.8.8.8 primary
REM netsh interface ipv4 add dns name="Ethernet" 8.8.4.4 index=2
REM if %errorlevel% neq 0 echo Failed to set DNS servers. & goto :error

echo Internet optimization completed successfully.
goto :end

:error
echo An error occurred during optimization.
pause
exit /b 1

:end
echo Press any key to return to menu...
pause >nul
goto :menu

:windows_update
echo ================================
echo       Windows Update Menu
echo ================================
echo 1. Enable Windows Update
echo 2. Disable Windows Update
echo ================================
set /p choice=Please enter your choice (1 or 2): 

if %choice%==1 goto :enable_windows_update
if %choice%==2 goto :disable_windows_update
goto :menu

:enable_windows_update
echo Configuring Windows Update...

REM Set Windows Update to automatically download and install updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 4 /f
if %errorlevel% neq 0 echo Failed to set automatic update option. & goto :update_error

REM Set updates to install every day
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v ScheduledInstallDay /t REG_DWORD /d 0 /f
if %errorlevel% neq 0 echo Failed to set update schedule day. & goto :update_error

REM Set updates to install at 3 AM
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v ScheduledInstallTime /t REG_DWORD /d 3 /f
if %errorlevel% neq 0 echo Failed to set update schedule time. & goto :update_error

REM Include driver updates in Windows Update
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 0 /f
if %errorlevel% neq 0 echo Failed to include driver updates. & goto :update_error

REM Enable automatic driver updates
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v SearchOrderConfig /t REG_DWORD /d 1 /f
if %errorlevel% neq 0 echo Failed to enable automatic driver updates. & goto :update_error

REM Disable auto-restart after updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f
if %errorlevel% neq 0 echo Failed to disable auto-restart after updates. & goto :update_error

REM Enable automatic update of other Microsoft products
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AllowMUUpdateService /t REG_DWORD /d 1 /f
if %errorlevel% neq 0 echo Failed to enable update of other Microsoft products. & goto :update_error

REM Disable delivery optimization
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f
if %errorlevel% neq 0 echo Failed to disable delivery optimization. & goto :update_error

REM Force Windows Update to immediately check for updates
echo Checking for Windows updates...
wuauclt /detectnow
wuauclt /updatenow

echo Windows Update configuration completed successfully.
goto :update_end

:disable_windows_update
echo Disabling Windows Update...

REM Disable Windows Update service
sc config wuauserv start= disabled
if %errorlevel% neq 0 echo Failed to disable Windows Update service. & goto :update_error

sc stop wuauserv
if %errorlevel% neq 0 echo Failed to stop Windows Update service. & goto :update_error

REM Disable Windows Update service dependencies
sc config bits start= disabled
if %errorlevel% neq 0 echo Failed to disable Background Intelligent Transfer Service. & goto :update_error

sc stop bits
if %errorlevel% neq 0 echo Failed to stop Background Intelligent Transfer Service. & goto :update_error

sc config dosvc start= disabled
if %errorlevel% neq 0 echo Failed to disable Delivery Optimization Service. & goto :update_error

sc stop dosvc
if %errorlevel% neq 0 echo Failed to stop Delivery Optimization Service. & goto :update_error

REM Disable automatic updates in registry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f
if %errorlevel% neq 0 echo Failed to disable automatic updates. & goto :update_error

REM Disable delivery optimization
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f
if %errorlevel% neq 0 echo Failed to disable delivery optimization. & goto :update_error

REM Prevent Windows from automatically restarting after updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f
if %errorlevel% neq 0 echo Failed to disable auto-restart after updates. & goto :update_error

echo Windows Update has been disabled.
goto :update_end

:update_error
echo An error occurred during Windows Update configuration.
pause
exit /b 1

:update_end
echo Press any key to return to menu...
pause >nul
goto :menu

:auto_login
set /p username=Enter the username for auto-login: 
set /p password=Enter the password for auto-login (leave blank if none): 
rem Enable Auto-login
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d %username% /f
if not "%password%"=="" reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d %password% /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 3 /f
echo Enabled Auto-login.
pause
goto menu

@echo off
setlocal enabledelayedexpansion

:clear_cache
echo Clearing system cache...

REM Clear Windows Temp folder
del /q /f /s "%WINDIR%\Temp\*.*"
if %errorlevel% neq 0 echo Failed to clear Windows Temp folder. & goto :cache_error

REM Clear User Temp folder
del /q /f /s "%TEMP%\*.*"
if %errorlevel% neq 0 echo Failed to clear User Temp folder. & goto :cache_error

REM Clear Prefetch folder
del /q /f /s "%WINDIR%\Prefetch\*.*"
if %errorlevel% neq 0 echo Failed to clear Prefetch folder. & goto :cache_error

REM Clear Windows Update Cache
net stop wuauserv
rmdir /s /q C:\Windows\SoftwareDistribution
mkdir C:\Windows\SoftwareDistribution
net start wuauserv
if %errorlevel% neq 0 echo Failed to clear Windows Update Cache. & goto :cache_error

REM Clear DNS Cache
ipconfig /flushdns
if %errorlevel% neq 0 echo Failed to clear DNS Cache. & goto :cache_error

REM Clear ARP Cache
netsh interface ip delete arpcache
if %errorlevel% neq 0 echo Failed to clear ARP Cache. & goto :cache_error

REM Clear Font Cache
net stop FontCache
del /f /s /q "%WinDir%\ServiceProfiles\LocalService\AppData\Local\FontCache\*.*"
net start FontCache
if %errorlevel% neq 0 echo Failed to clear Font Cache. & goto :cache_error

echo Cache clearing completed successfully.
goto :cache_end

:cache_error
echo An error occurred while clearing cache.
pause
exit /b 1

:cache_end
echo Press any key to return to menu...
pause >nul
goto :menu

:optimize_disk
echo Optimizing disk...

REM Check disk for errors
echo Checking disk for errors...
chkdsk C: /f /r /x
if %errorlevel% neq 0 echo Failed to check disk for errors. & goto :disk_error

REM Clean up system files
echo Cleaning up system files...
cleanmgr /sagerun:1
if %errorlevel% neq 0 echo Failed to clean up system files. & goto :disk_error

REM Optimize drives
echo Optimizing drives...
defrag C: /O /U /V
if %errorlevel% neq 0 echo Failed to optimize drives. & goto :disk_error

REM Disable Hibernation to free up disk space (optional, uncomment if needed)
REM powercfg /h off
REM if %errorlevel% neq 0 echo Failed to disable Hibernation. & goto :disk_error

REM Compact OS (only for Windows 10 and later, uncomment if needed)
REM Compact.exe /CompactOS:always
REM if %errorlevel% neq 0 echo Failed to compact OS. & goto :disk_error

echo Disk optimization completed successfully.
goto :disk_end

:disk_error
echo An error occurred during disk optimization.
pause
exit /b 1

:disk_end
echo Press any key to return to menu...
pause >nul
goto :menu

:check_repair
echo Checking and repairing system files...

REM Run System File Checker
sfc /scannow
if %errorlevel% neq 0 echo System File Checker encountered errors. & goto :repair_error

REM Run DISM to repair Windows Image
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
if %errorlevel% neq 0 echo DISM encountered errors. & goto :repair_error

echo System file check and repair completed successfully.
goto :repair_end

:repair_error
echo An error occurred during system file check and repair.
pause
exit /b 1

:repair_end
echo Press any key to return to menu...
pause >nul
goto :menu

:endexit
echo Thank you for using this script!
pause
exit
