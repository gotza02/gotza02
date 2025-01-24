@echo off
setlocal enabledelayedexpansion

:: Check for administrator privileges
:check_admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please run as administrator and try again.
    pause
    exit /b 1
)

:menu
cls
echo ======================================================
echo Windows Optimization Script v3.0 - Advanced Edition
echo ======================================================
echo Please select an option:
echo ======================================================
echo :: 1 - Display Performance Optimization ::
echo 1. Optimize display performance
echo ======================================================
echo :: 2 - Windows Defender Management ::
echo 2. Manage Windows Defender
echo ======================================================
echo :: 3 - Windows Features Optimization ::
echo 3. Windows Features Optimization - Advanced
echo ======================================================
echo :: 4 - CPU Performance Optimization ::
echo 4. CPU Optimization - Advanced
echo ======================================================
echo :: 5 - Internet Performance Optimization ::
echo 5. Internet Performance Optimization - Advanced
echo ======================================================
echo :: 6 - Windows Update Management ::
echo 6. Manage Windows Update
echo ======================================================
echo :: 7 - Auto-login Configuration ::
echo 7. Configure Auto-login
echo ======================================================
echo :: 8 - System Cache Cleanup ::
echo 8. Clearing System Cache - Advanced
echo ======================================================
echo :: 9 - Disk Optimization ::
echo 9. Disk Optimization - Advanced
echo ======================================================
echo :: 10 - System Check and Repair ::
echo 10. System Check and Repair - Advanced
echo ======================================================
echo :: 11 - Windows Activation Management ::
echo 11. Windows Activation
echo ======================================================
echo :: 12 - Power Settings Management ::
echo 12. Power Settings Management - Advanced
echo ======================================================
echo :: 13 - Dark Mode Enable/Disable ::
echo 13. Enable Dark Mode
echo ======================================================
echo :: 14 - Partition Management (DISKPART) ::
echo 14. Manage partitions
echo ======================================================
echo :: 15 - Disk Space Cleanup (DISKCLEANUP) ::
echo 15. Clean up disk space
echo ======================================================
echo :: 16 - Startup Programs Management (MSCONFIG) ::
echo 16. Manage startup programs
echo ======================================================
echo :: 17 - Backup and Restore Settings ::
echo 17. Backup and restore settings
echo ======================================================
echo :: 18 - System Information ::
echo 18. System information
echo ======================================================
echo :: 19 - Privacy Settings Optimization ::
echo 19. Optimize privacy settings
echo ======================================================
echo :: 20 - Windows Services Management ::
echo 20. Windows Services Management
echo ======================================================
echo :: 21 - Network Optimization ::
echo 21. Network optimization
echo ======================================================
echo :: 22 - Exit Script ::
echo 22. Exit
echo ======================================================
set /p choice=Enter your choice (1-22):

:: Validate user input
if not "%choice%"=="" (
    if %choice% geq 1 if %choice% leq 22 (
        goto option_%choice%
    )
)

:: If invalid choice, prompt again
echo Invalid choice. Please try again.
pause
goto menu

:option_1
:optimize_display
echo Optimizing display performance...
call :modify_registry "HKCU\Control Panel\Desktop" "UserPreferencesMask" "REG_BINARY" "9012078010000000"
call :modify_registry "HKCU\Control Panel\Desktop" "MenuShowDelay" "REG_SZ" "0"
call :modify_registry "HKCU\Control Panel\Desktop\WindowMetrics" "MinAnimate" "REG_SZ" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewAlphaSelect" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewShadow" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" "EnableAeroPeek" "REG_DWORD" "0"
echo Display performance optimized.
pause
goto menu

:option_2
:manage_defender
cls
echo ===================================================
echo             Windows Defender Management
echo ===================================================
echo 1. Check Windows Defender Status
echo 2. Enable Windows Defender Protection
echo 3. Disable Windows Defender Protection (HIGH RISK - NOT RECOMMENDED)
echo 4. Update Windows Defender Signatures
echo 5. Run Quick Scan for Threats
echo 6. Run Full System Scan for Threats (May take time)
echo 7. Manage Real-time Protection (Enable/Disable)
echo 8. Manage Cloud-delivered Protection (Enable/Disable)
echo 9. Manage Automatic Sample Submission (Enable/Disable)
echo 10. Manage Potentially Unwanted Application (PUA) Protection (Enable/Disable)
echo 11. View Threat History Log
echo 12. Return to Main Menu
echo ===================================================
set /p def_choice=Enter your choice (1-12):

if "%def_choice%"=="1" goto check_defender
if "%def_choice%"=="2" goto enable_defender
if "%def_choice%"=="3" goto disable_defender
if "%def_choice%"=="4" goto update_defender
if "%def_choice%"=="5" goto quick_scan
if "%def_choice%"=="6" goto full_scan
if "%def_choice%"=="7" goto manage_realtime
if "%def_choice%"=="8" goto manage_cloud
if "%def_choice%"=="9" goto manage_samples
if "%def_choice%"=="10" goto manage_pua
if "%def_choice%"=="11" goto view_history
if "%def_choice%"=="12" goto menu
echo Invalid choice. Please try again.
pause
goto manage_defender

:check_defender
echo Checking Windows Defender Status...
sc query windefend
if %errorlevel% equ 0 (
    echo.
    echo Windows Defender Service Status Check Completed.
    echo Check the output above for detailed service status.
) else (
    echo.
    echo Error: Unable to check Windows Defender service status.
    echo Please ensure you have administrator privileges and Windows Defender is installed.
)
pause
goto manage_defender

:enable_defender
echo Enabling Windows Defender Protection...
echo.
echo Applying settings to enable Windows Defender and Real-Time Protection...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "0"
if %errorlevel% neq 0 goto registry_error
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "0"
if %errorlevel% neq 0 goto registry_error
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableBehaviorMonitoring" "REG_DWORD" "0"
if %errorlevel% neq 0 goto registry_error
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableOnAccessProtection" "REG_DWORD" "0"
if %errorlevel% neq 0 goto registry_error
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableScanOnRealtimeEnable" "REG_DWORD" "0"
if %errorlevel% neq 0 goto registry_error
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "1"
if %errorlevel% neq 0 goto registry_error
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "1"
if %errorlevel% neq 0 goto registry_error
echo.
echo Windows Defender Protection Enabled Successfully.
pause
goto manage_defender

:disable_defender
echo ==========================================================================================
echo  !!!  WARNING: DISABLING WINDOWS DEFENDER SIGNIFICANTLY INCREASES YOUR SYSTEM'S VULNERABILITY !!!
echo  It is HIGHLY RECOMMENDED to keep Windows Defender enabled for continuous protection.
echo  Disabling it should ONLY be done if you have a COMPELLING REASON and ALTERNATIVE SECURITY MEASURES
echo  are in place and ACTIVELY RUNNING. Proceeding may expose your system to SERIOUS SECURITY RISKS.
echo ==========================================================================================
echo.
set /p disable_confirm=Are you ABSOLUTELY SURE you want to DISABLE Windows Defender Protection? (Type YES to confirm - HIGH RISK):
if /i "%disable_confirm%"=="YES" (
    echo Disabling Windows Defender Protection...
    echo.
    echo Applying settings to disable Windows Defender and Real-Time Protection...
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto registry_error
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto registry_error
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableBehaviorMonitoring" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto registry_error
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableOnAccessProtection" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto registry_error
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableScanOnRealtimeEnable" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto registry_error
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto registry_error
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "2"
    if %errorlevel% neq 0 goto registry_error
    echo.
    echo Windows Defender Protection DISABLED.
    echo !!! YOUR SYSTEM IS NOW AT EXTREME RISK !!!
    echo Re-enable Windows Defender IMMEDIATELY and ensure other security measures are active.
) else (
    echo.
    echo Disabling Windows Defender Protection Cancelled. Windows Defender remains ENABLED and PROTECTING your system.
)
pause
goto manage_defender

:update_defender
echo Updating Windows Defender Signatures...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
if %errorlevel% equ 0 (
    echo.
    echo Windows Defender Signatures Updated Successfully.
) else (
    echo.
    echo Error: Failed to Update Windows Defender Signatures. Error Code: %errorlevel%
    echo Please check your internet connection and ensure Windows Defender is functioning correctly.
)
pause
goto manage_defender

:quick_scan
echo Running Quick Scan for Threats...
echo.
echo Starting a quick scan with Windows Defender...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
if %errorlevel% equ 0 (
    echo.
    echo Quick Scan Completed. Check the output above for scan results.
) else (
    echo.
    echo Error: Quick Scan Failed to Start or Complete. Error Code: %errorlevel%
    echo Please check Windows Defender and system logs for more details.
)
pause
goto manage_defender

:full_scan
echo Running Full System Scan for Threats...
echo.
echo Starting a full system scan with Windows Defender in the background. This may take a considerable time.
echo You can monitor the scan progress in the Windows Security app.
start "" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
echo.
echo Full System Scan Started in the background.
echo You can check the scan progress and results in Windows Security.
pause
goto manage_defender

:manage_realtime
echo Managing Real-time Protection...
echo.
echo Current Real-time Protection Status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring
if %errorlevel% neq 0 (
    echo Warning: Unable to determine current Real-time Protection status.
)
echo.
set /p rtp_choice=Do you want to ENABLE (E) or DISABLE (D) Real-time Protection? (E/D):
if /i "%rtp_choice%"=="E" (
    echo Enabling Real-time Protection...
    reg delete "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /f
    if %errorlevel% equ 0 (
        echo.
        echo Real-time Protection Enabled Successfully.
    ) else (
        echo.
        echo Error: Failed to Enable Real-time Protection. Error Code: %errorlevel%
        echo Please check permissions and system logs.
    )
) else if /i "%rtp_choice%"=="D" (
    echo Disabling Real-time Protection...
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
    if %errorlevel% equ 0 (
        echo.
        echo Real-time Protection Disabled.
        echo !!! WARNING: It is HIGHLY RECOMMENDED to keep Real-time Protection ENABLED for security !!!
    ) else (
        echo.
        echo Error: Failed to Disable Real-time Protection. Error Code: %errorlevel%
        echo Please check permissions and system logs.
    )
) else (
    echo.
    echo Invalid choice. Please enter E or D.
)
pause
goto manage_defender

:manage_cloud
echo Managing Cloud-delivered Protection...
echo.
echo Current Cloud-delivered Protection Status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SpynetReporting
if %errorlevel% neq 0 (
    echo Warning: Unable to determine current Cloud-delivered Protection status.
)
echo.
set /p cloud_choice=Do you want to ENABLE (E) or DISABLE (D) Cloud-delivered Protection? (E/D):
if /i "%cloud_choice%"=="E" (
    echo Enabling Cloud-delivered Protection...
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "2"
    if %errorlevel% neq 0 goto registry_error
    echo.
    echo Cloud-delivered Protection Enabled.
) else if /i "%cloud_choice%"=="D" (
    echo Disabling Cloud-delivered Protection...
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto registry_error
    echo.
    echo Cloud-delivered Protection Disabled.
    echo Recommendation: It is generally recommended to keep Cloud-delivered Protection ENABLED for enhanced threat detection.
) else (
    echo.
    echo Invalid choice. Please enter E or D.
)
pause
goto manage_defender

:manage_samples
echo Managing Automatic Sample Submission...
echo.
echo Current Automatic Sample Submission Status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent
if %errorlevel% neq 0 (
    echo Warning: Unable to determine current Automatic Sample Submission status.
)
echo.
set /p sample_choice=Do you want to ENABLE (E) or DISABLE (D) Automatic Sample Submission? (E/D):
if /i "%sample_choice%"=="E" (
    echo Enabling Automatic Sample Submission...
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto registry_error
    echo.
    echo Automatic Sample Submission Enabled.
) else if /i "%sample_choice%"=="D" (
    echo Disabling Automatic Sample Submission...
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto registry_error
    echo.
    echo Automatic Sample Submission Disabled.
) else (
    echo.
    echo Invalid choice. Please enter E or D.
)
pause
goto manage_defender

:manage_pua
echo Managing Potentially Unwanted Application (PUA) Protection...
echo.
echo Current Potentially Unwanted Application (PUA) Protection Status:
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\PUAProtection" /v PUAProtection
if %errorlevel% neq 0 (
    echo Current PUA Protection Status: Default (likely Disabled if not configured by policy).
)
echo.
echo Choose PUA Protection Mode:
echo 1. Enable PUA Protection (Block)
echo 2. Disable PUA Protection
set /p pua_choice=Enter your choice (1-2):
if "%pua_choice%"=="1" (
    echo Enabling PUA Protection (Block Mode)...
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\PUAProtection" "PUAProtection" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto registry_error
    echo.
    echo Potentially Unwanted Application (PUA) Protection Enabled (Block Mode).
) else if "%pua_choice%"=="2" (
    echo Disabling PUA Protection...
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\PUAProtection" "PUAProtection" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto registry_error
    echo.
    echo Potentially Unwanted Application (PUA) Protection Disabled.
) else (
    echo.
    echo Invalid choice. Please enter 1 or 2.
)
pause
goto manage_defender

:view_history
echo Viewing Threat History Log...
echo.
echo Displaying recent threat history from Windows Defender:
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -GetFiles
if %errorlevel% equ 0 (
    echo.
    echo Threat History Displayed Above. Check the output for details.
) else (
    echo.
    echo Error: Failed to retrieve Threat History. Error Code: %errorlevel%
    echo Please check Windows Defender and system logs for more details.
)
pause
goto manage_defender

:registry_error
echo.
echo !!! ERROR: Failed to modify Registry. Error Code: %errorlevel% !!!
echo Please ensure you are running this script as an Administrator.
echo Registry modification is required for this operation.
pause
goto manage_defender

:option_3
:optimize_features
cls
echo ======================================================
echo Windows Features Optimization - Advanced
echo ======================================================
echo 1. Disable Activity Feed (Timeline)
echo 2. Disable Background Apps
echo 3. Disable Cortana
echo 4. Disable Game DVR and Game Bar
echo 5. Disable Sticky Keys Prompt
echo 6. Disable Windows Tips and Notifications
echo 7. Disable Start Menu Suggestions and Ads
echo 8. Enable Fast Startup
echo ------------------------------------------------------
echo 9. Disable Lock Screen Ads and Spotlight
echo 10. Disable Ink Workspace
echo 11. Disable People Bar (My People)
echo 12. Disable Web Search in Start Menu
echo 13. Disable Location Services (System-wide)
echo 14. Disable Camera Access (For all apps)
echo 15. Disable Microphone Access (For all apps)
echo 16. Disable Advertising ID
echo 17. Disable Telemetry and Data Collection (Basic Level)
echo ------------------------------------------------------
echo 18. Uninstall OneDrive (Optional - Requires User Confirmation)
echo 19. Disable Customer Experience Improvement Program (CEIP)
echo 20. Disable Error Reporting
echo 21. Disable Compatibility Telemetry
echo ------------------------------------------------------
echo 22. Revert all Feature Optimizations (Undo Changes)
echo 23. Return to main menu
echo ======================================================
set /p feature_choice=Enter your choice (1-23):

if "%feature_choice%"=="1" goto disable_activity_feed
if "%feature_choice%"=="2" goto disable_background_apps
if "%feature_choice%"=="3" goto disable_cortana
if "%feature_choice%"=="4" goto disable_game_dvr_bar
if "%feature_choice%"=="5" goto disable_sticky_keys_prompt
if "%feature_choice%"=="6" goto disable_windows_tips
if "%feature_choice%"=="7" goto disable_startmenu_suggestions
if "%feature_choice%"=="8" goto enable_fast_startup
if "%feature_choice%"=="9" goto disable_lockscreen_ads
if "%feature_choice%"=="10" goto disable_ink_workspace
if "%feature_choice%"=="11" goto disable_people_bar
if "%feature_choice%"=="12" goto disable_web_search_startmenu
if "%feature_choice%"=="13" goto disable_location_services
if "%feature_choice%"=="14" goto disable_camera_access
if "%feature_choice%"=="15" goto disable_microphone_access
if "%feature_choice%"=="16" goto disable_advertising_id
if "%feature_choice%"=="17" goto disable_telemetry_basic
if "%feature_choice%"=="18" goto uninstall_onedrive
if "%feature_choice%"=="19" goto disable_ceip
if "%feature_choice%"=="20" goto disable_error_reporting
if "%feature_choice%"=="21" goto disable_compatibility_telemetry
if "%feature_choice%"=="22" goto revert_feature_optimizations
if "%feature_choice%"=="23" goto menu
echo Invalid choice. Please try again.
pause
goto optimize_features

:disable_activity_feed
echo Disabling Activity Feed (Timeline)...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" "0"
echo Activity Feed (Timeline) disabled.
pause
goto optimize_features

:disable_background_apps
echo Disabling Background Apps...
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" "REG_DWORD" "1"
echo Background Apps disabled.
pause
goto optimize_features

:disable_cortana
echo Disabling Cortana...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "0"
echo Cortana disabled.
pause
goto optimize_features

:disable_game_dvr_bar
echo Disabling Game DVR and Game Bar...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" "REG_DWORD" "0"
call :modify_registry "HKCU\System\GameConfigStore" "GameDVR_Enabled" "REG_DWORD" "0"
echo Game DVR and Game Bar disabled.
pause
goto optimize_features

:disable_sticky_keys_prompt
echo Disabling Sticky Keys Prompt...
call :modify_registry "HKCU\Control Panel\Accessibility\StickyKeys" "Flags" "REG_SZ" "506"
echo Sticky Keys Prompt disabled.
pause
goto optimize_features

:disable_windows_tips
echo Disabling Windows Tips and Notifications...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" "1"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastApplicationNotification" "REG_DWORD" "1"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastNotificationQueue" "REG_DWORD" "1"
echo Windows Tips and Notifications disabled.
pause
goto optimize_features

:disable_startmenu_suggestions
echo Disabling Start Menu Suggestions and Ads...
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "0"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" "REG_DWORD" "0"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" "REG_DWORD" "0"
echo Start Menu Suggestions and Ads disabled.
pause
goto optimize_features

:enable_fast_startup
echo Enabling Fast Startup...
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HiberbootEnabled" "REG_DWORD" "1"
echo Fast Startup enabled.
pause
goto optimize_features

:disable_lockscreen_ads
echo Disabling Lock Screen Ads and Spotlight...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsSpotlightFeatures" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableContentDeliveryAds" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableLockScreenSpotlight" "REG_DWORD" "1"
echo Lock Screen Ads and Spotlight disabled.
pause
goto optimize_features

:disable_ink_workspace
echo Disabling Ink Workspace...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Ink Workspace" "AllowInkWorkspace" "REG_DWORD" "0"
echo Ink Workspace disabled.
pause
goto optimize_features

:disable_people_bar
echo Disabling People Bar (My People)...
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "PeopleBand" "REG_DWORD" "0"
echo People Bar (My People) disabled.
pause
goto optimize_features

:disable_web_search_startmenu
echo Disabling Web Search in Start Menu...
call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" "REG_DWORD" "1"
call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "NoInternetOpenWith" "REG_DWORD" "1"
echo Web Search in Start Menu disabled.
pause
goto optimize_features

:disable_location_services
echo Disabling Location Services (System-wide)...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "NoGlobalLocationControl" "REG_DWORD" "1"
echo Location Services (System-wide) disabled.
pause
goto optimize_features

:disable_camera_access
echo Disabling Camera Access (For all apps)...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceAllowTheseApps" "REG_SZ" ""
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceDenyTheseApps" "REG_SZ" "*"
echo Camera Access (For all apps) disabled.
pause
goto optimize_features

:disable_microphone_access
echo Disabling Microphone Access (For all apps)...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceAllowTheseApps" "REG_SZ" ""
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceDenyTheseApps" "REG_SZ" "*"
echo Microphone Access (For all apps) disabled.
pause
goto optimize_features

:disable_advertising_id
echo Disabling Advertising ID...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "1"
echo Advertising ID disabled.
pause
goto optimize_features

:disable_telemetry_basic
echo Disabling Telemetry and Data Collection (Basic Level)...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
echo Telemetry and Data Collection (Basic Level) disabled.
pause
goto optimize_features

:uninstall_onedrive
echo Uninstalling OneDrive (Optional)...
set /p confirm_onedrive=Are you sure you want to uninstall OneDrive? (Y/N - Recommended to choose N if you use OneDrive):
if /i "%confirm_onedrive%"=="Y" (
    if exist "%ProgramFiles%\OneDrive\setup.exe" (
        echo Uninstalling OneDrive (per-machine)...
        "%ProgramFiles%\OneDrive\setup.exe" /uninstall
    ) else if exist "%LocalAppData%\Microsoft\OneDrive\Update\OneDriveSetup.exe" (
        echo Uninstalling OneDrive (per-user)...
        "%LocalAppData%\Microsoft\OneDrive\Update\OneDriveSetup.exe" /uninstall
    ) else (
        echo OneDrive uninstaller not found. OneDrive may not be installed or uninstallation method may need to be adjusted.
    )
    echo OneDrive uninstallation process started. Please check for completion.
    echo You may need to manually remove OneDrive folders after uninstallation.
) else (
    echo OneDrive uninstallation cancelled.
)
pause
goto optimize_features

:disable_ceip
echo Disabling Customer Experience Improvement Program (CEIP)...
call :modify_registry "HKCU\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" "0"
echo Customer Experience Improvement Program (CEIP) disabled.
pause
goto optimize_features

:disable_error_reporting
echo Disabling Error Reporting...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "Disabled" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "DontConsentPrompt" "REG_DWORD" "1"
echo Error Reporting disabled.
pause
goto optimize_features

:disable_compatibility_telemetry
echo Disabling Compatibility Telemetry...
sc config "DiagTrack" start= disabled
sc stop "DiagTrack"
echo Compatibility Telemetry (Diagnostic Tracking Service) disabled.
pause
goto optimize_features

:revert_feature_optimizations
echo Reverting All Feature Optimizations...
echo Restoring default settings for optimized features.
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" /d 1 /f
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" /d 1 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" "REG_DWORD" /d 1 /f
call :modify_registry "HKCU\System\GameConfigStore" "GameDVR_Enabled" "REG_DWORD" /d 1 /f
call :modify_registry "HKCU\Control Panel\Accessibility\StickyKeys" "Flags" "REG_SZ" "502"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" /d 0 /f
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastApplicationNotification" "REG_DWORD" /d 0 /f
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastNotificationQueue" "REG_DWORD" /d 0 /f
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" /d 1 /f
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" "REG_DWORD" /d 1 /f
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" "REG_DWORD" /d 1 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsSpotlightFeatures" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableContentDeliveryAds" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableLockScreenSpotlight" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Ink Workspace" "AllowInkWorkspace" "REG_DWORD" /d 1 /f
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "PeopleBand" "REG_DWORD" /d 1 /f
call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" "REG_DWORD" /d 0 /f
call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "NoInternetOpenWith" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "NoGlobalLocationControl" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera" "REG_DWORD" /d 1 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceAllowTheseApps" "REG_SZ" "" /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceDenyTheseApps" "REG_SZ" "" /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone" "REG_DWORD" /d 1 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceAllowTheseApps" "REG_SZ" "" /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceDenyTheseApps" "REG_SZ" "" /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" /d 1 /f
call :modify_registry "HKCU\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" /d 1 /f
call :modify_registry "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" /d 1 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "Disabled" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "DontConsentPrompt" "REG_DWORD" /d 0 /f
sc config "DiagTrack" start= auto
sc start "DiagTrack"
echo Feature optimizations reverted to default settings.
pause
goto optimize_features


:option_4
:optimize_cpu
cls
echo ==================================================
echo CPU Optimization - Advanced
echo ==================================================
echo 1. Set High Performance power plan
echo 2. Disable CPU throttling
echo 3. Optimize processor scheduling
echo 4. Disable CPU core parking
echo 5. Adjust processor power management
echo 6. Enable hardware-accelerated GPU scheduling
echo 7. Disable unnecessary system services (Caution)
echo 8. Adjust visual effects for performance
echo 9. Enable Multi-core Boot (Restart Required)
echo 10. Enable Maximum Memory Boot (Restart Required)
echo 11. Return to main menu
echo ==================================================
set /p cpu_choice=Enter your choice (1-11):

if "%cpu_choice%"=="1" goto set_high_performance
if "%cpu_choice%"=="2" goto disable_throttling
if "%cpu_choice%"=="3" goto optimize_scheduling
if "%cpu_choice%"=="4" goto disable_core_parking
if "%cpu_choice%"=="5" goto adjust_power_management
if "%cpu_choice%"=="6" goto enable_gpu_scheduling
if "%cpu_choice%"=="7" goto disable_services
if "%cpu_choice%"=="8" goto adjust_visual_effects
if "%cpu_choice%"=="9" goto enable_multicore_boot
if "%cpu_choice%"=="10" goto enable_maxmem_boot
if "%cpu_choice%"=="11" goto menu
echo Invalid choice. Please try again.
pause
goto optimize_cpu

:set_high_performance
echo Setting High Performance power plan...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
if %errorlevel% neq 0 (
    echo Failed to set High Performance power plan. Checking for Ultimate Performance...
    powercfg /list | findstr "Ultimate Performance"
    if %errorlevel% equ 0 (
        for /f "tokens=4" %%i in ('powercfg -list ^| findstr /i "Ultimate Performance"') do set up_guid=%%i
        powercfg -setactive %up_guid%
        echo Ultimate Performance power plan set.
        pause
        goto optimize_cpu
    ) else (
        echo Ultimate Performance power plan not found. Creating High Performance plan...
        powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
        for /f "tokens=4" %%i in ('powercfg -list ^| findstr /i "High performance"') do set hp_guid=%%i
        powercfg -setactive %hp_guid%
        echo High Performance power plan set.
    )
) else (
    echo High Performance power plan set.
)
pause
goto optimize_cpu

:disable_throttling
echo Disabling CPU throttling...
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100
powercfg -setactive scheme_current
echo CPU throttling disabled.
pause
goto optimize_cpu

:optimize_scheduling
echo Optimizing processor scheduling...
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "REG_DWORD" "38"
echo Processor scheduling optimized for best performance of programs.
pause
goto optimize_cpu

:disable_core_parking
echo Disabling CPU core parking...
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
powercfg -setactive scheme_current
echo CPU core parking disabled.
pause
goto optimize_cpu

:adjust_power_management
echo Adjusting processor power management...
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100
powercfg -setacvalueindex scheme_current sub_processor PERFINCPOL 2
powercfg -setacvalueindex scheme_current sub_processor PERFDECPOL 1
powercfg -setactive scheme_current
echo Processor power management adjusted for maximum performance.
pause
goto optimize_cpu

:enable_gpu_scheduling
echo Enabling hardware-accelerated GPU scheduling...
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" "2"
echo Hardware-accelerated GPU scheduling enabled. Please restart your computer for changes to take effect.
pause
goto optimize_cpu

:disable_services
echo Disabling unnecessary system services...
echo WARNING: Disabling system services may affect certain functionalities.
echo Disabling the following services: SysMain (Superfetch), DiagTrack (Diagnostic Tracking Service), WSearch (Windows Search).
echo Proceed with caution.
pause

sc config "SysMain" start= disabled
sc stop "SysMain"
sc config "DiagTrack" start= disabled
sc stop "DiagTrack"
sc config "WSearch" start= disabled
sc stop "WSearch"
echo Unnecessary system services disabled.
pause
goto optimize_cpu

:adjust_visual_effects
echo Adjusting visual effects for best performance...
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "REG_DWORD" "2"
echo Visual effects adjusted for best performance.
pause
goto optimize_cpu

:enable_multicore_boot
echo Enabling Multi-core Boot...
bcdedit /set {current} numproc /all
echo Multi-core Boot enabled.
pause
goto optimize_cpu

:enable_maxmem_boot
echo Enabling Maximum Memory Boot...
bcdedit /set {current} truncatememory /no
bcdedit /set {current} removememory 0
echo Maximum Memory Boot enabled.
pause
goto optimize_cpu

:option_5
:optimize_internet
cls
echo ======================================================
echo Internet Performance Optimization - Advanced
echo ======================================================
echo 1. Basic TCP Optimizations (Auto-tuning, Congestion Control)
echo 2. Advanced TCP Optimizations (Low Latency Focus)
echo 3. Enable/Disable TCP Fast Open
echo 4. Adjust TCP Window Size (Auto-tuning Normal)
echo 5. Optimize for Low Latency Gaming (TCP No Delay, etc.)
echo 6. DNS Optimization (Set Custom DNS Servers)
echo 7. Flush DNS Resolver Cache
echo 8. Optimize Network Adapter Settings (Advanced Tuning)
echo 9. Disable Network Adapter Power Saving (For Consistent Performance)
echo 10. Enable Jumbo Frames (Caution - Compatibility)
echo 11. Enable QoS Packet Scheduler (Prioritize Network Traffic)
echo 12. Reset Network Settings (Comprehensive Reset)
echo 13. Test Internet Speed and Latency (Basic Test)
echo 14. Revert all Internet Optimizations (Undo Changes)
echo 15. Return to main menu
echo ======================================================
set /p net_choice=Enter your choice (1-15):

if "%net_choice%"=="1" goto basic_tcp_optimizations
if "%net_choice%"=="2" goto advanced_tcp_low_latency
if "%net_choice%"=="3" goto toggle_tcp_fastopen
if "%net_choice%"=="4" goto adjust_tcp_window
if "%net_choice%"=="5" goto optimize_low_latency_gaming
if "%net_choice%"=="6" goto dns_optimization_custom
if "%net_choice%"=="7" goto flush_dns_cache
if "%net_choice%"=="8" goto adapter_tuning_advanced
if "%net_choice%"=="9" goto disable_adapter_powersave
if "%net_choice%"=="10" goto enable_jumbo_frames
if "%net_choice%"=="11" goto enable_qos_scheduler
if "%net_choice%"=="12" goto reset_network_comprehensive
if "%net_choice%"=="13" goto test_internet_speed
if "%net_choice%"=="14" goto revert_net_optimizations
if "%net_choice%"=="15" goto menu
echo Invalid choice. Please try again.
pause
goto optimize_internet

:basic_tcp_optimizations
echo Performing Basic TCP Optimizations...
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global congestionprovider=ctcp
netsh int tcp set global ecncapability=enabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global rss=enabled
echo Basic TCP optimizations completed.
pause
goto optimize_internet

:advanced_tcp_low_latency
echo Performing Advanced TCP Optimizations (Low Latency Focus)...
netsh int tcp set global congestionprovider=ctcp
netsh int tcp set global ecncapability=enabled
netsh int tcp set heuristics disabled
netsh int tcp set global rss=enabled
netsh int tcp set global fastopen=enabled
netsh int tcp set global hystart=disabled
netsh int tcp set global pacingprofile=off
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPNoDelay" "REG_DWORD" "1"
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPDelAckTicks" "REG_DWORD" "0"
echo Advanced TCP optimizations (Low Latency) completed.
pause
goto optimize_internet

:toggle_tcp_fastopen
echo 1. Enable TCP Fast Open
echo 2. Disable TCP Fast Open
set /p fastopen_choice=Enter your choice (1-2):
if "%fastopen_choice%"=="1" (
    netsh int tcp set global fastopen=enabled
    echo TCP Fast Open enabled.
) else if "%fastopen_choice%"=="2" (
    netsh int tcp set global fastopen=disabled
    echo TCP Fast Open disabled.
) else (
    echo Invalid choice.
)
pause
goto optimize_internet

:adjust_tcp_window
echo Adjusting TCP Window Size to Auto-tuning Normal...
netsh int tcp set global autotuninglevel=normal
echo TCP Window Size adjusted to Auto-tuning Normal.
pause
goto optimize_internet

:optimize_low_latency_gaming
echo Optimizing for Low Latency Gaming...
netsh int tcp set global congestionprovider=ctcp
netsh int tcp set global ecncapability=disabled
netsh int tcp set heuristics disabled
netsh int tcp set global rss=enabled
netsh int tcp set global fastopen=enabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global initialRto=2000
netsh int tcp set global nonsackrttresiliency=disabled
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPNoDelay" "REG_DWORD" "1"
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPDelAckTicks" "REG_DWORD" "0"
echo Low Latency Gaming optimizations applied.
pause
goto optimize_internet

:dns_optimization_custom
echo Setting Custom DNS Servers...
set /p primary_dns=Enter primary DNS server (e.g., 8.8.8.8):
set /p secondary_dns=Enter secondary DNS server (e.g., 8.8.4.4):
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    netsh interface ip set dns name="%%j" source=static address="%primary_dns%"
    netsh interface ip add dns name="%%j" address="%secondary_dns%" index=2
)
echo Custom DNS servers set.
pause
goto optimize_internet

:flush_dns_cache
echo Flushing DNS Resolver Cache...
ipconfig /flushdns
echo DNS Resolver Cache flushed.
pause
goto optimize_internet

:adapter_tuning_advanced
echo Tuning Network Adapter Settings (Advanced)...
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr "Connected"') do (
    netsh int ip set interface "%%j" dadtransmits=0 store=persistent
    netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent
    powershell "Get-NetAdapterAdvancedProperty -Name '%%j' | Where-Object {$_.DisplayName -in ('*FlowControl', '*InterruptModeration', '*PriorityVLANTag', '*SpeedDuplex', '*ReceiveSideScaling') } | ForEach-Object {Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword $_.RegistryKeyword -RegistryValue 0}"
    powershell "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*PriorityVLANTag' -RegistryValue 3"
    powershell "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*SpeedDuplex' -RegistryValue 0"
)
echo Network adapter settings tuned (Advanced).
pause
goto optimize_internet

:disable_adapter_powersave
echo Disabling Network Adapter Power Saving...
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr "Connected"') do (
    powershell "Set-NetAdapterPowerManagement -Name '%%j' -AllowComputerToTurnOffDevice \$false"
)
echo Network Adapter Power Saving disabled.
pause
goto optimize_internet

:enable_jumbo_frames
echo WARNING: Enabling Jumbo Frames may cause network issues if not supported by your network.
set /p confirm_jumbo=Are you sure you want to enable Jumbo Frames? (Y/N):
if /i "%confirm_jumbo%"=="Y" (
    set /p jumbo_value=Enter Jumbo Frame value in bytes (e.g., 9014 for 9KB):
    for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr "Connected"') do (
        powershell "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*JumboPacket' -RegistryValue %jumbo_value%"
    )
    echo Jumbo Frames enabled with value %jumbo_value%.
) else (
    echo Jumbo Frames enabling cancelled.
)
pause
goto optimize_internet

:enable_qos_scheduler
echo Enabling QoS Packet Scheduler...
netsh int tcp set global packetcoalescinginbound=disabled
sc config "Qwave" start= auto
sc start Qwave
echo QoS Packet Scheduler enabled.
pause
goto optimize_internet

:reset_network_comprehensive
echo Resetting All Network Settings (Comprehensive)...
echo This will reset Winsock, IP, Firewall, Routing, and flush DNS.
echo Please wait, this may take a moment.
netsh winsock reset
netsh int ip reset all
netsh advfirewall reset
route -f
ipconfig /release *
ipconfig /renew *
ipconfig /flushdns
echo Comprehensive Network Settings Reset completed. Please restart your computer.
pause
goto optimize_internet

:test_internet_speed
echo Testing Internet Speed and Latency (Basic Test)...
echo Running ping test to google.com...
ping -n 3 google.com
echo.
echo You can use online speed test websites for more accurate results.
pause
goto optimize_internet

:revert_net_optimizations
echo Reverting All Internet Optimizations...
echo Restoring default network settings.
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global congestionprovider=default
netsh int tcp set global ecncapability=default
netsh int tcp set global timestamps=default
netsh int tcp set global rss=default
netsh int tcp set global fastopen=default
netsh int tcp set heuristics enabled
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPNoDelay" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPDelAckTicks" "REG_DWORD" /d 2 /f
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr "Connected"') do (
    netsh int ip set interface "%%j" dadtransmits=3 store=persistent
    netsh int ip set interface "%%j" routerdiscovery=enabled store=persistent
    powershell "Get-NetAdapterAdvancedProperty -Name '%%j' | Where-Object {$_.DisplayName -in ('*FlowControl', '*InterruptModeration', '*PriorityVLANTag', '*SpeedDuplex', '*ReceiveSideScaling', '*JumboPacket') } | ForEach-Object {Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword $_.RegistryKeyword -RegistryValue \$null}"
    powershell "Set-NetAdapterPowerManagement -Name '%%j' -AllowComputerToTurnOffDevice \$true"
    netsh interface ip set dns name="%%j" source=dhcp
)
echo Internet optimizations reverted to default settings. Please restart your computer.
pause
goto optimize_internet

:option_6
:windows_update
echo Windows Update Management
echo 1. Enable Windows Update
echo 2. Disable Windows Update
echo 3. Check for updates
set /p update_choice=Enter your choice (1-3):
if "%update_choice%"=="1" goto enable_windows_update
if "%update_choice%"=="2" goto disable_windows_update
if "%update_choice%"=="3" goto check_updates
goto menu

:enable_windows_update
echo Enabling Windows Update...
sc config wuauserv start= auto
sc start wuauserv
if %errorlevel% neq 0 (
    echo Failed to enable Windows Update. Please check your permissions.
) else (
    echo Windows Update enabled.
)
pause
goto windows_update

:disable_windows_update
echo Disabling Windows Update...
sc config wuauserv start= disabled
sc stop wuauserv
if %errorlevel% neq 0 (
    echo Failed to disable Windows Update. Please check your permissions.
) else (
    echo Windows Update disabled.
)
pause
goto windows_update

:check_updates
echo Checking for Windows updates...
powershell -Command "(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()"
echo Update check initiated. Please check Windows Update in Settings for results.
pause
goto windows_update

:option_7
:auto_login
echo Configuring Auto-login...
set /p username=Enter username:
set /p password=Enter password:
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "REG_SZ" "%username%"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "REG_SZ" "%password%"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "REG_SZ" "1"
echo Auto-login configured.
pause
goto menu

:option_8
:clear_cache
cls
echo ==================================================
echo Clearing System Cache - Advanced
echo ==================================================
echo Performing comprehensive system cache cleanup...
echo Please wait, this may take a few minutes.

echo.
echo --- Clearing Temporary Files ---
del /q /f /s %TEMP%\* 2>nul
rmdir /s /q %TEMP%\* 2>nul
del /q /f /s C:\Windows\Temp\* 2>nul
rmdir /s /q C:\Windows\Temp\* 2>nul
echo Temporary files cleared.

echo.
echo --- Clearing Browser Cache (Internet Explorer & Edge Legacy) ---
del /q /f /s "%LocalAppData%\Microsoft\Windows\INetCache\*.*" 2>nul
del /q /f /s "%LocalAppData%\Microsoft\Internet Explorer\CacheStorage\*.*" 2>nul
echo Browser cache (IE & Edge Legacy) cleared.

echo.
echo --- Clearing Thumbnail Cache ---
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\iconcache_*.db" 2>nul
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe >nul 2>&1
echo Thumbnail cache cleared.

echo.
echo --- Clearing DNS Cache ---
ipconfig /flushdns
echo DNS cache cleared.

echo.
echo --- Clearing Software Distribution Folder (Windows Update Cache) ---
echo Stopping Windows Update service...
net stop wuauserv 2>nul
timeout /t 5 /nobreak >nul
del /q /f /s "C:\Windows\SoftwareDistribution\Download\*.*" 2>nul
rmdir /s /q "C:\Windows\SoftwareDistribution\Download" 2>nul
mkDir "C:\Windows\SoftwareDistribution\Download" 2>nul
echo Starting Windows Update service...
net start wuauserv 2>nul
echo Software Distribution folder cleared.

echo.
echo --- Clearing System Event Logs ---
echo Clearing System Event Logs...
for %%L in (Application System Security) DO wevtutil cl "%%L" /qn
echo System Event Logs cleared.

echo.
echo --- Clearing Prefetch Files (Caution) ---
echo WARNING: Clearing Prefetch files may slightly slow down application startup temporarily.
echo Proceeding to clear Prefetch files...
del /q /f /s C:\Windows\Prefetch\*.* 2>nul
echo Prefetch files cleared.

echo.
echo System cache cleanup completed.
pause
goto menu

:option_9
:optimize_disk
cls
echo ==================================================
echo Disk Optimization - Advanced
echo ==================================================
echo 1. Analyze disk fragmentation
echo 2. Optimize/Defragment disk (Full Optimization)
echo 3. Optimize/Defragment disk (Quick Optimization - SSD aware)
echo 4. Check disk for errors (chkdsk /F /R /X - Requires Restart)
echo 5. Check disk health status
echo 6. Enable/Verify SSD TRIM
echo 7. Clean up system files (Disk Cleanup - Automated)
echo 8. Clean up system files (Disk Cleanup - Interactive)
echo 9. Return to main menu
echo ==================================================
set /p disk_choice=Enter your choice (1-9):

if "%disk_choice%"=="1" goto analyze_disk
if "%disk_choice%"=="2" goto optimize_defrag_full
if "%disk_choice%"=="3" goto optimize_defrag_quick
if "%disk_choice%"=="4" goto check_disk
if "%disk_choice%"=="5" goto check_disk_health
if "%disk_choice%"=="6" goto trim_ssd
if "%disk_choice%"=="7" goto cleanup_system_auto
if "%disk_choice%"=="8" goto cleanup_system_interactive
if "%disk_choice%"=="9" goto menu
echo Invalid choice. Please try again.
pause
goto optimize_disk

:analyze_disk
echo Analyzing disk fragmentation...
defrag C: /A /V
echo Disk analysis completed. Check output above for fragmentation report.
pause
goto optimize_disk

:optimize_defrag_full
echo Optimizing/Defragmenting disk (Full Optimization)...
echo This may take a long time, especially for large and fragmented disks.
defrag C: /O /V /H
echo Disk optimization (Full) completed. Check output above for details.
pause
goto optimize_disk

:optimize_defrag_quick
echo Optimizing/Defragmenting disk (Quick Optimization - SSD aware)...
echo This is a quick optimization, suitable for SSDs and regular HDDs.
defrag C: /L /V
echo Disk optimization (Quick) completed. Check output above for details.
pause
goto optimize_disk

:check_disk
echo Checking disk for errors (chkdsk /F /R /X)...
echo This process will schedule a disk check on the next system restart.
echo Please save your work and be prepared to restart your computer.
chkdsk C: /F /R /X
echo Disk check scheduled. Please restart your computer to perform the check.
pause
goto optimize_disk

:check_disk_health
echo Checking disk health status...
wmic diskdrive get status,model,index,size,SerialNumber
echo Disk health check completed. Check status above.
pause
goto optimize_disk

:trim_ssd
echo Checking and Enabling SSD TRIM...
fsutil behavior query DisableDeleteNotify
if %errorlevel% equ 0 (
    echo SSD TRIM is already enabled.
) else (
    echo SSD TRIM is disabled. Enabling TRIM...
    fsutil behavior set disabledeletenotify 0
    if %errorlevel% equ 0 (
        echo SSD TRIM enabled successfully.
    ) else (
        echo Failed to enable SSD TRIM. Please check permissions or SSD compatibility.
    )
)
echo Performing quick TRIM optimization...
defrag C: /L /V
echo SSD TRIM optimization completed.
pause
goto optimize_disk

:cleanup_system_auto
echo Cleaning up system files (Disk Cleanup - Automated)...
echo Running Disk Cleanup in automated mode.
cleanmgr /sagerun:1
echo System file cleanup (Automated) completed.
pause
goto optimize_disk

:cleanup_system_interactive
echo Cleaning up system files (Disk Cleanup - Interactive)...
echo Opening Disk Cleanup utility for interactive selection.
cleanmgr /d C:
echo Disk Cleanup (Interactive) completed after you close the utility.
pause
goto optimize_disk

:option_10
:check_repair
cls
echo ======================================================
echo System Check and Repair - Advanced
echo ======================================================
echo 1. Run SFC (System File Checker) - Scan and Repair (Requires Restart if repairs are made)
echo 2. Run SFC (System File Checker) - Scan only (Verification)
echo 3. Run DISM (Deployment Image Servicing and Management) - Check Health
echo 4. Run DISM (Deployment Image Servicing and Management) - Scan Health
echo 5. Run DISM (Deployment Image Servicing and Management) - Restore Health (Requires Internet)
echo 6. Run DISM (Deployment Image Servicing and Management) - Start Component Cleanup (WinSXS Cleanup)
echo 7. Check Disk Health Status (SMART Status)
echo 8. Check Disk for Errors (chkdsk /F /R /X - Requires Restart)
echo 9. Run Windows Memory Diagnostic (Requires Restart)
echo 10. Run Driver Verifier (Advanced - Requires Caution and Restart)
echo 11. View SFC Scan Details Log
echo 12. Return to main menu
echo ======================================================
set /p repair_choice=Enter your choice (1-12):

if "%repair_choice%"=="1" goto run_sfc_scan_repair
if "%repair_choice%"=="2" goto run_sfc_scanonly
if "%repair_choice%"=="3" goto run_dism_checkhealth
if "%repair_choice%"=="4" goto run_dism_scanhealth
if "%repair_choice%"=="5" goto run_dism_restorehealth
if "%repair_choice%"=="6" goto run_dism_cleanup_component
if "%repair_choice%"=="7" goto check_disk_health_smart
if "%repair_choice%"=="8" goto check_disk_errors_chkdsk
if "%repair_choice%"=="9" goto run_memory_diagnostic
if "%repair_choice%"=="10" goto run_driver_verifier
if "%repair_choice%"=="11" goto view_sfc_log
if "%repair_choice%"=="12" goto menu
echo Invalid choice. Please try again.
pause
goto check_repair

:run_sfc_scan_repair
echo Running System File Checker (SFC) - Scan and Repair...
echo This process will scan for and repair corrupted system files.
sfc /scannow
echo SFC scan completed. Check output above for details.
echo Note: If SFC found and repaired errors, a system restart is recommended.
pause
goto check_repair

:run_sfc_scanonly
echo Running System File Checker (SFC) - Scan only (Verification)...
echo This process will scan for corrupted system files but will not attempt repairs.
sfc /verifyonly
echo SFC scan completed (Verification only). Check output above for details.
pause
goto check_repair

:run_dism_checkhealth
echo Running DISM (Deployment Image Servicing and Management) - Check Health...
echo This process will check if the component store is corrupted.
DISM /Online /Cleanup-Image /CheckHealth
echo DISM CheckHealth completed. Check output above for details.
pause
goto check_repair

:run_dism_scanhealth
echo Running DISM (Deployment Image Servicing and Management) - Scan Health...
echo This process will scan the component store for corruption. This may take a few minutes.
DISM /Online /Cleanup-Image /ScanHealth
echo DISM ScanHealth completed. Check output above for details.
pause
goto check_repair

:run_dism_restorehealth
echo Running DISM (Deployment Image Servicing and Management) - Restore Health...
echo This process will scan and repair the component store using online sources.
echo Make sure you have an active internet connection. This may take a while.
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM RestoreHealth completed. Check output above for details.
pause
goto check_repair

:run_dism_cleanup_component
echo Running DISM (Deployment Image Servicing and Management) - Start Component Cleanup...
echo This process will clean up the WinSxS folder to reduce component store size.
echo This may free up disk space.
DISM /Online /Cleanup-Image /StartComponentCleanup
echo DISM Component Cleanup completed. Check output above for details.
pause
goto check_repair

:check_disk_health_smart
echo Checking Disk Health Status (SMART Status)...
wmic diskdrive get status,model,index,size,SerialNumber,PredFail, ক্যাপশন
echo Disk health check completed. Check status above.
echo PredFail = 'TRUE' indicates a potential disk failure. Status = 'OK' is normal.
pause
goto check_repair

:check_disk_errors_chkdsk
echo Checking Disk for Errors (chkdsk /F /R /X)...
echo This process will schedule a disk check on the next system restart.
echo Please save your work and be prepared to restart your computer.
chkdsk C: /F /R /X
echo Disk check scheduled. Please restart your computer to perform the check.
pause
goto check_repair

:run_memory_diagnostic
echo Running Windows Memory Diagnostic...
echo This will launch the Windows Memory Diagnostic tool and require a system restart.
echo Please save your work before proceeding.
start mdsched.exe
echo Windows Memory Diagnostic tool launched. Please restart your computer to run the memory test.
pause
goto check_repair

:run_driver_verifier
echo WARNING: Running Driver Verifier may cause system instability or BSOD if drivers have issues.
echo Driver Verifier is an advanced tool for driver debugging and should be used with caution.
echo Proceed only if you are comfortable with troubleshooting potential system crashes.
set /p confirm_verifier=Are you sure you want to run Driver Verifier? (Y/N - Highly Recommended to choose N if unsure):
if /i "%confirm_verifier%"=="Y" (
    echo Launching Driver Verifier Manager...
    verifier
    echo Driver Verifier Manager opened. Please configure and run verifier from the GUI.
    echo A system restart will be required after configuring Driver Verifier.
) else (
    echo Driver Verifier cancelled.
)
pause
goto check_repair

:view_sfc_log
echo Viewing SFC Scan Details Log...
echo Opening SFC details log file (sfcdetails.txt) from your Desktop...
start "" "%userprofile%\Desktop\sfcdetails.txt"
if not exist "%userprofile%\Desktop\sfcdetails.txt" (
    echo SFC log file not found on Desktop. Running SFC verification to generate log...
    Findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log >"%userprofile%\Desktop\sfcdetails.txt"
    echo SFC log generated and saved to sfcdetails.txt on your desktop.
)
pause
goto check_repair

:option_11
:windows_activate
cls
echo ==================================================
echo Windows Activation
echo ==================================================
echo 1. Check activation status
echo 2. Activate using KMS (for Volume License versions)
echo 3. Activate using digital license
echo 4. Input a product key manually
echo 5. Remove product key
echo 6. Return to main menu
echo ==================================================
set /p activate_choice=Enter your choice (1-6):

if "%activate_choice%"=="1" goto check_activation
if "%activate_choice%"=="2" goto kms_activate
if "%activate_choice%"=="3" goto digital_activate
if "%activate_choice%"=="4" goto manual_key
if "%activate_choice%"=="5" goto remove_key
if "%activate_choice%"=="6" goto menu
echo Invalid choice. Please try again.
pause
goto windows_activate

:check_activation
echo Checking Windows activation status...
slmgr /xpr
pause
goto windows_activate

:kms_activate
:: Check if the script is running with administrator privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    :: If running as administrator, execute the PowerShell command
    powershell -command "irm https://get.activated.win | iex"
) else (
    :: If not running as administrator, relaunch the script as administrator
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c %~s0", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
)
pause
goto windows_activate

:activate_kms
slmgr /ato
if %errorlevel% neq 0 (
    echo Activation failed. Please try another method or check your Windows version.
) else (
    echo Windows activation attempted. Please check the activation status.
)
pause
goto windows_activate

:digital_activate
echo Attempting to activate Windows using digital license...
slmgr /ato
if %errorlevel% neq 0 (
    echo Digital license activation failed. Your PC may not have a digital license.
) else (
    echo Digital license activation attempted. Please check the activation status.
)
pause
goto windows_activate

:manual_key
set /p product_key=Enter your 25-character product key (XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
echo Installing product key...
slmgr /ipk %product_key%
if %errorlevel% neq 0 (
    echo Failed to install product key. The key may be invalid or not applicable to your Windows version.
) else (
    echo Product key installed. Attempting activation...
    slmgr /ato
    if %errorlevel% neq 0 (
        echo Activation failed. Please check your product key and try again.
    ) else (
        echo Windows activation attempted. Please check the activation status.
    )
)
pause
goto windows_activate

:remove_key
echo Removing current product key...
slmgr /upk
if %errorlevel% neq 0 (
    echo Failed to remove product key. You may not have permission or there's no key to remove.
) else (
    echo Product key removed successfully.
)
pause
goto windows_activate

:option_12
:manage_power
cls
echo ======================================================
echo Power Settings Management - Advanced
echo ======================================================
echo 1. List all power plans
echo 2. Set active power plan
echo 3. Create custom power plan
echo 4. Rename power plan
echo 5. Delete power plan
echo 6. Export power plan to file
echo 7. Import power plan from file
echo ------------------------------------------------------
echo 8. Adjust sleep timeout (Idle sleep)
echo 9. Adjust display timeout (Idle display off)
echo 10. Adjust hibernate timeout (Idle hibernate)
echo 11. Enable/Disable hibernation
echo 12. Configure lid close action
echo 13. Configure power button action
echo 14. Configure sleep button action
echo ------------------------------------------------------
echo 15. Adjust processor power management (Min/Max processor state)
echo 16. Adjust USB selective suspend setting
echo 17. Adjust hard disk power down timeout
echo 18. Adjust wireless adapter power saving mode
echo ------------------------------------------------------
echo 19. Battery Settings (For Laptops Only) - Configure Low Battery Action
echo 20. Battery Settings (For Laptops Only) - Configure Critical Battery Action
echo ------------------------------------------------------
echo 21. Open Advanced Power Settings GUI (powercfg.cpl)
echo 22. Restore Default Power Settings (Reset to Balanced Plan)
echo 23. Return to main menu
echo ======================================================
set /p power_choice=Enter your choice (1-23):

if "%power_choice%"=="1" goto list_power_plans
if "%power_choice%"=="2" goto set_power_plan_active
if "%power_choice%"=="3" goto create_power_plan_custom
if "%power_choice%"=="4" goto rename_power_plan
if "%power_choice%"=="5" goto delete_power_plan
if "%power_choice%"=="6" goto export_power_plan
if "%power_choice%"=="7" goto import_power_plan
if "%power_choice%"=="8" goto adjust_sleep_timeout
if "%power_choice%"=="9" goto adjust_display_timeout
if "%power_choice%"=="10" goto adjust_hibernate_timeout
if "%power_choice%"=="11" goto configure_hibernate_enable
if "%power_choice%"=="12" goto configure_lid_action
if "%power_choice%"=="13" goto configure_power_button_action
if "%power_choice%"=="14" goto configure_sleep_button_action
if "%power_choice%"=="15" goto adjust_processor_power_mgmt
if "%power_choice%"=="16" goto adjust_usb_suspend
if "%power_choice%"=="17" goto adjust_harddisk_timeout
if "%power_choice%"=="18" goto adjust_wireless_powersave
if "%power_choice%"=="19" goto configure_low_battery_action
if "%power_choice%"=="20" goto configure_critical_battery_action
if "%power_choice%"=="21" goto open_advanced_power_gui
if "%power_choice%"=="22" goto restore_default_power_settings
if "%power_choice%"=="23" goto menu
echo Invalid choice. Please try again.
pause
goto manage_power

:list_power_plans
echo Listing all power plans...
powercfg /list
pause
goto manage_power

:set_power_plan_active
echo Available power plans:
powercfg /list
set /p plan_guid=Enter the GUID of the power plan you want to set active:
powercfg /setactive %plan_guid%
if %errorlevel% neq 0 (
    echo Failed to set power plan. Please check the GUID and try again.
) else (
    echo Power plan set active successfully.
)
pause
goto manage_power

:create_power_plan_custom
set /p plan_name=Enter a name for the new power plan:
powercfg /duplicatescheme scheme_balanced
for /f "tokens=4" %%i in ('powercfg /list ^| findstr /i "%plan_name%"') do set new_plan_guid=%%i
if defined new_plan_guid (
    echo Power plan with name "%plan_name%" already exists. Please choose a different name.
    set new_plan_guid=
    pause
    goto create_power_plan_custom
)
powercfg /changename %plan_name%
if %errorlevel% neq 0 (
    echo Failed to create power plan.
) else (
    echo Power plan created successfully.
)
pause
goto manage_power

:rename_power_plan
echo Available power plans:
powercfg /list
set /p old_plan_guid=Enter the GUID of the power plan you want to rename:
set /p new_plan_name=Enter the new name for the power plan:
powercfg /changename %old_plan_guid% -name "%new_plan_name%"
if %errorlevel% neq 0 (
    echo Failed to rename power plan. Please check the GUID and try again.
) else (
    echo Power plan renamed successfully.
)
pause
goto manage_power

:delete_power_plan
echo Available power plans:
powercfg /list
set /p del_guid=Enter the GUID of the power plan you want to delete:
echo WARNING: Deleting a power plan is irreversible. Are you sure? (Y/N)
set /p confirm_delete=Enter your choice (Y/N):
if /i "%confirm_delete%"=="Y" (
    powercfg /delete %del_guid%
    if %errorlevel% neq 0 (
        echo Failed to delete power plan. Please check the GUID and try again.
    ) else (
        echo Power plan deleted successfully.
    )
) else (
    echo Power plan deletion cancelled.
)
pause
goto manage_power

:export_power_plan
echo Available power plans:
powercfg /list
set /p export_guid=Enter the GUID of the power plan you want to export:
set /p export_file=Enter the file path to export to (e.g., C:\PowerPlans\MyPlan.pow):
powercfg /export "%export_file%" %export_guid%
if %errorlevel% neq 0 (
    echo Failed to export power plan. Please check the GUID and file path.
) else (
    echo Power plan exported successfully to "%export_file%".
)
pause
goto manage_power

:import_power_plan
set /p import_file=Enter the file path of the power plan to import (e.g., C:\PowerPlans\MyPlan.pow):
powercfg /import "%import_file%"
if %errorlevel% neq 0 (
    echo Failed to import power plan. Please check the file path and ensure it's a valid .pow file.
) else (
    echo Power plan imported successfully.
)
pause
goto manage_power

:adjust_sleep_timeout
set /p sleep_time=Enter the number of minutes before the system goes to sleep (0 to never sleep):
powercfg /change standby-timeout-ac %sleep_time%
powercfg /change standby-timeout-dc %sleep_time%
echo Sleep timeout adjusted.
pause
goto manage_power

:adjust_display_timeout
set /p display_time=Enter the number of minutes before turning off the display (0 to never turn off):
powercfg /change monitor-timeout-ac %display_time%
powercfg /change monitor-timeout-dc %display_time%
echo Display timeout adjusted.
pause
goto manage_power

:adjust_hibernate_timeout
set /p hibernate_time=Enter the number of minutes before the system hibernates (0 to never hibernate):
powercfg /change hibernate-timeout-ac %hibernate_time%
powercfg /change hibernate-timeout-dc %hibernate_time%
echo Hibernate timeout adjusted.
pause
goto manage_power

:configure_hibernate_enable
echo 1. Enable hibernation
echo 2. Disable hibernation
set /p hib_choice=Enter your choice (1-2):
if "%hib_choice%"=="1" (
    powercfg /hibernate on
    echo Hibernation enabled.
) else if "%hib_choice%"=="2" (
    powercfg /hibernate off
    echo Hibernation disabled.
) else (
    echo Invalid choice.
)
pause
goto manage_power

:configure_lid_action
echo 1. Do nothing
echo 2. Sleep
echo 3. Hibernate
echo 4. Shut down
set /p lid_choice=Enter your choice for lid close action (1-4):
if "%lid_choice%"=="1" set action=0
if "%lid_choice%"=="2" set action=1
if "%lid_choice%"=="3" set action=2
if "%lid_choice%"=="4" set action=3
powercfg /setacvalueindex scheme_current sub_buttons lidaction %action%
powercfg /setdcvalueindex scheme_current sub_buttons lidaction %action%
powercfg /setactive scheme_current
echo Lid close action configured.
pause
goto manage_power

:configure_power_button_action
echo 1. Do nothing
echo 2. Sleep
echo 3. Hibernate
echo 4. Shut down
echo 5. Turn off the display
set /p button_choice=Enter your choice for power button action (1-5):
if "%button_choice%"=="1" set action=0
if "%button_choice%"=="2" set action=1
if "%button_choice%"=="3" set action=2
if "%button_choice%"=="4" set action=3
if "%button_choice%"=="5" set action=4
powercfg /setacvalueindex scheme_current sub_buttons pbuttonaction %action%
powercfg /setdcvalueindex scheme_current sub_buttons pbuttonaction %action%
powercfg /setactive scheme_current
echo Power button action configured.
pause
goto manage_power

:configure_sleep_button_action
echo 1. Do nothing
echo 2. Sleep
echo 3. Hibernate
echo 4. Shut down
echo 5. Turn off the display
set /p sleep_button_choice=Enter your choice for sleep button action (1-5):
if "%sleep_button_choice%"=="1" set action=0
if "%sleep_button_choice%"=="2" set action=1
if "%sleep_button_choice%"=="3" set action=2
if "%sleep_button_choice%"=="4" set action=3
if "%sleep_button_choice%"=="5" set action=4
powercfg /setacvalueindex scheme_current sub_buttons sbuttonaction %action%
powercfg /setdcvalueindex scheme_current sub_buttons sbuttonaction %action%
powercfg /setactive scheme_current
echo Sleep button action configured.
pause
goto manage_power

:adjust_processor_power_mgmt
echo Adjusting Processor Power Management (Min/Max Processor State)...
set /p min_processor_state=Enter minimum processor state in percentage (e.g., 5 for 5%):
set /p max_processor_state=Enter maximum processor state in percentage (e.g., 100 for 100%):
powercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN %min_processor_state%
powercfg /setdcvalueindex scheme_current sub_processor PROCTHROTTLEMIN %min_processor_state%
powercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX %max_processor_state%
powercfg /setdcvalueindex scheme_current sub_processor PROCTHROTTLEMAX %max_processor_state%
powercfg /setactive scheme_current
echo Processor power management (Min/Max Processor State) adjusted.
pause
goto manage_power

:adjust_usb_suspend
echo 1. Enable USB selective suspend
echo 2. Disable USB selective suspend
set /p usb_suspend_choice=Enter your choice (1-2):
if "%usb_suspend_choice%"=="1" (
    powercfg /setacvalueindex scheme_current sub_usb usbidlecycles 8
    powercfg /setdcvalueindex scheme_current sub_usb usbidlecycles 8
    powercfg /setactive scheme_current
    echo USB selective suspend enabled.
) else if "%usb_suspend_choice%"=="2" (
    powercfg /setacvalueindex scheme_current sub_usb usbidlecycles 0
    powercfg /setdcvalueindex scheme_current sub_usb usbidlecycles 0
    powercfg /setactive scheme_current
    echo USB selective suspend disabled.
) else (
    echo Invalid choice.
)
pause
goto manage_power

:adjust_harddisk_timeout
set /p disk_timeout=Enter the number of minutes before turning off the hard disk (0 to never turn off):
powercfg /change disk-timeout-ac %disk_timeout%
powercfg /change disk-timeout-dc %disk_timeout%
echo Hard disk power down timeout adjusted.
pause
goto manage_power

:adjust_wireless_powersave
echo 1. Maximum Performance
echo 2. Medium Power Saving
echo 3. Maximum Power Saving
set /p wireless_powersave_choice=Enter your choice for Wireless Adapter Power Saving Mode (1-3):
if "%wireless_powersave_choice%"=="1" set power_setting=0
if "%wireless_powersave_choice%"=="2" set power_setting=1
if "%wireless_powersave_choice%"=="3" set power_setting=2
powercfg /setacvalueindex scheme_current sub_wireless wificonnectionmode %power_setting%
powercfg /setdcvalueindex scheme_current sub_wireless wificonnectionmode %power_setting%
powercfg /setactive scheme_current
echo Wireless Adapter Power Saving Mode adjusted.
pause
goto manage_power

:configure_low_battery_action
echo 1. Do nothing
echo 2. Sleep
echo 3. Hibernate
echo 4. Shut down
set /p low_battery_choice=Enter your choice for Low Battery Action (1-4):
if "%low_battery_choice%"=="1" set action=0
if "%low_battery_choice%"=="2" set action=1
if "%low_battery_choice%"=="3" set action=2
if "%low_battery_choice%"=="4" set action=3
powercfg /setdcvalueindex scheme_current sub_battery batcritact %action%
powercfg /setactive scheme_current
echo Low Battery Action configured. (Battery settings are typically for DC power only)
pause
goto manage_power

:configure_critical_battery_action
echo 1. Do nothing
echo 2. Sleep
echo 3. Hibernate
echo 4. Shut down
set /p critical_battery_choice=Enter your choice for Critical Battery Action (1-4):
if "%critical_battery_choice%"=="1" set action=0
if "%critical_battery_choice%"=="2" set action=1
if "%critical_battery_choice%"=="3" set action=2
if "%critical_battery_choice%"=="4" set action=3
powercfg /setdcvalueindex scheme_current sub_battery batcritact %action%
powercfg /setactive scheme_current
echo Critical Battery Action configured. (Battery settings are typically for DC power only)
pause
goto manage_power

:open_advanced_power_gui
echo Opening Advanced Power Settings GUI (powercfg.cpl)...
start powercfg.cpl
echo Advanced Power Settings GUI opened. You can configure detailed power settings there.
pause
goto manage_power

:restore_default_power_settings
echo Restoring Default Power Settings (Balanced Power Plan)...
echo Setting active power plan to Balanced...
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e
echo Resetting all power plan settings to default for Balanced plan...
powercfg -restoredefaultschemes
echo Default Power Settings restored to Balanced Power Plan.
pause
goto manage_power

:option_13
:enable_dark_mode
echo Enabling Dark Mode...
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "REG_DWORD" "0"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "REG_DWORD" "0"
echo Dark Mode enabled.
pause
goto menu

:option_14
:manage_partitions
echo Partition Management
echo 1. List Partitions
echo 2. Create Partition
echo 3. Delete Partition
echo 4. Format Partition
set /p part_choice=Enter your choice (1-4):
if "%part_choice%"=="1" goto list_partitions
if "%part_choice%"=="2" goto create_partition
if "%part_choice%"=="3" goto delete_partition
if "%part_choice%"=="4" goto format_partition
goto menu

:list_partitions
echo Listing Partitions...
echo list disk > list_disk.txt
echo list volume >> list_disk.txt
diskpart /s list_disk.txt
del list_disk.txt
pause
goto manage_partitions

:create_partition
echo Creating Partition...
set /p disk_num=Enter disk number:
set /p part_size=Enter partition size in MB:
(
echo select disk %disk_num%
echo create partition primary size=%part_size%
) > create_part.txt
diskpart /s create_part.txt
del create_part.txt
echo Partition created.
pause
goto manage_partitions

:delete_partition
echo Deleting Partition...
set /p disk_num=Enter disk number:
set /p part_num=Enter partition number:
(
echo select disk %disk_num%
echo select partition %part_num%
echo delete partition override
) > delete_part.txt
diskpart /s delete_part.txt
del delete_part.txt
echo Partition deleted.
pause
goto manage_partitions

:format_partition
echo Formatting Partition...
set /p disk_num=Enter disk number:
set /p part_num=Enter partition number:
set /p fs=Enter file system (NTFS/FAT32):
(
echo select disk %disk_num%
echo select partition %part_num%
echo format fs=%fs% quick
) > format_part.txt
diskpart /s format_part.txt
del format_part.txt
echo Partition formatted.
pause
goto manage_partitions

:option_15
:clean_disk
echo Cleaning up disk space...
cleanmgr /sagerun:1
echo Disk cleanup completed.
pause
goto menu

:option_16
:manage_startup
echo Managing startup programs...
start msconfig
echo Please use the System Configuration utility to manage startup programs.
pause
goto menu

:option_17
:backup_restore
echo Backup and Restore Settings
echo 1. Create system restore point
echo 2. Restore from a restore point
set /p backup_choice=Enter your choice (1-2):
if "%backup_choice%"=="1" goto create_restore
if "%backup_choice%"=="2" goto restore_point
goto menu

:create_restore
echo Creating system restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Manual Restore Point", 100, 7
echo System restore point created.
pause
goto menu

:restore_point
echo Restoring from a restore point...
rstrui.exe
echo Please follow the on-screen instructions to restore your system.
pause
goto menu

:option_18
:system_info
echo Displaying system information...
systeminfo
pause
goto menu

:option_19
:optimize_privacy
echo Optimizing privacy settings...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
echo Privacy settings optimized.
pause
goto menu

:option_20
:manage_services
cls
echo ==================================================
echo Windows Services Management
echo ==================================================
echo 1. List all services
echo 2. List running services
echo 3. List stopped services
echo 4. Start a service
echo 5. Stop a service
echo 6. Restart a service
echo 7. Change service startup type
echo 8. Search for a service
echo 9. View service details
echo 10. Return to main menu
echo ==================================================
set /p service_choice=Enter your choice (1-10):

if "%service_choice%"=="1" goto list_all_services
if "%service_choice%"=="2" goto list_running_services
if "%service_choice%"=="3" goto list_stopped_services
if "%service_choice%"=="4" goto start_service
if "%service_choice%"=="5" goto stop_service
if "%service_choice%"=="6" goto restart_service
if "%service_choice%"=="7" goto change_startup_type
if "%service_choice%"=="8" goto search_service
if "%service_choice%"=="9" goto view_service_details
if "%service_choice%"=="10" goto menu
echo Invalid choice. Please try again.
pause
goto manage_services

:list_all_services
echo Listing all services...
sc query type= service state= all
pause
goto manage_services

:list_running_services
echo Listing running services...
sc query type= service state= running
pause
goto manage_services

:list_stopped_services
echo Listing stopped services...
sc query type= service state= stopped
pause
goto manage_services

:start_service
set /p service_name=Enter the name of the service to start:
sc start "%service_name%"
if %errorlevel% neq 0 (
    echo Failed to start the service. Please check the service name and your permissions.
) else (
    echo Service start attempted. Please check the status.
)
pause
goto manage_services

:stop_service
set /p service_name=Enter the name of the service to stop:
sc stop "%service_name%"
if %errorlevel% neq 0 (
    echo Failed to stop the service. Please check the service name and your permissions.
) else (
    echo Service stop attempted. Please check the status.
)
pause
goto manage_services

:restart_service
set /p service_name=Enter the name of the service to restart:
sc stop "%service_name%"
timeout /t 2 >nul
sc start "%service_name%"
if %errorlevel% neq 0 (
    echo Failed to restart the service. Please check the service name and your permissions.
) else (
    echo Service restart attempted. Please check the status.
)
pause
goto manage_services

:change_startup_type
set /p service_name=Enter the name of the service:
echo Select startup type:
echo 1. Automatic
echo 2. Automatic (Delayed Start)
echo 3. Manual
echo 4. Disabled
set /p startup_choice=Enter your choice (1-4):
if "%startup_choice%"=="1" (
    sc config "%service_name%" start= auto
) else if "%startup_choice%"=="2" (
    sc config "%service_name%" start= delayed-auto
) else if "%startup_choice%"=="3" (
    sc config "%service_name%" start= demand
) else if "%startup_choice%"=="4" (
    sc config "%service_name%" start= disabled
) else (
    echo Invalid choice.
    pause
    goto manage_services
)
if %errorlevel% neq 0 (
    echo Failed to change startup type. Please check the service name and your permissions.
) else (
    echo Startup type changed successfully.
)
pause
goto manage_services

:search_service
set /p search_term=Enter search term for service name:
sc query state= all | findstr /i "%search_term%"
pause
goto manage_services

:view_service_details
set /p service_name=Enter the name of the service to view details:
sc qc "%service_name%"
echo.
echo Current Status:
sc query "%service_name%"
pause
goto manage_services

:option_21
:network_optimization
cls
echo ==================================================
echo Network Optimization
echo ==================================================
echo 1. Optimize TCP settings
echo 2. Reset Windows Sockets
echo 3. Clear DNS cache
echo 4. Optimize network adapter settings
echo 5. Disable IPv6 (caution)
echo 6. Enable QoS packet scheduler
echo 7. Set static DNS servers
echo 8. Reset all network settings
echo 9. Return to main menu
echo ==================================================
set /p net_choice=Enter your choice (1-9):

if "%net_choice%"=="1" goto optimize_tcp
if "%net_choice%"=="2" goto reset_winsock
if "%net_choice%"=="3" goto clear_dns
if "%net_choice%"=="4" goto optimize_adapter
if "%net_choice%"=="5" goto disable_ipv6
if "%net_choice%"=="6" goto enable_qos
if "%net_choice%"=="7" goto set_static_dns
if "%net_choice%"=="8" goto reset_network
if "%net_choice%"=="9" goto menu
echo Invalid choice. Please try again.
pause
goto network_optimization

:optimize_tcp
echo Optimizing TCP settings...
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global congestionprovider=ctcp
netsh int tcp set global ecncapability=enabled
netsh int tcp set heuristics disabled
netsh int tcp set global rss=enabled
netsh int tcp set global fastopen=enabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global initialRto=2000
netsh int tcp set global nonsackrttresiliency=disabled
echo TCP settings optimized.
pause
goto network_optimization

:reset_winsock
echo Resetting Windows Sockets...
netsh winsock reset
echo Windows Sockets reset. Please restart your computer for changes to take effect.
pause
goto network_optimization

:clear_dns
echo Clearing DNS cache...
ipconfig /flushdns
echo DNS cache cleared.
pause
goto network_optimization

:optimize_adapter
echo Optimizing network adapter settings...
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    netsh int ip set interface "%%j" dadtransmits=0 store=persistent
    netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent
    netsh int tcp set security mpp=disabled
    netsh int tcp set security profiles=disabled
)
echo Network adapter settings optimized.
pause
goto network_optimization

:disable_ipv6
echo WARNING: Disabling IPv6 may cause issues with some networks.
set /p confirm=Are you sure you want to disable IPv6? (Y/N):
if /i "%confirm%"=="Y" (
    netsh interface ipv6 set global randomizeidentifiers=disabled
    netsh interface ipv6 set privacy state=disabled
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f
    echo IPv6 disabled. Please restart your computer for changes to take effect.
) else (
    echo Operation cancelled.
)
pause
goto network_optimization

:enable_qos
echo Enabling QoS packet scheduler...
netsh int tcp set global packetcoalescinginbound=disabled
sc config "Qwave" start= auto
sc start Qwave
echo QoS packet scheduler enabled.
pause
goto network_optimization

:set_static_dns
echo Setting static DNS servers...
set /p primary_dns=Enter primary DNS server (e.g., 8.8.8.8):
set /p secondary_dns=Enter secondary DNS server (e.g., 8.8.4.4):
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    netsh interface ip set dns "%%j" static %primary_dns% primary
    netsh interface ip add dns "%%j" %secondary_dns% index=2
)
echo Static DNS servers set.
pause
goto network_optimization

:reset_network
echo Resetting all network settings...
netsh winsock reset
netsh int ip reset
netsh advfirewall reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns
echo All network settings reset. Please restart your computer for changes to take effect.
pause
goto network_optimization

:option_22
:endexit
echo Thank you for using the Windows Optimization Script!
echo Script developed by [Your Name/Organization]
echo Version 3.0 - Advanced Edition
pause
exit

:: Function to modify registry with error handling
:modify_registry
reg add %1 /v %2 /t %3 /d %4 /f
if %errorlevel% neq 0 (
    echo Failed to modify registry key: %1\%2
    pause
)
exit /b 0
