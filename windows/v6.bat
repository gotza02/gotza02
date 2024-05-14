@echo off
setlocal EnableDelayedExpansion

rem Check OS version
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%VERSION%" == "10.0" (
   set IS_WIN10=1
) else if "%VERSION%" == "11.0" (
   set IS_WIN11=1
) else (
   echo This script only supports Windows 10 and Windows 11.
   pause
   exit /b
)

rem Get system specs
call :check_ram
call :check_disk
call :check_cpu

cls

NET SESSION >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
   echo This script requires administrator privileges. Please run as administrator.
   pause
   exit /b
)

:main_menu
cls
echo Windows System Optimization Script
echo ===================================
echo OS: Windows %VERSION%
echo RAM: %ram% MB
echo Disk: %disksize% GB
echo CPU Cores: %cores%
echo.
echo Select a category:
echo 1. System Optimizations
echo 2. Desktop Customization
echo 3. Taskbar Customization
echo 4. Context Menu Customization
echo 5. Windows Explorer Customization
echo 6. Power Options Customization
echo 7. Security and Privacy Settings
echo 8. Network Optimizations
echo 9. Gaming Optimizations
echo 0. Exit
echo.
choice /c 1234567890 /m "Enter your choice: "
goto category%errorlevel%

:category1
call :optimize_all
goto main_menu

:category2
call :customize_desktop
goto main_menu

:category3
call :customize_taskbar
goto main_menu

:category4
call :customize_context_menu
goto main_menu

:category5
call :customize_windows_explorer
goto main_menu

:category6
call :customize_power_options
goto main_menu

:category7
call :customize_security_privacy
goto main_menu

:category8
call :optimize_network
goto main_menu

:category9
call :optimize_gaming
goto main_menu

:category0
echo Exiting script...
pause
exit /b

:optimize_all
echo Performing all system optimizations...
echo.

rem Disable unnecessary services
echo Disabling unnecessary services...
for %%s in (DiagTrack diagnosticshub.standardcollector.service dmwappushservice RemoteRegistry) do (
   sc config %%s start= disabled || echo Failed to disable service %%s
)
echo.

rem Disable unnecessary startup apps
echo Disabling unnecessary startup apps...
for %%a in (3DBuilder Getstarted WindowsAlarms WindowsMaps SkypeApp XboxApp ZuneMusic ZuneVideo Solitaire BingFinance BingNews BingSports BingWeather Microsoft.Messaging Bing WindowsFeedbackHub Cortana OneNote Photos WindowsPhone) do (
   powershell -Command "Get-AppxPackage *%%a* -AllUsers | Remove-AppxPackage" || echo Failed to remove app %%a
)
echo.

rem Optimize power plan for performance
echo Optimizing power plan for performance...
powercfg -setactive SCHEME_MIN
echo.

rem Optimize pagefile
echo Optimizing pagefile...
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=4096
echo.

rem Disk cleanup and optimization
echo Cleaning up disk...
cleanmgr /sagerun:1
defrag C: /U /V
echo.

rem Disable hibernation
echo Disabling hibernation...
powercfg -h off
echo.

rem Disable system restore
echo Disabling system restore...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v "DisableSR" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v "DisableConfig" /t REG_DWORD /d 1 /f
echo.

rem Disable Windows Defender
echo Disabling Windows Defender...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d 1 /f
echo.

rem Disable Windows Update
echo Disabling Windows Update...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f
echo.

rem Disable search indexing
echo Disabling search indexing...
sc config WSearch start= disabled
sc stop WSearch
echo.

rem Disable NTFS file compression
echo Disabling NTFS file compression...
fsutil behavior set DisableCompression 1
echo.

rem Disable Windows error reporting
echo Disabling Windows error reporting...
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d 1 /f
echo.

rem Disable telemetry and data collection
echo Disabling telemetry and data collection...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v "Start" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\ControlSet001\Services\DiagTrack" /v "Start" /t REG_DWORD /d 4 /f
reg add "HKLM\SYSTEM\ControlSet001\Services\dmwappushservice" /v "Start" /t REG_DWORD /d 4 /f
echo.

rem Disable telemetry tasks
echo Disabling telemetry tasks...
for %%t in ("\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" "\Microsoft\Windows\Application Experience\ProgramDataUpdater" "\Microsoft\Windows\Autochk\Proxy" "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector") do (
   schtasks /Change /TN %%t /Disable
)
echo.

rem Disable Cortana
echo Disabling Cortana...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d 0 /f
echo.

rem Disable OneDrive
echo Disabling OneDrive...
start /wait "" "%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe" /uninstall
for %%d in ("%USERPROFILE%\OneDrive" "C:\OneDriveTemp" "%LOCALAPPDATA%\Microsoft\OneDrive" "%PROGRAMDATA%\Microsoft OneDrive") do (
   rd "%%d" /Q /S
)
reg add "HKLM\Software\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f
reg add "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f
reg add "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f
echo.

rem Disable remote access
echo Disabling remote access...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "UserAuthentication" /t REG_DWORD /d 1 /f
echo.

rem Disable unnecessary Windows features
echo Disabling unnecessary Windows features...
for %%f in ("Internet-Explorer-Optional-amd64" "Printing-PrintToPDFServices-Features" "Printing-XPSServices-Features" "MSRDC-Infrastructure" "WorkFolders-Client") do (
   dism /Online /Disable-Feature /FeatureName:%%f
)
echo.

rem Harden security settings
echo Hardening security settings...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d 3 /f
echo.

rem Optimize UAC settings
echo Optimizing UAC settings...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d 5 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 1 /f
echo.

rem Clear event logs
echo Clearing event logs...
for /F "tokens=*" %%1 in ('wevtutil.exe el') do wevtutil.exe cl "%%1"
echo.

echo All system optimizations completed.
pause
goto main_menu

:customize_desktop
cls
echo Customize Desktop Icons:
echo ========================
echo.
echo Select an option:
echo 1. Hide all desktop icons
echo 2. Show Computer icon
echo 3. Show User's Files icon
echo 4. Show Network icon
echo 5. Show Recycle Bin icon
echo 6. Show Control Panel icon
echo 7. Return to Main Menu
echo.
choice /c 1234567 /m "Enter your choice: "
goto desktop%errorlevel%

:desktop1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideIcons" /t REG_DWORD /d 1 /f
echo All desktop icons hidden.
timeout /t 2 >nul
goto customize_desktop

:desktop2
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f
echo Computer icon shown on desktop.
timeout /t 2 >nul
goto customize_desktop

:desktop3
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f
echo User's Files icon shown on desktop.
timeout /t 2 >nul
goto customize_desktop

:desktop4
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 0 /f
echo Network icon shown on desktop.
timeout /t 2 >nul
goto customize_desktop

:desktop5
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f
echo Recycle Bin icon shown on desktop.
timeout /t 2 >nul
goto customize_desktop

:desktop6
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d 0 /f
echo Control Panel icon shown on desktop.
timeout /t 2 >nul
goto customize_desktop

:desktop7
goto main_menu

:customize_taskbar
cls
echo Customize Taskbar:
echo ==================
echo.
echo Select an option:
echo 1. Hide Task View button
echo 2. Hide Search button
echo 3. Hide Cortana button
echo 4. Hide People button
echo 5. Hide Windows Ink Workspace button
echo 6. Lock the taskbar
echo 7. Hide Meet Now icon
echo 8. Hide News and Interests
echo 9. Return to Main Menu
echo.
choice /c 123456789 /m "Enter your choice: "
goto taskbar%errorlevel%

:taskbar1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f
echo Task View button hidden.
timeout /t 2 >nul
goto customize_taskbar

:taskbar2
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f
echo Search button hidden.
timeout /t 2 >nul
goto customize_taskbar

:taskbar3
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d 0 /f
echo Cortana button hidden.
timeout /t 2 >nul
goto customize_taskbar

:taskbar4
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v "PeopleBand" /t REG_DWORD /d 0 /f
echo People button hidden.
timeout /t 2 >nul
goto customize_taskbar

:taskbar5
reg add "HKCU\Software\Microsoft\WindowsInkWorkspace" /v "PenWorkspaceButtonDesiredVisibility" /t REG_DWORD /d 0 /f
echo Windows Ink Workspace button hidden.
timeout /t 2 >nul
goto customize_taskbar

:taskbar6
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSizeMove" /t REG_DWORD /d 0 /f
echo Taskbar locked.
timeout /t 2 >nul
goto customize_taskbar

:taskbar7
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d 1 /f
echo Meet Now icon hidden.
timeout /t 2 >nul
goto customize_taskbar

:taskbar8
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2 /f
echo News and Interests hidden.
timeout /t 2 >nul
goto customize_taskbar

:taskbar9
goto main_menu

:customize_context_menu
cls
echo Customize Context Menu:
echo =======================
echo.
echo Select an option:
echo 1. Remove "Share" from context menu
echo 2. Remove "Give access to" from context menu
echo 3. Remove "Restore Previous Versions" from context menu
echo 4. Remove "Pin to Quick Access" from context menu
echo 5. Remove "Include in Library" from context menu
echo 6. Remove "Send to" from context menu
echo 7. Return to Main Menu
echo.
choice /c 1234567 /m "Enter your choice: "
goto context%errorlevel%

:context1
reg delete "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f
echo "Share" removed from context menu.
timeout /t 2 >nul
goto customize_context_menu

:context2
reg add "HKCR\*\shellex\ContextMenuHandlers\Sharing" /ve /t REG_SZ /d "" /f
echo "Give access to" removed from context menu.
timeout /t 2 >nul
goto customize_context_menu

:context3
reg add "HKCR\AllFilesystemObjects\shellex\PropertySheetHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /ve /t REG_SZ /d "" /f
echo "Restore Previous Versions" removed from context menu.
timeout /t 2 >nul
goto customize_context_menu

:context4
reg delete "HKCR\Folder\shell\pintohome" /f
echo "Pin to Quick Access" removed from context menu.
timeout /t 2 >nul
goto customize_context_menu

:context5
reg delete "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f
echo "Include in Library" removed from context menu.
timeout /t 2 >nul
goto customize_context_menu

:context6
reg delete "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" /f
echo "Send to" removed from context menu.
timeout /t 2 >nul
goto customize_context_menu

:context7
goto main_menu

:customize_windows_explorer
cls
echo Customize Windows Explorer:
echo ===========================
echo.
echo Select an option:
echo 1. Show file extensions
echo 2. Show hidden files
echo 3. Show protected operating system files
echo 4. Launch Explorer to "This PC"
echo 5. Open Explorer to a specific folder
echo 6. Hide frequent folders in Quick Access
echo 7. Return to Main Menu
echo.
choice /c 1234567 /m "Enter your choice: "
goto explorer%errorlevel%

:explorer1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f
echo File extensions shown in Windows Explorer.
timeout /t 2 >nul
goto customize_windows_explorer

:explorer2
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f
echo Hidden files and folders shown in Windows Explorer.
timeout /t 2 >nul
goto customize_windows_explorer

:explorer3
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 1 /f
echo Protected operating system files shown in Windows Explorer.
timeout /t 2 >nul
goto customize_windows_explorer

:explorer4
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f
echo File Explorer will now open to "This PC".
timeout /t 2 >nul
goto customize_windows_explorer

:explorer5
set /p "folder=Enter the full path to the folder Explorer should open to: "
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LastActiveClick" /t REG_SZ /d "%folder%" /f
echo Explorer will now open to "%folder%".
timeout /t 2 >nul
goto customize_windows_explorer

:explorer6
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d 0 /f
echo Frequent folders hidden in Quick Access.
timeout /t 2 >nul
goto customize_windows_explorer

:explorer7
goto main_menu

:customize_power_options
cls
echo Customize Power Options:
echo ========================
echo.
echo Select an option:
echo 1. Set power plan to High Performance
echo 2. Disable hibernate
echo 3. Disable sleep
echo 4. Set lid close action to "Do nothing"
echo 5. Change critical battery level
echo 6. Disable adaptive brightness
echo 7. Return to Main Menu
echo.
choice /c 1234567 /m "Enter your choice: "
goto power%errorlevel%

:power1
powercfg -setactive SCHEME_MIN
echo Power plan set to High Performance.
timeout /t 2 >nul
goto customize_power_options

:power2
powercfg -h off
echo Hibernate disabled.
timeout /t 2 >nul
goto customize_power_options

:power3
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
echo Sleep disabled.
timeout /t 2 >nul
goto customize_power_options

:power4
powercfg -setacvalueindex SCHEME_MIN SUB_BUTTONS PBUTTONACTION 0
powercfg -setdcvalueindex SCHEME_MIN SUB_BUTTONS PBUTTONACTION 0
echo Lid close action set to "Do nothing".
timeout /t 2 >nul
goto customize_power_options

:power5
set /p "level=Enter the critical battery percentage level (1-100): "
powercfg -setdcvalueindex SCHEME_MIN SUB_BATTERY BATACTIONCRIT %level%
echo Critical battery level set to %level%%.
timeout /t 2 >nul
goto customize_power_options

:power6
reg add "HKLM\SOFTWARE\Intel\Display\igfxcui\profiles\Media" /v "ProcAmbientLightSensor" /t REG_DWORD /d 0 /f
echo Adaptive brightness disabled.
timeout /t 2 >nul
goto customize_power_options

:power7
goto main_menu

:customize_security_privacy
cls
echo Customize Security and Privacy Settings:
echo ========================================
echo.
echo Select an option:
echo 1. Disable Windows Defender
echo 2. Disable SmartScreen for Microsoft Edge
echo 3. Disable Microsoft Accounts
echo 4. Disable password reveal button
echo 5. Disable Camera access
echo 6. Disable Location access
echo 7. Disable Microphone access
echo 8. Return to Main Menu
echo.
choice /c 12345678 /m "Enter your choice: "
goto security%errorlevel%

:security1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
echo Windows Defender disabled.
timeout /t 2 >nul
goto customize_security_privacy

:security2
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 0 /f
echo SmartScreen for Microsoft Edge disabled.
timeout /t 2 >nul
goto customize_security_privacy

:security3
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoConnectedUser" /t REG_DWORD /d 3 /f
echo Microsoft Accounts disabled.
timeout /t 2 >nul
goto customize_security_privacy

:security4
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CredUI" /v "DisablePasswordReveal" /t REG_DWORD /d 1 /f
echo Password reveal button disabled.
timeout /t 2 >nul
goto customize_security_privacy

:security5
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCamera" /t REG_DWORD /d 2 /f
echo Camera access disabled.
timeout /t 2 >nul
goto customize_security_privacy

:security6
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessLocation" /t REG_DWORD /d 2 /f
echo Location access disabled.
timeout /t 2 >nul
goto customize_security_privacy

:security7
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone" /t REG_DWORD /d 2 /f
echo Microphone access disabled.
timeout /t 2 >nul
goto customize_security_privacy

:security8
goto main_menu

:optimize_network
cls
echo Optimize Network Settings:
echo ==========================
echo.
echo Select an option:
echo 1. Optimize TCP/IP settings
echo 2. Optimize DNS settings
echo 3. Optimize network adapter settings
echo 4. Disable IPv6
echo 5. Disable NetBIOS
echo 6. Change DNS server
echo 7. Return to Main Menu
echo.
choice /c 1234567 /m "Enter your choice: "
goto network%errorlevel%

:network1
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
timeout /t 2 >nul
goto optimize_network

:network2
netsh interface ip set dns name="Wi-Fi" source=dhcp
netsh interface ip set dnsservers name="Wi-Fi" source=dhcp
echo DNS settings optimized.
timeout /t 2 >nul
goto optimize_network

:network3
for /f "tokens=4 delims=: " %%a in ('netsh interface show interface ^| findstr /r /c:"Enabled"') do (
   netsh int ipv4 set interface "%%a" forwarding=enabled
   netsh int ipv4 set interface "%%a" metric=10
)

netsh int tcp set global timestamps=disabled
netsh int tcp set heuristics disabled
netsh int tcp set global autotuninglevel=normal
echo Network adapter settings optimized.
timeout /t 2 >nul
goto optimize_network

:network4
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\TCPIP6\Parameters" /v "DisabledComponents" /t REG_DWORD /d 255 /f
echo IPv6 disabled.
timeout /t 2 >nul
goto optimize_network

:network5
wmic nicconfig where TcpipNetbiosOptions=0 call SetTcpipNetbios 2
wmic nicconfig where TcpipNetbiosOptions=1 call SetTcpipNetbios 2
echo NetBIOS disabled.
timeout /t 2 >nul
goto optimize_network

:network6
set /p "dns=Enter the DNS server address: "
netsh interface ip set dns name="Wi-Fi" static %dns%
echo DNS server changed to %dns%.
timeout /t 2 >nul
goto optimize_network

:network7
goto main_menu

:optimize_gaming
cls
echo Optimize Gaming Performance:
echo ============================
echo.
echo Select an option:
echo 1. Disable Game Mode and Game Bar
echo 2. Disable fullscreen optimizations
echo 3. Optimize sound settings
echo 4. Optimize GPU settings
echo 5. Disable mouse acceleration
echo 6. Increase TCP control window
echo 7. Return to Main Menu
echo.
choice /c 1234567 /m "Enter your choice: "
goto gaming%errorlevel%

:gaming1
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 0 /f
echo Game Mode and Game Bar disabled.
timeout /t 2 >nul
goto optimize_gaming

:gaming2
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d 0 /f
echo Fullscreen optimizations disabled.
timeout /t 2 >nul
goto optimize_gaming

:gaming3
reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d 3 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /v "DisableProtectedAudioDG" /t REG_DWORD /d 1 /f
echo Sound settings optimized.
timeout /t 2 >nul
goto optimize_gaming

:gaming4
rem Detect graphics card manufacturer
for /f "delims=" %%a in ('wmic path Win32_VideoController get AdapterCompatibility') do (
   set "gpu=%%a"
)

if "%gpu%"=="Intel" (
   echo Optimizing settings for Intel GPU...
   reg add "HKCU\Software\Intel\Display\igfxcui\Media" /v "Deinterlacing" /t REG_DWORD /d 1 /f
   reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "FeatureTestControl" /t REG_DWORD /d b0000288 /f
   reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerEnable" /t REG_DWORD /d 0 /f
   reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PerfLevelSrc" /t REG_DWORD /d 11111 /f
) else if "%gpu%"=="NVIDIA" (
   echo Optimizing settings for NVIDIA GPU...
   reg add "HKCU\Software\NVIDIA Corporation\Global\NVTweak\Devices\509901221\Color" /v "NvCplUseColorCorrection" /t REG_DWORD /d 0 /f
   reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PlatformSupportMiracast" /t REG_DWORD /d 0 /f
   reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID61684" /t REG_DWORD /d 1 /f
   reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /t REG_DWORD /d 0 /f
) else if "%gpu%"=="Advanced Micro Devices, Inc." (
   echo Optimizing settings for AMD GPU...
   reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3D_Refresh_Rate_Override_DEF" /t REG_DWORD /d 0 /f
   reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3to2Pulldown_NA" /t REG_DWORD /d 0 /f
   reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AAF_NA" /t REG_DWORD /d 0 /f
   reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Adaptive De-interlacing" /t REG_DWORD /d 1 /f
   reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DaltonizationMode" /t REG_DWORD /d 0 /f
)
echo GPU settings optimized for %gpu%.
timeout /t 2 >nul
goto optimize_gaming

:gaming5
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f
echo Mouse acceleration disabled.
timeout /t 2 >nul
goto optimize_gaming

:gaming6
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDataRetransmissions" /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpDelAckTicks" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpInitialRTT" /t REG_DWORD /d 300 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d 1 /f
echo TCP control window increased.
timeout /t 2 >nul
goto optimize_gaming

:gaming7
goto main_menu

rem System spec check functions
:check_ram
set /a ram=0
for /f "tokens=2 delims==" %%a in ('wmic memorychip get capacity /value ^| findstr Capacity') do (
   set /a ram+=%%a / 1048576
)
goto :eof

:check_disk
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get Size /value ^| findstr Size') do (
   set /a disksize=%%a / 1073741824
)
goto :eof

:check_cpu
set /a cores=0
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /value ^| findstr NumberOfCores') do (
   set /a cores+=%%a
)
goto :eof
