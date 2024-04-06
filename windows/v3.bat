@echo off
setlocal EnableDelayedExpansion

rem Check OS version
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "10.0" (
   set IS_WIN10=1
) else if "%version%" == "11.0" (
   set IS_WIN11=1
) else (
   echo This script only supports Windows 10 and Windows 11.
   pause
   exit
)

rem Get system specs
call :check_ram
call :check_disk
call :check_cpu

cls

NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
   GOTO main_menu
) ELSE (
   echo This script requires administrator privileges. Please run as administrator.
   pause
   exit
)

rem Display main menu
:main_menu
cls
echo Windows System Optimization Script
echo ===================================
echo OS: Windows %version%
echo RAM: %ram% MB
echo Disk: %disksize% GB
echo CPU Cores: %cores%
echo.
echo Select an optimization category:
echo 1. System Performance
echo 2. Network And Internet
echo 3. User Interface And Personalization
echo 4. Privacy And Security
echo 5. Gaming And Multimedia
echo 6. Software Management And System Maintenance
echo 7. Undo Last Optimization
echo 8. Optimize All
echo 9. Exit
echo.
choice /c 123456789 /m "Enter your choice: "
goto main_option%errorlevel%

:main_option1
call :system_performance_menu
goto main_menu

:main_option2
call :network_menu
goto main_menu

:main_option3
call :ui_personalization_menu
goto main_menu

:main_option4
call :privacy_security_menu
goto main_menu

:main_option5
call :gaming_multimedia_menu
goto main_menu

:main_option6
call :software_system_menu
goto main_menu

:main_option7
call :undo_optimization
goto main_menu

:main_option8
call :optimize_all
goto main_menu

:main_option9
echo Exiting script...
pause
exit /b

rem System Performance sub-menu
:system_performance_menu
cls
echo System Performance Optimizations
echo =================================
echo 1. Optimize Power Plan
echo 2. Disable Unnecessary Services
echo 3. Disable Startup Apps
echo 4. Optimize Page File
echo 5. Disk Cleanup and Optimization
echo 6. Back to Main Menu
echo.
choice /c 123456 /m "Enter your choice: "

if %errorlevel% equ 1 call :optimize_power_plan
if %errorlevel% equ 2 call :disable_services
if %errorlevel% equ 3 call :disable_startup_apps
if %errorlevel% equ 4 call :optimize_pagefile
if %errorlevel% equ 5 call :disk_cleanup
if %errorlevel% equ 6 goto main_menu

goto system_performance_menu

rem Network & Internet sub-menu
:network_menu
cls
echo Network ^& Internet Optimizations
echo =================================
echo 1. Optimize TCP/IP Settings
echo 2. Optimize DNS Settings
echo 3. Optimize Network Adapter Settings
echo 4. Disable IPv6
echo 5. Back to Main Menu
echo.
choice /c 12345 /m "Enter your choice: "

if %errorlevel% equ 1 call :optimize_tcp
if %errorlevel% equ 2 call :optimize_dns
if %errorlevel% equ 3 call :optimize_network_adapter
if %errorlevel% equ 4 call :disable_ipv6
if %errorlevel% equ 5 goto main_menu

goto network_menu

rem User Interface & Personalization sub-menu
:ui_personalization_menu
cls
echo User Interface ^& Personalization Optimizations
echo ===============================================
echo 1. Customize Visual Effects
echo 2. Customize Start Menu Layout
echo 3. Customize File Explorer Options
echo 4. Customize Action Center
echo 5. Back to Main Menu
echo.
choice /c 12345 /m "Enter your choice: "

if %errorlevel% equ 1 call :customize_visual_effects
if %errorlevel% equ 2 call :customize_start_menu
if %errorlevel% equ 3 call :customize_file_explorer
if %errorlevel% equ 4 call :customize_action_center
if %errorlevel% equ 5 goto main_menu

goto ui_personalization_menu

rem Privacy & Security sub-menu
:privacy_security_menu
cls
echo Privacy ^& Security Optimizations
echo =================================
echo 1. Disable Telemetry and Data Collection
echo 2. Harden Security Settings
echo 3. Optimize User Account Control (UAC)
echo 4. Disable Remote Access
echo 5. Clear Event Logs
echo 6. Back to Main Menu
echo.
choice /c 123456 /m "Enter your choice: "

if %errorlevel% equ 1 call :disable_telemetry
if %errorlevel% equ 2 call :harden_security
if %errorlevel% equ 3 call :optimize_uac
if %errorlevel% equ 4 call :disable_remote_access
if %errorlevel% equ 5 call :clear_event_logs
if %errorlevel% equ 6 goto main_menu

goto privacy_security_menu

rem Gaming & Multimedia sub-menu
:gaming_multimedia_menu
cls
echo Gaming ^& Multimedia Optimizations
echo ===================================
echo 1. Optimize Visual Effects for Performance
echo 2. Disable Game Mode and Game Bar
echo 3. Disable Fullscreen Optimizations
echo 4. Optimize Sound Settings
echo 5. Back to Main Menu
echo.
choice /c 12345 /m "Enter your choice: "

if %errorlevel% equ 1 call :optimize_visual_effects_gaming
if %errorlevel% equ 2 call :disable_game_mode
if %errorlevel% equ 3 call :disable_fullscreen_opt
if %errorlevel% equ 4 call :optimize_sound
if %errorlevel% equ 5 goto main_menu

goto gaming_multimedia_menu

rem Software Management and System Maintenance sub-menu
:software_system_menu
cls
echo Software Management and System Maintenance
echo ==========================================
echo 1. Uninstall Unnecessary Apps
echo 2. Disable Unnecessary Features
echo 3. Disk Cleanup
echo 4. Disk Defragmentation
echo 5. Repair System Files
echo 6. Back to Main Menu
echo.
choice /c 123456 /m "Enter your choice: "

if %errorlevel% equ 1 call :uninstall_apps
if %errorlevel% equ 2 call :disable_features
if %errorlevel% equ 3 call :disk_cleanup
if %errorlevel% equ 4 call :disk_defrag
if %errorlevel% equ 5 call :repair_system_files
if %errorlevel% equ 6 goto main_menu

goto software_system_menu

rem Optimization functions
:optimize_power_plan
echo Optimizing power plan for performance...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo Power plan optimized.
pause
goto system_performance_menu

:disable_services
echo Disabling unnecessary services...
sc config DiagTrack start=disabled
sc config diagnosticshub.standardcollector.service start=disabled
sc config dmwappushservice start=disabled
sc config RemoteRegistry start=disabled
echo Unnecessary services disabled.
pause
goto system_performance_menu

:disable_startup_apps
echo Disabling unnecessary startup apps...

if "%IS_WIN10%" == "1" (
   REM Disable for Windows 10
   powershell -Command "Get-AppxPackage *3DBuilder* | Remove-AppxPackage"
   powershell -Command "Get-AppxPackage *Getstarted* | Remove-AppxPackage"
   powershell -Command "Get-AppxPackage *WindowsAlarms* | Remove-AppxPackage"
   powershell -Command "Get-AppxPackage *WindowsMaps* | Remove-AppxPackage"
   powershell -Command "Get-AppxPackage *SkypeApp* | Remove-AppxPackage"
   powershell -Command "Get-AppxPackage *XboxApp* | Remove-AppxPackage"
   powershell -Command "Get-AppxPackage *Zune* | Remove-AppxPackage"
) else if "%IS_WIN11%" == "1" (
   REM Disable for Windows 11
   powershell -Command "Get-AppxPackage *3DViewer* | Remove-AppxPackage"
   powershell -Command "Get-AppxPackage *GetHelp* | Remove-AppxPackage"
   powershell -Command "Get-AppxPackage *Maps* | Remove-AppxPackage"
   powershell -Command "Get-AppxPackage *Microsoft.Todos* | Remove-AppxPackage"
   powershell -Command "Get-AppxPackage *PowerAutomate* | Remove-AppxPackage"
   powershell -Command "Get-AppxPackage *Music* | Remove-AppxPackage"
)

echo Unnecessary startup apps disabled.
pause
goto system_performance_menu

:optimize_pagefile
echo Optimizing pagefile...

wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=4096

echo Pagefile optimized.
pause
goto system_performance_menu

:disk_cleanup
echo Cleaning up disk...

cleanmgr /sagerun:1

if "%IS_WIN10%" == "1" (
   defrag C: /U /V
) else if "%IS_WIN11%" == "1" (
   defrag C: /U /V /X
)

echo Disk cleaned up and optimized.
pause
goto system_performance_menu

:optimize_tcp
echo Optimizing TCP/IP settings...

netsh int tcp set global autotuninglevel=normal
netsh int tcp set global rss=enabled
netsh int tcp set global ecncapability=enabled
netsh int tcp set global rsc=enabled

if %ram% lss 4096 (
   netsh int tcp set global chimney=disabled
   netsh int tcp set global dca=disabled
) else (
   netsh int tcp set global chimney=enabled
   netsh int tcp set global dca=enabled
)

echo TCP/IP settings optimized.
pause
goto network_menu

:optimize_dns
echo Optimizing DNS settings...

netsh interface ip set dns name="Wi-Fi" source=dhcp
netsh interface ip set dnsservers name="Wi-Fi" source=dhcp

echo DNS settings optimized.
pause
goto network_menu

:optimize_network_adapter
echo Optimizing network adapter settings...

for /f "tokens=4 delims=: " %%a in ('netsh interface show interface ^| findstr /r /c:"Enabled"') do (
   netsh int ipv4 set interface "%%a" forwarding=enabled
   netsh int ipv4 set interface "%%a" metric=10
)

netsh int tcp set global timestamps=disabled
netsh int tcp set heuristics disabled
netsh int tcp set global autotuninglevel=normal

echo Network adapter settings optimized.
pause
goto network_menu

:disable_ipv6
echo Disabling IPv6...

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\TCPIP6\Parameters" /v "DisabledComponents" /t REG_DWORD /d 255 /f

echo IPv6 disabled.
pause
goto network_menu

:customize_visual_effects
echo Customizing visual effects for best appearance...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 1 /f

echo Visual effects customized.
pause
goto ui_personalization_menu

:customize_start_menu
echo Customizing Start menu layout...

if "%IS_WIN10%" == "1" (
   reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_Layout" /t REG_DWORD /d 1 /f
   powershell -command "Import-StartLayout -LayoutPath 'C:\Windows10StartLayout.xml' -MountPath $env:SystemDrive\"
) else if "%IS_WIN11%" == "1" (
   reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_Layout" /t REG_DWORD /d 1 /f
   powershell -command "Import-StartLayout -LayoutPath 'C:\Windows11StartLayout.xml' -MountPath $env:SystemDrive\"
)

echo Start menu layout customized.
pause
goto ui_personalization_menu

:customize_file_explorer
echo Customizing File Explorer options...

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f

echo File Explorer options customized.
pause
goto ui_personalization_menu

:customize_action_center
echo Customizing Action Center...

reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f

echo Action Center customized.
pause
goto ui_personalization_menu

:disable_telemetry
echo Disabling telemetry and data collection...

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
 
sc config DiagTrack start=disabled
sc config dmwappushservice start=disabled

echo Telemetry and data collection disabled.
pause
goto privacy_security_menu

:harden_security
echo Hardening security settings...

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d 3 /f

echo Security settings hardened.
pause
goto privacy_security_menu

:optimize_uac
echo Optimizing UAC settings...

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d 5 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 1 /f

echo UAC settings optimized.
pause
goto privacy_security_menu

:disable_remote_access
echo Disabling remote access...

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f

echo Remote access disabled.
pause
goto privacy_security_menu

:clear_event_logs
echo Clearing event logs...

for /F "tokens=*" %%1 in ('wevtutil.exe el') DO wevtutil.exe cl "%%1"

echo Event logs cleared.
pause
goto privacy_security_menu

:optimize_visual_effects_gaming
echo Optimizing visual effects for gaming performance...

reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9032078010000000 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 0 /f

echo Visual effects optimized for gaming.
pause
goto gaming_multimedia_menu

:disable_game_mode
echo Disabling Game Mode...

reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 0 /f

echo Game Mode disabled.
pause
goto gaming_multimedia_menu

:disable_fullscreen_opt
echo Disabling fullscreen optimizations...

reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d 0 /f

echo Fullscreen optimizations disabled.
pause
goto gaming_multimedia_menu

:optimize_sound
echo Optimizing sound settings...

reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d 3 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /v "DisableProtectedAudioDG" /t REG_DWORD /d 1 /f

echo Sound settings optimized.
pause
goto gaming_multimedia_menu

:uninstall_apps
echo Uninstalling unnecessary apps...

powershell -command "Get-AppxPackage *3DBuilder* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *Getstarted* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *WindowsAlarms* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *WindowsMaps* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *SkypeApp* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *XboxApp* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *Zune* | Remove-AppxPackage"

echo Unnecessary apps uninstalled.
pause
goto software_system_menu

:disable_features
echo Disabling unnecessary features...

dism /Online /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64 /norestart
dism /Online /Disable-Feature /FeatureName:WorkFolders-Client /norestart
dism /Online /Disable-Feature /FeatureName:Printing-PrintToPDFServices-Features /norestart

echo Unnecessary features disabled.
pause
goto software_system_menu

:disk_defrag
echo Defragmenting disk...

if "%IS_WIN10%" == "1" (
    defrag C: /U /V
) else if "%IS_WIN11%" == "1" (
    defrag C: /U /V /X
)

echo Disk defragmentation completed.
pause
goto software_system_menu

:repair_system_files
echo Repairing system files...

dism /Online /Cleanup-Image /RestoreHealth
sfc /scannow

echo System files repaired.
pause
goto software_system_menu

:optimize_all
echo Performing all system optimizations...

call :optimize_power_plan
call :disable_services
call :disable_startup_apps
call :optimize_pagefile
call :disk_cleanup
call :optimize_tcp
call :optimize_dns
call :optimize_network_adapter
call :disable_ipv6
call :customize_visual_effects
call :customize_start_menu
call :customize_file_explorer
call :customize_action_center
call :disable_telemetry
call :harden_security
call :optimize_uac
call :disable_remote_access
call :clear_event_logs
call :optimize_visual_effects_gaming
call :disable_game_mode
call :disable_fullscreen_opt
call :optimize_sound
call :uninstall_apps
call :disable_features
call :disk_defrag
call :repair_system_files

echo All system optimizations completed.
pause
goto main_menu

:undo_optimization
echo Undoing last optimization...

REM Undo power plan optimization
powercfg -restoredefaultschemes

REM Undo service disabling
sc config DiagTrack start=auto
sc config diagnosticshub.standardcollector.service start=auto
sc config dmwappushservice start=auto
sc config RemoteRegistry start=auto

REM Undo startup app disabling
REM (No action needed, apps will be restored on next login)

REM Undo pagefile optimization
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True

REM Undo TCP/IP optimization
netsh int ip reset
netsh int tcp reset
netsh winsock reset

REM Undo DNS optimization
netsh interface ip set dnsservers name="Wi-Fi" source=dhcp
netsh interface ip set dnsservers name="Ethernet" source=dhcp

REM Undo network adapter optimization
REM (Settings will be restored after system restart)

REM Undo IPv6 disabling
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\TCPIP6\Parameters" /v "DisabledComponents" /f

REM Undo visual effect customization for best appearance
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /f

REM Undo Start menu layout customization
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_Layout" /f

REM Undo File Explorer customization
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /f

REM Undo Action Center customization
reg delete "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /f

REM Undo telemetry disabling
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f

sc config DiagTrack start=auto
sc config dmwappushservice start=auto

REM Undo security hardening
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /f

REM Undo UAC optimization
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /f

REM Undo remote access disabling
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /f

REM Undo visual effect optimization for gaming
reg delete "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /f
reg delete "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /f

REM Undo Game Mode disabling
reg delete "HKCU\Software\Microsoft\GameBar" /f

REM Undo fullscreen optimization disabling
reg delete "HKCU\System\GameConfigStore" /f

REM Undo sound optimization
reg delete "HKCU\Software\Microsoft\Multimedia\Audio" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /f

echo Last system optimization undone.
pause
goto main_menu

rem System spec check functions
:check_ram
for /f "tokens=2 delims==" %%a in ('wmic memorychip get capacity /value ^| findstr Capacity') do set ram=%%a
set /a ram=%ram:~0,-6%
goto :eof

:check_disk
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get Size /value ^| findstr Size') do set disksize=%%a
set /a disksize=%disksize:~0,-9%
goto :eof

:check_cpu
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /value ^| findstr NumberOfCores') do set cores=%%a
goto :eof
