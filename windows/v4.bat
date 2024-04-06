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

:main_menu
cls
echo Windows System Optimization Script
echo ===================================
echo OS: Windows %version%
echo RAM: %ram% MB
echo Disk: %disksize% GB
echo CPU Cores: %cores%
echo.
echo Select an option:
echo 1. Optimize All
echo 2. Customize Desktop Icons
echo 3. Customize Taskbar
echo 4. Customize Context Menu
echo 5. Customize Windows Explorer
echo 6. Customize Power Options
echo 7. Exit
echo.
choice /c 1234567 /m "Enter your choice: "
goto option%errorlevel%

:option1
call :optimize_all
goto main_menu

:option2
call :customize_desktop_icons
goto main_menu

:option3
call :customize_taskbar
goto main_menu

:option4
call :customize_context_menu
goto main_menu

:option5
call :customize_windows_explorer
goto main_menu

:option6
call :customize_power_options
goto main_menu

:option7
echo Exiting script...
pause
exit

:optimize_all
echo Performing all system optimizations...
echo.

REM Disable unnecessary services
echo Disabling unnecessary services...
sc config DiagTrack start=disabled
sc config diagnosticshub.standardcollector.service start=disabled
sc config dmwappushservice start=disabled
sc config RemoteRegistry start=disabled
echo.

REM Disable unnecessary startup apps
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
echo.

REM Optimize power plan for performance
echo Optimizing power plan for performance...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo.

REM Optimize pagefile
echo Optimizing pagefile...
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=4096
echo.

REM Disk cleanup and optimization
echo Cleaning up disk...
cleanmgr /sagerun:1
if "%IS_WIN10%" == "1" (
   defrag C: /U /V
) else if "%IS_WIN11%" == "1" (
   defrag C: /U /V /X
)
echo.

REM Optimize TCP/IP settings
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
echo.

REM Optimize DNS settings
echo Optimizing DNS settings...
netsh interface ip set dns name="Wi-Fi" source=dhcp
netsh interface ip set dnsservers name="Wi-Fi" source=dhcp
echo.

REM Optimize network adapter settings
echo Optimizing network adapter settings...
for /f "tokens=4 delims=: " %%a in ('netsh interface show interface ^| findstr /r /c:"Enabled"') do (
   netsh int ipv4 set interface "%%a" forwarding=enabled
   netsh int ipv4 set interface "%%a" metric=10
)

netsh int tcp set global timestamps=disabled
netsh int tcp set heuristics disabled
netsh int tcp set global autotuninglevel=normal
echo.

REM Disable IPv6
echo Disabling IPv6...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\TCPIP6\Parameters" /v "DisabledComponents" /t REG_DWORD /d 255 /f
echo.

REM Customize visual effects for best performance
echo Customizing visual effects for best performance...
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9032078010000000 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 0 /f
echo.

REM Customize Start menu layout
echo Customizing Start menu layout...
if "%IS_WIN10%" == "1" (
   reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_Layout" /t REG_DWORD /d 1 /f
   powershell -command "Import-StartLayout -LayoutPath 'C:\Windows10StartLayout.xml' -MountPath $env:SystemDrive\"
) else if "%IS_WIN11%" == "1" (
   reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_Layout" /t REG_DWORD /d 1 /f
   powershell -command "Import-StartLayout -LayoutPath 'C:\Windows11StartLayout.xml' -MountPath $env:SystemDrive\"
)
echo.

REM Customize File Explorer options
echo Customizing File Explorer options...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f
echo.

REM Customize Action Center
echo Customizing Action Center...
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f
echo.

REM Disable telemetry and data collection
echo Disabling telemetry and data collection...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
sc config DiagTrack start=disabled
sc config dmwappushservice start=disabled
echo.

REM Harden security settings
echo Hardening security settings...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d 3 /f
echo.

REM Optimize UAC settings
echo Optimizing UAC settings...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d 5 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 1 /f
echo.

REM Disable remote access
echo Disabling remote access...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f
echo.

REM Clear event logs
echo Clearing event logs...
for /F "tokens=*" %%1 in ('wevtutil.exe el') DO wevtutil.exe cl "%%1"
echo.

REM Disable Game Mode and Game Bar
echo Disabling Game Mode and Game Bar...
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 0 /f
echo.

REM Disable fullscreen optimizations
echo Disabling fullscreen optimizations...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d 0 /f
echo.

REM Optimize sound settings
echo Optimizing sound settings...
reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d 3 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /v "DisableProtectedAudioDG" /t REG_DWORD /d 1 /f
echo.

REM Uninstall unnecessary apps
echo Uninstalling unnecessary apps...
powershell -command "Get-AppxPackage *3DBuilder* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *Getstarted* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *WindowsAlarms* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *WindowsMaps* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *SkypeApp* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *XboxApp* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *Zune* | Remove-AppxPackage"
echo.

REM Disable unnecessary features
echo Disabling unnecessary features...
dism /Online /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64 /norestart
dism /Online /Disable-Feature /FeatureName:WorkFolders-Client /norestart
dism /Online /Disable-Feature /FeatureName:Printing-PrintToPDFServices-Features /norestart
echo.

REM Repair system files
echo Repairing system files...
dism /Online /Cleanup-Image /RestoreHealth
sfc /scannow
echo.

echo All system optimizations completed.
pause
goto main_menu

:customize_desktop_icons
echo Customizing desktop icons...

REM Hide desktop icons
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideIcons" /t REG_DWORD /d 1 /f

REM Show Computer icon
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f

REM Hide Recycle Bin icon
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 1 /f

echo Desktop icons customized.
pause
goto main_menu

:customize_taskbar
echo Customizing taskbar...

REM Hide Task View button
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f

REM Hide Cortana button
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d 0 /f

REM Hide People button
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v "PeopleBand" /t REG_DWORD /d 0 /f

REM Show small taskbar buttons
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t REG_DWORD /d 1 /f

echo Taskbar customized.
pause
goto main_menu

:customize_context_menu
echo Customizing context menu...

REM Remove "Share" from context menu
reg delete "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f

REM Remove "Give access to" from context menu
reg add "HKCR\*\shellex\ContextMenuHandlers\Sharing" /ve /t REG_SZ /d "" /f

REM Remove "Include in library" from context menu
reg delete "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f

REM Remove "Send to" from context menu
reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" /f

echo Context menu customized.
pause
goto main_menu

:customize_windows_explorer
echo Customizing Windows Explorer...

REM Show file extensions
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f

REM Show hidden files
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f

REM Show protected operating system files
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 1 /f

REM Launch Explorer to "This PC"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f

echo Windows Explorer customized.
pause
goto main_menu

:customize_power_options
echo Customizing power options...

REM Set power plan to High Performance
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

REM Disable hibernate
powercfg -h off

REM Disable sleep
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0

REM Set lid close action to "Do nothing"
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0

echo Power options customized.
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
