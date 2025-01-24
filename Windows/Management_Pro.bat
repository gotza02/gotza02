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
@echo off
color 0a

echo =======================================================================
echo.
echo       ___  ____     ____  __  __ _   ___  ____  __   ____   __  
echo      / __)(_  _)  / ___)(  )(  ( \ / __)(_  _)/ _\ (  _ \ /  \ 
echo     ( (_ \  )(    \___ \ )( /    /( (_ \  )( /    \ )   /(  O )
echo      \___/ (__)   (____/(__)\_)__) \___/ (__)\_/\_/(__\_) \__/ 
echo.
echo =======================================================================
echo.
echo         Windows Optimization Script v3.0 - Advanced Edition
echo.
echo =======================================================================

timeout /t 5 /nobreak > nul
title Windows Optimization Script v3.0 - Advanced Edition

echo ====================================
echo Windows Optimization Script v3.0
echo ====================================
echo Please select an option:
echo ====================================

echo 1. Optimize display performance
echo 2. Manage Windows Defender
echo 3. Optimize Windows Features (Advanced)
echo 4. Optimize CPU (Advanced)
echo 5. Optimize Internet (Advanced)
echo 6. Manage Windows Update
echo 7. Configure Auto-login
echo 8. Clear System Cache (Advanced)
echo 9. Optimize Disk (Advanced)
echo 10. System Check and Repair (Advanced)
echo 11. Windows Activation
echo 12. Manage Power Settings (Advanced)
echo 13. Enable/Disable Dark Mode
echo 14. Manage Partitions (DISKPART)
echo 15. Clean Up Disk Space (DISKCLEANUP)
echo 16. Manage Startup Programs (MSCONFIG)
echo 17. Backup and Restore Settings
echo 18. System Information
echo 19. Optimize Privacy Settings
echo 20. Manage Windows Services
echo 21. Optimize Network
echo 22. Exit

echo ====================================

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
echo ===================================================================
echo             Windows Defender Management - Advanced
echo ===================================================================
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
echo 12. Manage Exclusions
echo     12.1. Add File Exclusion
echo     12.2. Add Folder Exclusion
echo     12.3. Remove Exclusion (by Path)
echo     12.4. List All Exclusions
echo 13. Manage Controlled Folder Access (Enable/Disable)
echo 14. View Quarantined Threats
echo 15. Return to Main Menu
echo ===================================================================
set /p def_choice=Enter your choice (1-15):

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
if "%def_choice%"=="12" goto manage_exclusions_menu
if "%def_choice%"=="13" goto manage_controlled_folder_access
if "%def_choice%"=="14" goto view_quarantined_threats
if "%def_choice%"=="15" goto menu
echo Invalid choice. Please try again.
pause
goto manage_defender

:manage_exclusions_menu
cls
echo ==================================================
echo             Manage Windows Defender Exclusions
echo ==================================================
echo 1. Add File Exclusion
echo 2. Add Folder Exclusion
echo 3. Remove Exclusion (by Path)
echo 4. List All Exclusions
echo 5. Return to Windows Defender Management Menu
echo ==================================================
set /p exclusion_choice=Enter your choice (1-5):

if "%exclusion_choice%"=="1" goto add_file_exclusion
if "%exclusion_choice%"=="2" goto add_folder_exclusion
if "%exclusion_choice%"=="3" goto remove_exclusion
if "%exclusion_choice%"=="4" goto list_exclusions
if "%exclusion_choice%"=="5" goto manage_defender
echo Invalid choice. Please try again.
pause
goto manage_exclusions_menu

:add_file_exclusion
cls
echo ==================================================
echo              Add File Exclusion
echo ==================================================
set /p exclusion_path=Enter the full path to the file to exclude:
if not exist "%exclusion_path%" (
    echo Error: File path does not exist. Please enter a valid file path.
    pause
    goto manage_exclusions_menu
)
powershell -Command "Add-MpPreference -ExclusionPath '%exclusion_path%'"
if %errorlevel% equ 0 (
    echo File exclusion added successfully: "%exclusion_path%"
) else (
    echo Error adding file exclusion. Error Code: %errorlevel%
    echo Please check permissions and ensure path is correct.
)
pause
goto manage_exclusions_menu

:add_folder_exclusion
cls
echo ==================================================
echo              Add Folder Exclusion
echo ==================================================
set /p exclusion_path=Enter the full path to the folder to exclude:
if not exist "%exclusion_path%" (
    echo Error: Folder path does not exist. Please enter a valid folder path.
    pause
    goto manage_exclusions_menu
)
powershell -Command "Add-MpPreference -ExclusionPath '%exclusion_path%'"
if %errorlevel% equ 0 (
    echo Folder exclusion added successfully: "%exclusion_path%"
) else (
    echo Error adding folder exclusion. Error Code: %errorlevel%
    echo Please check permissions and ensure path is correct.
)
pause
goto manage_exclusions_menu

:remove_exclusion
cls
echo ==================================================
echo              Remove Exclusion (by Path)
echo ==================================================
set /p exclusion_path=Enter the full path of the exclusion to remove:
powershell -Command "Remove-MpPreference -ExclusionPath '%exclusion_path%'"
if %errorlevel% equ 0 (
    echo Exclusion removed successfully for path: "%exclusion_path%"
) else (
    echo Error removing exclusion. Error Code: %errorlevel%
    echo Exclusion path may not exist or error occurred.
)
pause
goto manage_exclusions_menu

:list_exclusions
cls
echo ==================================================
echo              List All Exclusions
echo ==================================================
echo Listing all Windows Defender exclusions...
powershell -Command "Get-MpPreference | Select-Object ExclusionPath | Format-List"
if %errorlevel% neq 0 (
    echo.
    echo Error listing exclusions. Error Code: %errorlevel%
    echo Please ensure PowerShell is working correctly.
) else (
    echo.
    echo Exclusion list displayed above.
)
pause
goto manage_exclusions_menu

:manage_controlled_folder_access
cls
echo ==================================================
echo         Manage Controlled Folder Access
echo ==================================================
echo 1. Check Controlled Folder Access Status
echo 2. Enable Controlled Folder Access
echo 3. Disable Controlled Folder Access
echo 4. Return to Windows Defender Management Menu
echo ==================================================
set /p cfa_choice=Enter your choice (1-4):

if "%cfa_choice%"=="1" goto check_cfa_status
if "%cfa_choice%"=="2" goto enable_cfa
if "%cfa_choice%"=="3" goto disable_cfa
if "%cfa_choice%"=="4" goto manage_defender
echo Invalid choice. Please try again.
pause
goto manage_controlled_folder_access

:check_cfa_status
echo Checking Controlled Folder Access Status...
powershell -Command "Get-MpPreference | Select-Object EnableControlledFolderAccess"
pause
goto manage_controlled_folder_access

:enable_cfa
echo Enabling Controlled Folder Access...
powershell -Command "Set-MpPreference -EnableControlledFolderAccess Enabled"
if %errorlevel% equ 0 (
    echo Controlled Folder Access Enabled.
) else (
    echo Error enabling Controlled Folder Access. Error Code: %errorlevel%
)
pause
goto manage_controlled_folder_access

:disable_cfa
echo Disabling Controlled Folder Access...
echo WARNING: Disabling Controlled Folder Access may reduce ransomware protection.
set /p disable_cfa_confirm=Are you sure you want to DISABLE Controlled Folder Access? (Type YES to confirm):
if /i "%disable_cfa_confirm%"=="YES" (
    powershell -Command "Set-MpPreference -EnableControlledFolderAccess Disabled"
    if %errorlevel% equ 0 (
        echo Controlled Folder Access Disabled.
    ) else (
        echo Error disabling Controlled Folder Access. Error Code: %errorlevel%
    )
) else (
    echo Disabling Controlled Folder Access Cancelled.
)
pause
goto manage_controlled_folder_access

:view_quarantined_threats
cls
echo ==================================================
echo             View Quarantined Threats
echo ==================================================
echo Displaying quarantined threats from Windows Defender...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -GetFiles -path \ProgramData\Microsoft\Windows Defender\Quarantine
if %errorlevel% equ 0 (
    echo.
    echo Quarantined Threats Displayed Above. Check the output for details.
    echo Note: This may show file paths, not actual file names in some cases.
) else (
    echo.
    echo Error: Failed to retrieve Quarantined Threats. Error Code: %errorlevel%
    echo Please check Windows Defender and system logs for more details.
)
pause
goto manage_defender

:check_defender
:: (Code เดิมจาก Option 2 - check_defender)
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
:: (Code เดิมจาก Option 2 - enable_defender)
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
:: (Code เดิมจาก Option 2 - disable_defender)
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
:: (Code เดิมจาก Option 2 - update_defender)
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
:: (Code เดิมจาก Option 2 - quick_scan)
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
:: (Code เดิมจาก Option 2 - full_scan)
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
:: (Code เดิมจาก Option 2 - manage_realtime)
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
:: (Code เดิมจาก Option 2 - manage_cloud)
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
:: (Code เดิมจาก Option 2 - manage_samples)
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
:: (Code เดิมจาก Option 2 - manage_pua)
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
:: (Code เดิมจาก Option 2 - view_history)
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
:: (Code เดิมจาก Option 2 - registry_error)
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
echo "=============================================================="
echo "                 CPU Optimization - Advanced & Comprehensive"
echo "             [ Optimized for Windows 10 & Windows 11 ]"
echo "=============================================================="
echo " Advanced CPU optimization for maximum performance on Windows 10 & 11."
echo "=============================================================="
echo "WARNING: Incorrect settings can cause system instability."
echo "         Understand each option before applying."
echo "=============================================================="

echo "Select an optimization category:"
echo "=============================================================="
echo "1. Power Management"
echo "2. Scheduling & Responsiveness"
echo "3. Core Parking & Services"
echo "4. Visual Effects"
echo "5. Boot Performance"
echo "--------------------------------------------------------------"
echo "6. Comprehensive CPU Optimization (Advanced)"
echo "7. Revert All CPU Optimizations"
echo "--------------------------------------------------------------"
echo "8. Display Current CPU Settings"
echo "9. Advanced Performance Tools"
echo "--------------------------------------------------------------"
echo "10. Return to Main Menu"
echo "=============================================================="
set /p cpu_category_choice=Enter choice (1-10):

:: Validate user input
if not "%cpu_category_choice%"=="" (
    if %cpu_category_choice% geq 1 if %cpu_category_choice% leq 10 (
        goto cpu_category_option_%cpu_category_choice%
    )
)

:: If invalid choice, prompt again
echo "Invalid choice. Try again."
pause
goto optimize_cpu


:cpu_category_option_1
:cpu_power_management
cls
echo "=============================================================="
echo "            CPU Optimization - Power Management"
echo "=============================================================="
echo " Optimize CPU power settings for better performance."
echo "=============================================================="
echo "1. Set High Performance Plan (Desktops)"
echo "2. Set Ultimate Performance Plan (If Available - Windows 11 Recommended)"
echo "3. Disable CPU Throttling (Max Performance - May Increase Heat)"
echo "4. Aggressive Performance Boost Mode"
echo "5. Adjust Processor State (Min/Max Power)"
echo "--------------------------------------------------------------"
echo "6. Revert Power Management Optimizations"
echo "7. Return to CPU Optimization Menu"
echo "=============================================================="
set /p cpu_power_choice=Enter choice (1-7):

if "%cpu_power_choice%"=="1" goto set_high_performance
if "%cpu_power_choice%"=="2" goto set_ultimate_performance
if "%cpu_power_choice%"=="3" goto disable_throttling
if "%cpu_power_choice%"=="4" goto adjust_power_management
if "%cpu_power_choice%"=="5" goto adjust_processor_state
if "%cpu_power_choice%"=="6" goto revert_power_management_optimizations
if "%cpu_power_choice%"=="7" goto optimize_cpu
echo "Invalid choice. Try again."
pause
goto cpu_power_management

:set_ultimate_performance
echo "Setting Ultimate Performance Power Plan..."
:: Check if Ultimate Performance plan exists, if not, create it.
powercfg /list | findstr /C:"Ultimate Performance" > nul
if %errorlevel% neq 0 (
    echo "Ultimate Performance plan not found. Creating..."
    powercfg -duplicatescheme e9a42b02-d5df-44c8-aa00-0003f1474963
)
echo "Setting active power plan to Ultimate Performance..."
powercfg -setactive e9a42b02-d5df-44c8-aa00-0003f1474963
echo "Ultimate Performance plan set."
pause
goto cpu_power_management


:set_high_performance
echo "Setting High Performance Power Plan..."
echo "Setting active power plan to High Performance..."
powercfg -setactive 8c5e7fda-e8bf-4a96-94b6-fe8dd03c9a8c
echo "High Performance plan set."
pause
goto cpu_power_management


:disable_throttling
echo "Disabling CPU Throttling..."
powercfg -attributes SUB_PROCESSOR PROCTHROTTLEMAX -ATTRIB_HIDE
powercfg -attributes SUB_PROCESSOR PROCTHROTTLEMIN -ATTRIB_HIDE
powercfg -setacvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -setdcvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -setacvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMIN 0
powercfg -setdcvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMIN 0
powercfg -SetActive scheme_current
echo "CPU Throttling disabled."
pause
goto cpu_power_management


:adjust_power_management
echo "Setting Performance Boost Mode to Aggressive..."
powercfg -attributes SUB_PROCESSOR PERFBOOSTMODE -ATTRIB_HIDE
powercfg -setacvalueindex scheme_current SUB_PROCESSOR PERFBOOSTMODE aggressive
powercfg -setdcvalueindex scheme_current SUB_PROCESSOR PERFBOOSTMODE aggressive
powercfg -SetActive scheme_current
echo "Performance Boost Mode set to Aggressive."
pause
goto cpu_power_management


:adjust_processor_state
echo "Adjusting Processor State..."
echo "Setting Minimum Processor State to 5%..."
powercfg -attributes SUB_PROCESSOR PROCTHROTTLEMIN -ATTRIB_HIDE
powercfg -setacvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg -setdcvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMIN 5
echo "Setting Maximum Processor State to 100%..."
powercfg -attributes SUB_PROCESSOR PROCTHROTTLEMAX -ATTRIB_HIDE
powercfg -setacvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -setdcvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -SetActive scheme_current
echo "Processor State adjusted."
pause
goto cpu_power_management


:revert_power_management_optimizations
echo "Reverting Power Management Optimizations..."
echo "Setting active power plan to Balanced..."
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e
echo "Power Management optimizations reverted."
pause
goto cpu_power_management


:cpu_category_option_2
:cpu_scheduling_responsiveness
cls
echo "=============================================================="
echo "         CPU Optimization - Scheduling & Responsiveness"
echo "=============================================================="
echo " Optimize CPU scheduling for better program responsiveness."
echo "=============================================================="
echo "1. Optimize Scheduling for Programs (Responsiveness)"
echo "2. Prioritize Programs over Background Services"
echo "3. Enable Hardware-accelerated GPU Scheduling (Graphics - Win10 2004+/Win11)"
echo "--------------------------------------------------------------"
echo "4. Revert Scheduling Optimizations"
echo "5. Return to CPU Optimization Menu"
echo "=============================================================="
set /p cpu_schedule_choice=Enter choice (1-5):

if "%cpu_schedule_choice%"=="1" goto optimize_scheduling
if "%cpu_schedule_choice%"=="2" goto adjust_system_responsiveness
if "%cpu_schedule_choice%"=="3" goto enable_gpu_scheduling
if "%cpu_schedule_choice%"=="4" goto revert_scheduling_optimizations
if "%cpu_schedule_choice%"=="5" goto optimize_cpu
echo "Invalid choice. Try again."
pause
goto cpu_scheduling_responsiveness


:optimize_scheduling
echo "Optimizing Scheduling for Programs..."
echo "Reduce background task priority for better program responsiveness."
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemThreadPool" "ThreadPoolHysteresisIntervals" "REG_DWORD" "5"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemThreadPool" "ThreadPoolMaximumThreads" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemThreadPool" "ThreadPoolSchedulingPolicy" "REG_DWORD" "1"
echo "Scheduling optimized for programs."
pause
goto cpu_scheduling_responsiveness


:adjust_system_responsiveness
echo "Prioritizing Programs for Responsiveness..."
echo "Foreground programs prioritized over background services."
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" "REG_DWORD" "14"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Scheduling Category" "REG_SZ" "High"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "PriorityClass" "REG_DWORD" "8"
echo "Program responsiveness prioritized."
pause
goto cpu_scheduling_responsiveness


:enable_gpu_scheduling
echo "Enabling GPU Scheduling..."
:: Check if GPU Scheduling is supported (Windows 10 2004+ / Windows 11) - (This check is simplified, more robust check might be needed)
ver | findstr /C:"Version 10.0" > nul
if %errorlevel% equ 0 (
    echo "Windows 10+ detected. Enabling GPU Scheduling..."
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" "2"
    echo "GPU Scheduling enabled. Restart may be needed."
) else (
    echo "GPU Scheduling available on Windows 10 2004+ / Windows 11 only."
    echo "Your system may not support this."
)
pause
goto cpu_scheduling_responsiveness


:revert_scheduling_optimizations
echo "Reverting Scheduling Optimizations..."
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "REG_DWORD" /d 2 /f
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Scheduling Category" "REG_SZ" "Medium" /f
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "PriorityClass" "REG_DWORD" /d 4 /f
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemThreadPool" "ThreadPoolHysteresisIntervals" "REG_DWORD" /d 10 /f
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemThreadPool" "ThreadPoolMaximumThreads" "REG_DWORD" /d 2147483647 /f
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemThreadPool" "ThreadPoolSchedulingPolicy" "REG_DWORD" /d 0 /f
echo "Scheduling optimizations reverted."
pause
goto cpu_scheduling_responsiveness


:cpu_category_option_3
:cpu_core_services
cls
echo "=============================================================="
echo "           CPU Optimization - Core Parking & Services"
echo "=============================================================="
echo " Manage CPU core parking and unnecessary system services."
echo "=============================================================="
echo "1. Disable CPU Core Parking (Consistent Performance)"
echo "2. Disable Unnecessary Services (Caution - May Affect Functionality - Windows 11 Notes Below)"
echo "   - Windows 11 Notes: Service behavior may differ from Windows 10."
echo "     Test after disabling. Disable ""SysMain"" & ""DiagTrack"" cautiously."
echo "     Disable ""Windows Search"" (WSearch) only if not used."
echo "--------------------------------------------------------------"
echo "3. Revert Core Parking & Services Optimizations"
echo "4. Return to CPU Optimization Menu"
echo "=============================================================="
set /p cpu_core_choice=Enter choice (1-4):

if "%cpu_core_choice%"=="1" goto disable_core_parking
if "%cpu_core_choice%"=="2" goto disable_services
if "%cpu_core_choice%"=="3" goto revert_core_services_optimizations
if "%cpu_core_choice%"=="4" goto optimize_cpu
echo "Invalid choice. Try again."
pause
goto cpu_core_services


:disable_core_parking
echo "Disabling CPU Core Parking..."
powercfg -attributes SUB_PROCESSOR CPMINCORES -ATTRIB_HIDE
powercfg -setacvalueindex scheme_current SUB_PROCESSOR CPMINCORES 100
powercfg -setdcvalueindex scheme_current SUB_PROCESSOR CPMINCORES 100
powercfg -SetActive scheme_current
echo "CPU Core Parking disabled."
pause
goto cpu_core_services


:disable_services
cls
echo "=============================================================="
echo "          Disable Unnecessary System Services (Caution)"
echo "=============================================================="
echo " Disabling services may improve performance but affect system functions."
echo " Proceed with caution and test your system afterwards."
echo "=============================================================="
echo "Select services to disable:"
echo "1. Disable SysMain (Superfetch) - (May affect app preloading)"
echo "2. Disable Diagnostic Tracking (DiagTrack) - (Telemetry & Diagnostics)"
echo "3. Disable Windows Search (WSearch) - (Disables file indexing - NOT RECOMMENDED for most)"
echo "--------------------------------------------------------------"
echo "4. Disable SysMain, DiagTrack, & WSearch (Aggressive - Advanced Users)"
echo "5. Return to Core Parking & Services Menu"
echo "=============================================================="
set /p disable_service_choice=Enter choice (1-5):

if "%disable_service_choice%"=="1" goto disable_sysmain
if "%disable_service_choice%"=="2" goto disable_diagtrack
if "%disable_service_choice%"=="3" goto disable_wsearch
if "%disable_service_choice%"=="4" goto disable_all_services
if "%disable_service_choice%"=="5" goto cpu_core_services
echo "Invalid choice. Try again."
pause
goto disable_services


:disable_sysmain
echo "Disabling SysMain (Superfetch) Service..."
sc config "SysMain" start= disabled
sc stop "SysMain"
echo "SysMain service disabled."
pause
goto disable_services

:disable_diagtrack
echo "Disabling Diagnostic Tracking Service (DiagTrack)..."
sc config "DiagTrack" start= disabled
sc stop "DiagTrack"
echo "Diagnostic Tracking Service disabled."
pause
goto disable_services

:disable_wsearch
echo "Disabling Windows Search (WSearch) Service..."
echo "WARNING: Disabling Windows Search disables file indexing & search."
echo "         Only proceed if you don't use Windows Search."
pause
sc config "WSearch" start= disabled
sc stop "WSearch"
echo "Windows Search service disabled."
pause
goto disable_services

:disable_all_services
echo "Disabling SysMain, DiagTrack, & Windows Search Services..."
echo "Disabling SysMain..."
sc config "SysMain" start= disabled
sc stop "SysMain"
echo "Disabling DiagTrack..."
sc config "DiagTrack" start= disabled
sc stop "DiagTrack"
echo "Disabling Windows Search..."
sc config "WSearch" start= disabled
sc stop "WSearch"
echo "SysMain, DiagTrack, & Windows Search services disabled."
echo "WARNING: System functionality may be affected. Test thoroughly."
pause
goto disable_services


:revert_core_services_optimizations
echo "Reverting Core Parking & Services Optimizations..."
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 0
powercfg -setdcvalueindex scheme_current sub_processor CPMINCORES 0
powercfg -SetActive scheme_current

sc config "SysMain" start= auto
sc start "SysMain"
sc config "DiagTrack" start= auto
sc start "DiagTrack"
sc config "WSearch" start= auto
sc start "WSearch"

echo "Core Parking & Services optimizations reverted."
pause
goto cpu_core_services


:cpu_category_option_4
:cpu_visual_effects
cls
echo "=============================================================="
echo "           CPU Optimization - Visual Effects"
echo "=============================================================="
echo " Adjust visual effects for better performance."
echo "=============================================================="
echo "1. Adjust for Best Performance (Fastest Appearance)"
echo "--------------------------------------------------------------"
echo "2. Revert Visual Effects Optimizations"
echo "3. Return to CPU Optimization Menu"
echo "=============================================================="
set /p cpu_visual_choice=Enter choice (1-3):

if "%cpu_visual_choice%"=="1" goto adjust_visual_effects
if "%cpu_visual_choice%"=="2" goto revert_visual_effects_optimizations
if "%cpu_visual_choice%"=="3" goto optimize_cpu
echo "Invalid choice. Try again."
pause
goto cpu_visual_effects


:adjust_visual_effects
echo "Adjusting Visual Effects for Best Performance..."
echo "Setting visual effects to ""Adjust for best performance""..."
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "REG_DWORD" "2" /f
echo "Visual effects adjusted for best performance."
pause
goto cpu_visual_effects


:revert_visual_effects_optimizations
echo "Reverting Visual Effects Optimizations..."
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "REG_DWORD" /d 0 /f
echo "Visual Effects optimizations reverted (Windows default)."
pause
goto cpu_visual_effects


:cpu_category_option_5
:cpu_boot_performance
cls
echo "=============================================================="
echo "           CPU Optimization - Boot Performance"
echo "=============================================================="
echo " Improve boot performance for faster startup."
echo "=============================================================="
echo "1. Enable Multi-core Boot (Use all CPU cores - Restart Required)"
echo "2. Disable Memory Limit for Boot (Use all RAM - Restart Required)"
echo "--------------------------------------------------------------"
echo "3. Revert Boot Performance Enhancements"
echo "4. Return to CPU Optimization Menu"
echo "=============================================================="
set /p cpu_boot_choice=Enter choice (1-4):

if "%cpu_boot_choice%"=="1" goto enable_multicore_boot
if "%cpu_boot_choice%"=="2" goto disable_maxmem_boot
if "%cpu_boot_choice%"=="3" goto revert_boot_optimizations
if "%cpu_boot_choice%"=="4" goto optimize_cpu
echo "Invalid choice. Try again."
pause
goto cpu_boot_performance


:enable_multicore_boot
echo "Enabling Multi-core Boot..."
echo "Setting Windows to use all processors during startup..."
bcdedit /set {current} numproc /enum
echo "Multi-core Boot enabled. Restart for changes."
pause
goto cpu_boot_performance

:disable_maxmem_boot
echo "Disabling Memory Limit for Boot..."
echo "Ensuring Windows uses all available RAM during startup..."
bcdedit /deletevalue {current} truncatememory
bcdedit /deletevalue {current} removememory
echo "Memory Limit for Boot disabled. Restart for changes."
pause
goto cpu_boot_performance


:revert_boot_optimizations
echo "Reverting Boot Performance Enhancements..."
bcdedit /deletevalue {current} numproc
:: bcdedit /deletevalue {current} truncatememory  <- Already deleted in disable_maxmem_boot, no need to delete again.
:: bcdedit /deletevalue {current} removememory   <- Already deleted in disable_maxmem_boot, no need to delete again.
echo "Boot Performance enhancements reverted."
pause
goto cpu_boot_performance


:cpu_category_option_6
:cpu_comprehensive_optimize
cls
echo "=============================================================="
echo "         CPU Optimization - Comprehensive (Advanced)"
echo "=============================================================="
echo " Comprehensive CPU optimization for maximum performance."
echo " Includes:"
echo "- Ultimate/High Performance plan"
echo "- Disable CPU throttling & core parking"
echo "- Optimize scheduling & power"
echo "- Enable GPU scheduling"
echo "- Disable SysMain & DiagTrack (Caution)"
echo "- Best performance visual effects"
echo "- Multi-core & Max Memory Boot"
echo "=============================================================="
echo "WARNING: Aggressive optimization. May reduce system stability."
echo "         Recommended for advanced users only."
echo "=============================================================="
pause

echo "Applying Ultimate or High Performance Power Plan..."
call :set_ultimate_or_high_performance
echo "Disabling CPU Throttling..."
call :disable_throttling
echo "Optimizing Processor Scheduling..."
call :optimize_scheduling
echo "Disabling CPU Core Parking..."
call :disable_core_parking
echo "Setting Performance Boost Mode..."
call :adjust_power_management
echo "Enabling GPU Scheduling..."
call :enable_gpu_scheduling
echo "Disabling SysMain & DiagTrack Services..."
call :disable_sysmain
call :disable_diagtrack
echo "Adjusting Visual Effects..."
call :adjust_visual_effects
echo "Enabling Multi-core Boot..."
call :enable_multicore_boot
echo "Disabling Memory Limit for Boot..."
call :disable_maxmem_boot

echo.
echo "Comprehensive CPU Optimization Applied."
echo "Restart your computer for full effect."
pause
goto optimize_cpu

:set_ultimate_or_high_performance
:: Function to set Ultimate Performance if available, otherwise High Performance
powercfg /list | findstr /C:"Ultimate Performance" > nul
if %errorlevel% equ 0 (
    goto set_ultimate_performance
) else (
    goto set_high_performance
)
exit /b


:cpu_category_option_7
:revert_cpu_optimizations
cls
echo "=============================================================="
echo "             Revert All CPU Optimizations to Default"
echo "=============================================================="
echo " Reverting all CPU optimizations applied by this script."
echo " Includes:"
echo "- Balanced power plan"
echo "- Re-enable CPU throttling & core parking"
echo "- Revert scheduling & power"
echo "- Disable GPU scheduling"
echo "- Re-enable system services (SysMain, DiagTrack, WSearch)"
echo "- Default visual effects"
echo "- Default Boot settings"
echo "=============================================================="
echo "Please wait, reverting optimizations..."
pause

echo "Setting Balanced Power Plan and Reverting Power Management..."
goto revert_power_management_optimizations
echo "Reverting Scheduling Optimizations..."
goto revert_scheduling_optimizations
echo "Reverting Core Parking & Services Optimizations..."
goto revert_core_services_optimizations
echo "Reverting Visual Effects Optimizations..."
goto revert_visual_effects_optimizations
echo "Reverting Boot Optimizations..."
goto revert_boot_optimizations

echo.
echo "All CPU Optimizations Reverted to Default."
echo "Restart your computer for full effect."
pause
goto optimize_cpu


:cpu_category_option_8
:cpu_monitoring
cls
echo "=============================================================="
echo "             Display Current CPU Settings & Status"
echo "=============================================================="
echo " Displaying current CPU related settings:"
echo "=============================================================="

echo.
echo "--- Current Power Plan ---"
powercfg /getactivescheme

echo.
echo "--- CPU Throttling Status ---"
powercfg /q scheme_current sub_processor PROCTHROTTLEMAX
powercfg /q scheme_current sub_processor PROCTHROTTLEMIN

echo.
echo "--- CPU Core Parking Status ---"
powercfg /q scheme_current sub_processor CPMINCORES

echo.
echo "--- Performance Boost Mode ---"
powercfg /q scheme_current sub_processor PERFBOOSTMODE

echo.
echo "--- GPU Scheduling ---"
reg query "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode

echo.
echo "--- System Services Status (SysMain, DiagTrack, WSearch) ---"
echo "SysMain (Superfetch) Service Status:"
sc query SysMain
echo.
echo "Diagnostic Tracking Service Status:"
sc query DiagTrack
echo.
echo "Windows Search Service Status:"
sc query WSearch

echo.
echo "--- Boot Performance Settings ---"
echo "Multi-core Boot Status:"
bcdedit /get {current} numproc
echo.
echo "Memory Limit Boot Status (TruncateMemory):"
bcdedit /get {current} truncatememory
echo.
echo "Memory Limit Boot Status (RemoveMemory):"
bcdedit /get {current} removememory


echo.
echo "=============================================================="
echo "CPU Settings Displayed. Review output above."
pause
goto optimize_cpu


:cpu_category_option_9
:cpu_advanced_tools
cls
echo "=============================================================="
echo "         Advanced Performance Tools & Information"
echo "=============================================================="
echo " For in-depth CPU analysis & tuning, consider these tools:"
echo "=============================================================="

echo "1. Windows Performance Analyzer (WPA):"
echo "   - Powerful tool from Microsoft for system performance analysis."
echo "   - Includes CPU usage, bottlenecks, and more."
echo "   - Part of Windows ADK. Download: [link] (replace with actual link)"

echo "2. Process Lasso:"
echo "   - Third-party tool for real-time CPU optimization & process management."
echo "   - ProBalance prevents process CPU monopolization."
echo "   - Website: https://bitsum.com/"

echo "3. Performance Monitor (perfmon.exe):"
echo "   - Built-in Windows tool for real-time monitoring of CPU, memory, disk, network."
echo "   - Create custom data collector sets for logging."

echo "4. Resource Monitor (resmon.exe):"
echo "   - Built-in Windows tool for real-time resource overview."
echo "   - Shows CPU, memory, disk, network usage. Identify CPU intensive processes."

echo "=============================================================="
echo "These tools offer advanced performance tuning capabilities."
echo "Recommended for users needing detailed CPU performance insights."
echo "=============================================================="
pause
goto optimize_cpu


:cpu_category_option_10
goto menu


:: Subroutine to modify registry (Improved with error handling)
:modify_registry
    setlocal
    set regPath=%~1
    set regName=%~2
    set regType=%~3
    set regValue=%~4
    set forceOption=
    if "%~5"=="/f" set forceOption=/f

    echo "Setting Registry: ""%regName%"" in ""%regPath%"" to ""%regValue%"" (Type: %regType%)..."
    reg add "%regPath%" /v "%regName%" /t %regType% /d "%regValue%" %forceOption%
    if %errorlevel% equ 0 (
        echo "Registry value set successfully."
    ) else (
        echo "Error setting registry value. Error Code: %errorlevel%"
        echo "Check permissions and syntax."
        pause
        exit /b 1
    )
    endlocal
    exit /b 0


:: Subroutine to set Ultimate Performance or High Performance Power Plan
:set_ultimate_or_high_performance_power_plan
    powercfg /list | findstr /C:"Ultimate Performance" > nul
    if %errorlevel% equ 0 (
        goto set_ultimate_performance
    ) else (
        goto set_high_performance
    )
    exit /b 0

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
echo ==============================================================================
echo                     System Check and Repair - Advanced
echo ==============================================================================
echo  **WARNING:** These tools are for advanced system troubleshooting.
echo  Incorrect usage may impact system stability.
echo  Please read instructions and warnings carefully before selecting each option.
echo ==============================================================================
echo 1. SFC (System File Checker) - Scan and Repair (Recommended - May require restart)
echo    Checks and repairs corrupted system files if errors are found.
echo 2. SFC (System File Checker) - Scan only (System Verification)
echo    Checks for corrupted system files but will not attempt repairs.
echo 3. DISM (Deployment Image Servicing and Management) - Check Health
echo    Checks if the Component Store (WinSXS) is in a healthy state.
echo 4. DISM (Deployment Image Servicing and Management) - Scan Health
echo    Scans the Component Store for potential damage (Takes longer than Check Health).
echo 5. DISM (Deployment Image Servicing and Management) - Restore Health (Requires Internet)
echo    Scans and repairs the Component Store using online sources (Internet connection required).
echo 6. DISM (Deployment Image Servicing and Management) - Start Component Cleanup (WinSXS Cleanup)
echo    Cleans up outdated data in the WinSxS Folder to reduce Component Store size and free up disk space.
echo 7. Check Disk Health Status (SMART Status)
echo    Checks the health status of hard drives or SSDs using SMART (Self-Monitoring, Analysis, and Reporting Technology).
echo 8. Check Disk for Errors (chkdsk /F /R /X - Requires Restart)
echo    Checks and repairs disk errors (File System Errors, Bad Sectors) - Requires system restart.
echo 9. Run Windows Memory Diagnostic (Requires Restart)
echo    Checks for RAM memory issues - Requires system restart to perform the test.
echo 10. Driver Management - Advanced Driver Tools
echo     10.1. List all installed drivers - Display all installed drivers
echo     10.2. Search for drivers by keyword - Search drivers using a keyword
echo 11. Run Driver Verifier (Advanced - Requires Caution and Restart)
echo     **WARNING:** Driver Verifier is an advanced tool, may cause system instability or BSOD if drivers have issues.
echo     Use only when necessary and understand the risks.
echo 12. View SFC Scan Details Log
echo     Opens the log file containing details of SFC scan and repair operations.
echo 13. Return to Main Menu
echo ==============================================================================
set /p repair_choice=Enter your choice (1-13):

if "%repair_choice%"=="1" goto run_sfc_scan_repair
if "%repair_choice%"=="2" goto run_sfc_scanonly
if "%repair_choice%"=="3" goto run_dism_checkhealth
if "%repair_choice%"=="4" goto run_dism_scanhealth
if "%repair_choice%"=="5" goto run_dism_restorehealth
if "%repair_choice%"=="6" goto run_dism_cleanup_component
if "%repair_choice%"=="7" goto check_disk_health_smart
if "%repair_choice%"=="8" goto check_disk_errors_chkdsk
if "%repair_choice%"=="9" goto run_memory_diagnostic
if "%repair_choice%"=="10" goto driver_management_menu  REM: Go to Driver Management Menu
if "%repair_choice%"=="11" goto run_driver_verifier
if "%repair_choice%"=="12" goto view_sfc_log
if "%repair_choice%"=="13" goto menu
echo Invalid choice. Please try again.
pause
goto check_repair

:driver_management_menu
cls
echo ==================================================
echo                 Driver Management - Advanced
echo ==================================================
echo 1. List all installed drivers - Display all installed drivers
echo 2. Search for drivers by keyword - Search drivers using a keyword
echo 3. Return to System Check and Repair Menu - Back to System Check and Repair Menu
echo ==================================================
set /p driver_mgmt_choice=Enter your choice (1-3):

if "%driver_mgmt_choice%"=="1" goto list_all_drivers_func
if "%driver_mgmt_choice%"=="2" goto search_drivers_func
if "%driver_mgmt_choice%"=="3" goto check_repair
echo Invalid choice. Please try again.
pause
goto driver_management_menu

:list_all_drivers_func
cls
echo ==================================================
echo              List All Installed Drivers
echo ==================================================
echo Listing all installed drivers... Please wait...
echo ==================================================
pnputil /enum-drivers
if %errorlevel% neq 0 (
    echo.
    echo !!! ERROR: Failed to list drivers. Error Code: %errorlevel% !!!
    echo Please ensure you are running this script as an Administrator.
) else (
    echo.
    echo ==================================================
    echo          Driver Listing Completed - Check Output Above
    echo ==================================================
    echo Driver listing completed. Check the output above for the list of installed drivers.
)
pause
goto driver_management_menu

:search_drivers_func
cls
echo ==================================================
echo              Search Drivers by Keyword
echo ==================================================
set /p search_term=Enter keyword to search for drivers (e.g., display, network, vendor name):
echo ==================================================
echo Searching for drivers matching keyword: "%search_term%"... Please wait...
echo ==================================================
pnputil /enum-drivers | findstr /i "%search_term%"
if %errorlevel% neq 0 (
    echo.
    echo No drivers found matching keyword "%search_term%" or error during search.
) else (
    echo.
    echo ==================================================
    echo       Driver Search Completed - Check Output Above
    echo ==================================================
    echo Driver search completed. Check the output above for drivers matching your keyword.
)
pause
goto driver_management_menu

:run_sfc_scan_repair
:: (Code เดิมจาก Option 10 - run_sfc_scan_repair)
echo.
echo ==============================================================================
echo           Running System File Checker (SFC) - Scan and Repair
echo ==============================================================================
echo This process will scan and repair corrupted system files if found.
echo Please wait, this process may take some time...
echo ==============================================================================
sfc /scannow
if %errorlevel% equ 0 (
    echo.
    echo ==============================================================================
    echo           SFC Scan Completed - SFC Scan Completed Successfully
    echo ==============================================================================
    echo SFC scan is complete. Please check the output above for details.
    echo **Recommendation:** If SFC found and repaired errors, a system restart is recommended.
) else (
    echo.
    echo !!! ERROR: SFC Scan Failed - SFC Scan Failed !!!
    echo ==============================================================================
    echo SFC scan failed. Error Code: %errorlevel%
    echo Please check the CBS log file (%windir%\Logs\CBS\CBS.log) for more details.
    echo Or verify Administrator privileges and try again.
)
pause
goto check_repair

:run_sfc_scanonly
:: (Code เดิมจาก Option 10 - run_sfc_scanonly)
echo.
echo ==============================================================================
echo           Running System File Checker (SFC) - Scan only (Verification)
echo ==============================================================================
echo This process will scan for corrupted system files but will not attempt repairs.
echo Used for system verification only. Please wait...
echo ==============================================================================
sfc /verifyonly
if %errorlevel% equ 0 (
    echo.
    echo ==============================================================================
    echo           SFC Scan (Verification Only) Completed - SFC Scan (Verification) Completed Successfully
    echo ==============================================================================
    echo SFC scan (Verification) is complete. Please check the output above for details.
) else (
    echo.
    echo !!! ERROR: SFC Scan (Verification Only) Failed - SFC Scan (Verification) Failed !!!
    echo ==============================================================================
    echo SFC scan (Verification) failed. Error Code: %errorlevel%
    echo Please check the CBS log file (%windir%\Logs\CBS\CBS.log) for more details.
    echo Or verify Administrator privileges and try again.
)
pause
goto check_repair

:run_dism_checkhealth
:: (Code เดิมจาก Option 10 - run_dism_checkhealth)
echo.
echo ==============================================================================
echo     Running DISM - Check Health (Component Store Health Status Check)
echo ==============================================================================
echo This process will check if the Component Store (WinSXS) is in a healthy state.
echo This is a quick preliminary check. Please wait...
echo ==============================================================================
DISM /Online /Cleanup-Image /CheckHealth
if %errorlevel% equ 0 (
    echo.
    echo ==============================================================================
    echo           DISM CheckHealth Completed - DISM Check Health Completed Successfully
    echo ==============================================================================
    echo DISM CheckHealth is complete. Please check the output above for details.
    echo Status "No component store corruption detected" indicates a healthy system.
) else (
    echo.
    echo !!! ERROR: DISM CheckHealth Failed - DISM Check Health Failed !!!
    echo ==============================================================================
    echo DISM CheckHealth failed. Error Code: %errorlevel%
    echo Please try running DISM ScanHealth or RestoreHealth to further investigate and repair.
    echo Or check the DISM log file (%windir%\Logs\DISM\dism.log) for more details.
)
pause
goto check_repair

:run_dism_scanhealth
:: (Code เดิมจาก Option 10 - run_dism_scanhealth)
echo.
echo ==============================================================================
echo         Running DISM - Scan Health (Component Store Health Scan)
echo ==============================================================================
echo This process will scan the Component Store (WinSXS) for potential damage.
echo This process may take several minutes. Please wait...
echo ==============================================================================
DISM /Online /Cleanup-Image /ScanHealth
if %errorlevel% equ 0 (
    echo.
    echo ==============================================================================
    echo           DISM ScanHealth Completed - DISM Scan Health Completed Successfully
    echo ==============================================================================
    echo DISM ScanHealth is complete. Please check the output above for details.
    echo If corruption is found, it is recommended to run DISM RestoreHealth to repair it.
) else (
    echo.
    echo !!! ERROR: DISM ScanHealth Failed - DISM Scan Health Failed !!!
    echo ==============================================================================
    echo DISM ScanHealth failed. Error Code: %errorlevel%
    echo Please check the DISM log file (%windir%\Logs\DISM\dism.log) for more details.
    echo Or verify Administrator privileges and try again.
)
pause
goto check_repair

:run_dism_restorehealth
:: (Code เดิมจาก Option 10 - run_dism_restorehealth)
echo.
echo ==============================================================================
echo       Running DISM - Restore Health (Component Store Health Repair)
echo ==============================================================================
echo This process will scan and repair the Component Store (WinSXS) using online sources.
echo **WARNING:** Internet connection is required, and this process may take a long time. Please wait...
echo ==============================================================================
DISM /Online /Cleanup-Image /RestoreHealth
if %errorlevel% equ 0 (
    echo.
    echo ==============================================================================
    echo         DISM RestoreHealth Completed - DISM Restore Health Completed Successfully
    echo ==============================================================================
    echo DISM RestoreHealth is complete. Please check the output above for details.
    echo The Component Store has been repaired.
) else (
    echo.
    echo !!! ERROR: DISM RestoreHealth Failed - DISM Restore Health Failed !!!
    echo ==============================================================================
    echo DISM RestoreHealth failed. Error Code: %errorlevel%
    echo Please check your internet connection and the DISM log file (%windir%\Logs\DISM\dism.log).
    echo Or verify Administrator privileges and try again.
)
pause
goto check_repair

:run_dism_cleanup_component
:: (Code เดิมจาก Option 10 - run_dism_cleanup_component)
echo.
echo ==============================================================================
echo     Running DISM - Start Component Cleanup (WinSXS Cleanup)
echo ==============================================================================
echo This process will clean up outdated data in the WinSxS Folder to reduce Component Store size.
echo May help free up disk space. Please wait...
echo ==============================================================================
DISM /Online /Cleanup-Image /StartComponentCleanup
if %errorlevel% equ 0 (
    echo.
    echo ==============================================================================
    echo     DISM Component Cleanup Completed - DISM Component Cleanup Completed Successfully
    echo ==============================================================================
    echo DISM Component Cleanup is complete. Please check the output above for details.
    echo Disk space may have been freed up after the cleanup.
) else (
    echo.
    echo !!! ERROR: DISM Component Cleanup Failed - DISM Component Cleanup Failed !!!
    echo ==============================================================================
    echo DISM Component Cleanup failed. Error Code: %errorlevel%
    echo Please check the DISM log file (%windir%\Logs\DISM\dism.log) for more details.
    echo Or verify Administrator privileges and try again.
)
pause
goto check_repair

:check_disk_health_smart
:: (Code เดิมจาก Option 10 - check_disk_health_smart)
echo.
echo ==============================================================================
echo                 Checking Disk Health Status (SMART Status)
echo ==============================================================================
echo This process will check the health status of hard drives or SSDs using SMART.
echo Please wait...
echo ==============================================================================
wmic diskdrive get status,model,index,size,SerialNumber,PredFail, Caption
echo.
echo ==============================================================================
echo             Disk Health Check Completed - Disk Health Check Completed Successfully
echo ==============================================================================
echo Disk health check is complete. Please check the status above.
echo PredFail = 'TRUE' indicates potential disk failure. Status = 'OK' is normal.
pause
goto check_repair

:check_disk_errors_chkdsk
:: (Code เดิมจาก Option 10 - check_disk_errors_chkdsk)
echo.
echo ==============================================================================
echo         Checking Disk for Errors (chkdsk /F /R /X - Requires Restart)
echo ==============================================================================
echo This process will schedule a disk check for errors on the next system restart.
echo **WARNING:** Please save your work and be prepared to restart your computer.
echo ==============================================================================
chkdsk C: /F /R /X
echo.
echo ==============================================================================
echo         Disk Check Scheduled - Disk Check Scheduled (Requires Restart)
echo ==============================================================================
echo Disk check scheduled successfully. Please restart your computer to perform the check.
pause
goto check_repair

:run_memory_diagnostic
:: (Code เดิมจาก Option 10 - run_memory_diagnostic)
echo.
echo ==============================================================================
echo             Running Windows Memory Diagnostic (Requires Restart)
echo ==============================================================================
echo This process will launch the Windows Memory Diagnostic tool and require a system restart.
echo **WARNING:** Please save your work before proceeding.
echo ==============================================================================
start mdsched.exe
echo.
echo ==============================================================================
echo         Windows Memory Diagnostic Launched - Windows Memory Diagnostic Launched
echo ==============================================================================
echo Windows Memory Diagnostic tool launched. Please restart your computer to begin the memory test.
pause
goto check_repair

:run_driver_verifier
:: (Code เดิมจาก Option 10 - run_driver_verifier)
echo.
echo ==============================================================================
echo         !!! WARNING - Driver Verifier (Advanced - Requires Caution) !!!
echo ==============================================================================
echo **WARNING:** Driver Verifier is an advanced tool for driver debugging.
echo Incorrect usage may cause system instability or Blue Screen of Death (BSOD).
echo Proceed only if you understand the risks and have system troubleshooting knowledge.
echo **Recommendation:** If unsure, please choose "N" to cancel.
echo ==============================================================================
set /p confirm_verifier=Are you sure you want to run Driver Verifier? (Y/N - Highly Recommended to choose N if unsure):
if /i "%confirm_verifier%"=="Y" (
    echo.
    echo ==============================================================================
    echo             Launching Driver Verifier Manager - Launching Driver Verifier Manager
    echo ==============================================================================
    echo Launching Driver Verifier Manager...
    verifier
    echo.
    echo ==============================================================================
    echo         Driver Verifier Manager Opened - Driver Verifier Manager Opened
    echo ==============================================================================
    echo Driver Verifier Manager opened. Please configure and run Verifier from the GUI.
    echo **WARNING:** A system restart will be required after configuring Driver Verifier.
) else (
    echo.
    echo Driver Verifier cancelled - Driver Verifier Cancelled
)
pause
goto check_repair

:view_sfc_log
:: (Code เดิมจาก Option 10 - view_sfc_log)
echo.
echo ==============================================================================
echo             Viewing SFC Scan Details Log (sfcdetails.txt)
echo ==============================================================================
echo Opening SFC details log file (sfcdetails.txt) from your Desktop...
echo ==============================================================================
start "" "%userprofile%\Desktop\sfcdetails.txt"
if not exist "%userprofile%\Desktop\sfcdetails.txt" (
    echo.
    echo SFC log file not found on Desktop - SFC log file not found on Desktop
    echo ==============================================================================
    echo SFC log file not found on Desktop. Generating a new log...
    Findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log >"%userprofile%\Desktop\sfcdetails.txt"
    echo SFC log generated and saved to sfcdetails.txt on your desktop - SFC log generated and saved to sfcdetails.txt on your desktop
) else (
    echo.
    echo SFC log file opened from Desktop - SFC log file opened from Desktop
)
pause
goto check_repair

:option_11
:windows_activate
cls
echo ==================================================================
echo                       Windows Activation Script (Improved)
echo ==================================================================
echo 1. Check activation status
echo 2. Activate using KMS (Volume License - **USE WITH CAUTION**)
echo 3. Activate Windows (Digital License or KMS if configured)
echo 4. Input a product key manually
echo 5. Remove product key
echo 6. Return to main menu
echo ==================================================================
set /p activate_choice=Enter your choice (1-6):

if "%activate_choice%"=="1" goto check_activation
if "%activate_choice%"=="2" goto kms_activate_warning
if "%activate_choice%"=="3" goto activate_windows
if "%activate_choice%"=="4" goto manual_key
if "%activate_choice%"=="5" goto remove_key
if "%activate_choice%"=="6" goto menu
echo Invalid choice. Please try again.
pause
goto windows_activate

:check_activation
cls
echo ==================================================================
echo                    Checking Windows Activation Status
echo ==================================================================
slmgr /xpr
pause
goto windows_activate

:kms_activate_warning
cls
echo ====================================================================================
echo                       !!!  WARNING - KMS ACTIVATION  !!!
echo ====================================================================================
echo You have chosen to activate Windows using KMS via an external script.
echo **THIS METHOD INVOLVES DOWNLOADING AND EXECUTING A SCRIPT FROM:**
echo
echo                  https://get.activated.win
echo
echo ====================================================================================
echo **SECURITY RISK:**
echo Executing scripts from the internet can be dangerous.
echo We **STRONGLY RECOMMEND** reviewing the script's content before execution
echo to understand what it does. Proceed at your own risk.
echo ====================================================================================
echo Do you understand the risks and want to proceed with KMS activation?
echo ====================================================================================
echo 1. Proceed with KMS Activation
echo 2. Return to Activation Menu
echo ====================================================================================
set /p kms_choice=Enter your choice (1-2):

if "%kms_choice%"=="1" goto kms_activate_real
if "%kms_choice%"=="2" goto windows_activate
echo Invalid choice. Returning to Activation Menu.
pause
goto windows_activate

:kms_activate_real
cls
echo ==================================================================
echo                    Attempting KMS Activation (External Script)
echo ==================================================================
:: Check if the script is running with administrator privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    :: If running as administrator, execute the PowerShell command
    echo Attempting KMS Activation using script from https://get.activated.win ...
    powershell -command "irm https://get.activated.win | iex"
    echo.
    echo KMS Activation Attempted. Please check your activation status.
    slmgr /xpr
) else (
    :: If not running as administrator, relaunch the script as administrator
    echo Requesting Administrator Privileges for KMS Activation...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c %~s0", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
)
pause
goto windows_activate


:activate_windows
cls
echo ==================================================================
echo          Attempting Windows Activation (Digital License or KMS)
echo ==================================================================
echo Attempting Windows activation using digital license or configured KMS...
slmgr /ato
if %errorlevel% neq 0 (
    echo Activation failed. Please check your network connection and KMS configuration (if applicable).
) else (
    echo Windows activation attempted successfully!
    echo.
    echo Current Activation Status:
    slmgr /xpr
)
pause
goto windows_activate

:manual_key
cls
echo ==================================================================
echo                 Manual Product Key Activation
echo ==================================================================
set /p product_key=Enter your 25-character product key (XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
echo.
echo Installing product key...
slmgr /ipk %product_key%
if %errorlevel% neq 0 (
    echo Failed to install product key. The key may be invalid or not applicable to your Windows version.
) else (
    echo Product key installed successfully.
    echo.
    echo Attempting activation...
    slmgr /ato
    if %errorlevel% neq 0 (
        echo Activation failed. Please check your product key and try again.
    ) else (
        echo Windows activation attempted successfully!
        echo.
        echo Current Activation Status:
        slmgr /xpr
    )
)
pause
goto windows_activate

:remove_key
cls
echo ==================================================================
echo                     Remove Product Key
echo ==================================================================
echo Removing current product key...
slmgr /upk
if %errorlevel% neq 0 (
    echo Failed to remove product key. You may not have permission or there's no key to remove.
) else (
    echo Product key removed successfully. Windows is now unactivated.
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
cls
echo ===================================================================
echo             Backup and Restore Settings - Advanced
echo ===================================================================
echo 1. Create System Restore Point (Improved)
echo    Create a manual system restore point for system recovery.
echo 2. Restore System from Restore Point
echo    Restore your system to a previously created restore point.
echo 3. Create System Image Backup (Advanced - wbadmin)
echo    Create a full system image backup using wbadmin.exe (requires external storage).
echo 4. Restore System from System Image (Advanced - Recovery Environment)
echo    Guide to restoring your system from a system image backup (requires boot to Recovery Environment).
echo 5. Backup Specific Folders (Basic - robocopy)
echo    Basic backup of specific folders to a destination folder (using robocopy - no versioning).
echo 6. Guide to File History (Windows Built-in File Backup)
echo    Open Windows File History settings for advanced file backup and versioning.
echo 7. Return to Main Menu
echo ===================================================================
set /p backup_choice=Enter your choice (1-7):

if "%backup_choice%"=="1" goto create_restore_improved
if "%backup_choice%"=="2" goto restore_point
if "%backup_choice%"=="3" goto create_system_image_backup
if "%backup_choice%"=="4" goto restore_system_image_guide
if "%backup_choice%"=="5" goto backup_specific_folders
if "%backup_choice%"=="6" goto guide_file_history
if "%backup_choice%"=="7" goto menu
echo Invalid choice. Please try again.
pause
goto backup_restore

:create_restore_improved
cls
echo ===================================================================
echo          Create System Restore Point - Improved
echo ===================================================================
echo Creating a system restore point... Please wait...
echo ===================================================================
set restore_description="Manual Restore Point - Created by Optimization Script v3.0"
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "%restore_description%", 100, 7
if %errorlevel% equ 0 (
    echo.
    echo System restore point created successfully.
    echo Description: "%restore_description%"
    echo You can use this restore point to revert system changes if needed.
) else (
    echo.
    echo !!! ERROR: Failed to create system restore point. Error Code: %errorlevel% !!!
    echo Please ensure Volume Shadow Copy Service (VSS) is running and you have enough disk space.
    echo Also, check if System Protection is enabled for your system drive.
)
pause
goto backup_restore

:restore_point
:: (Code เดิมจาก Option 17 - restore_point)
echo ===================================================================
echo          Restore System from Restore Point
echo ===================================================================
echo Launching System Restore...
rstrui.exe
echo Please follow the on-screen instructions in System Restore to choose a restore point and restore your system.
echo **WARNING:** System restore will revert system files and settings to the chosen restore point.
echo Ensure you have backed up any important data created after the restore point.
pause
goto backup_restore

:create_system_image_backup
cls
echo ===================================================================
echo          Create System Image Backup (Advanced - wbadmin)
echo ===================================================================
echo **WARNING:** System image backup creates a full copy of your system drive.
echo This requires significant disk space on an EXTERNAL STORAGE DEVICE (USB drive, external HDD, network share).
echo Ensure you have connected and selected the correct external storage device for backup.
echo ===================================================================
echo Please specify the DRIVE LETTER of the EXTERNAL STORAGE DEVICE where you want to save the system image backup (e.g., E: or F:):
set /p backup_target_drive=Enter drive letter:

if not defined backup_target_drive (
    echo Error: No drive letter entered. System image backup cancelled.
    pause
    goto backup_restore
)

echo ===================================================================
echo Starting System Image Backup to drive %backup_target_drive%... Please wait, this may take a long time.
echo ===================================================================
wbadmin start backup -backupTarget:%backup_target_drive% -include:C: -allCritical -quiet
if %errorlevel% equ 0 (
    echo.
    echo System image backup created successfully on drive %backup_target_drive%.
    echo **IMPORTANT:** Keep the external storage device safe. You will need it to restore your system image.
) else (
    echo.
    echo !!! ERROR: Failed to create system image backup. Error Code: %errorlevel% !!!
    echo Please check:
    echo - If the external storage device is connected and accessible with drive letter %backup_target_drive%.
    echo - If there is enough free space on the external storage device.
    echo - If wbadmin.exe is functioning correctly (check Event Viewer for wbadmin errors).
)
pause
goto backup_restore

:restore_system_image_guide
cls
echo ===================================================================
echo      Restore System from System Image (Advanced - Recovery Environment)
echo ===================================================================
echo **WARNING:** Restoring from a system image will ERASE EVERYTHING on your system drive
echo and replace it with the contents of the system image.
echo Ensure you have backed up any important data on your current system drive that is NOT in the system image.
echo ===================================================================
echo **Instructions to Restore System Image:**
echo 1. **Connect the external storage device** containing your system image backup to your computer.
echo 2. **Restart your computer.**
echo 3. **Boot into Windows Recovery Environment (WinRE).**
echo    - You can usually do this by repeatedly pressing a specific key during startup (e.g., F11, F12, Del, Esc).
echo      The key varies depending on your computer manufacturer. Check your computer's manual or website.
echo    - Alternatively, you can boot from Windows installation media (USB or DVD) and choose "Repair your computer".
echo 4. In WinRE, navigate to **Troubleshoot > Advanced options > System Image Recovery.**
echo 5. **Follow the on-screen instructions** to select your system image backup from the external storage device and restore your system.
echo ===================================================================
echo **IMPORTANT:** System image restore is a destructive operation. Proceed with caution and ensure you understand the risks.
echo This script only provides guidance. The actual restore process is done within Windows Recovery Environment.
pause
goto backup_restore

:backup_specific_folders
cls
echo ===================================================================
echo          Backup Specific Folders (Basic - robocopy)
echo ===================================================================
echo **WARNING:** This is a BASIC folder backup using robocopy. It does NOT provide versioning or advanced backup features.
echo It is intended for simple backups of important folders. For more robust backup solutions, consider using File History or System Image Backup.
echo ===================================================================
set /p source_folder=Enter the full path of the SOURCE FOLDER to backup:
if not exist "%source_folder%" (
    echo Error: Source folder does not exist. Please enter a valid folder path.
    pause
    goto backup_restore
)
set /p destination_folder=Enter the full path of the DESTINATION FOLDER for backup:
if not exist "%destination_folder%" (
    echo Destination folder does not exist. Creating destination folder: "%destination_folder%"
    mkdir "%destination_folder%" 2>nul
    if not exist "%destination_folder%" (
        echo Error: Failed to create destination folder. Please check permissions and path.
        pause
        goto backup_restore
    )
)

echo ===================================================================
echo Starting basic folder backup from "%source_folder%" to "%destination_folder%"... Please wait.
echo ===================================================================
robocopy "%source_folder%" "%destination_folder%" /MIR /COPYALL /R:2 /W:3 /LOG+:"backup_log_robocopy.txt"
if %errorlevel% lss 8 (
    echo.
    echo Basic folder backup completed successfully.
    echo Source folder: "%source_folder%"
    echo Destination folder: "%destination_folder%"
    echo Log file (robocopy details): "backup_log_robocopy.txt" (in script directory)
) else (
    echo.
    echo !!! WARNING: Basic folder backup completed with potential errors. Error Code: %errorlevel% !!!
    echo Please check the robocopy log file "backup_log_robocopy.txt" (in script directory) for details.
)
pause
goto backup_restore

:guide_file_history
cls
echo ===================================================================
echo      Guide to File History (Windows Built-in File Backup)
echo ===================================================================
echo Windows File History is a built-in feature for automatic file backup and versioning.
echo It is recommended for backing up personal files (documents, pictures, music, videos, etc.).
echo ===================================================================
echo **Instructions to Configure File History:**
echo 1. **Connect an external drive** (USB drive or external HDD) to your computer.
echo 2. **Open Control Panel.**
echo 3. Go to **System and Security > File History.**
echo    - Alternatively, search for "File History" in the Windows Start Menu.
echo 4. In File History settings:
echo    - **Turn on File History** if it's off.
echo    - **Select your external drive** as the backup drive.
echo    - **Configure folders to backup** (by default, it backs up Libraries, Desktop, Contacts, and Favorites).
echo    - **Adjust advanced settings** (backup frequency, versions to keep, exclusions, etc.) as needed.
echo ===================================================================
echo File History will automatically backup your files to the selected drive at regular intervals.
echo You can restore previous versions of files from File History settings.
echo This script only provides guidance. You need to configure File History settings manually.
pause
goto backup_restore

:option_18
:system_info
cls
echo ===================================================================
echo         Detailed Hardware and System Information - Advanced View
echo ===================================================================
echo Displaying comprehensive hardware and system information... Please wait...
echo ===================================================================

echo.
echo ========================= Operating System =========================
systeminfo | findstr /c:"OS Name" /c:"OS Version" /c:"Build Type" /c:"Registered Owner" /c:"Installation Date" /c:"System Boot Time"
echo.

echo ============================== CPU ==============================
echo Processor Information:
wmic cpu get Name,DeviceID,Manufacturer,CurrentClockSpeed,MaxClockSpeed,NumberOfCores,NumberOfLogicalProcessors,L2CacheSize,L3CacheSize /format:list
echo.

echo ============================ Motherboard ============================
echo BaseBoard Information:
wmic baseboard get Manufacturer,Product,Version,SerialNumber /format:list
echo.

echo =============================== BIOS ===============================
echo BIOS Information:
wmic bios get Manufacturer,Name,SerialNumber,SMBIOSBIOSVersion,Version /format:list
echo.

echo =============================== Memory (RAM) ===============================
echo Memory (RAM) Information:
powershell -Command "Get-WmiObject Win32_PhysicalMemory | Format-List BankLabel,Capacity,Caption,ConfiguredClockSpeed,DeviceLocator,Manufacturer,PartNumber,SerialNumber,SMBIOSMemoryType,Speed"
echo.

echo ========================== Graphics Card (GPU) ==========================
echo Graphics Card (GPU) Information:
powershell -Command "Get-WmiObject Win32_VideoController | Format-List AdapterCompatibility,AdapterDACType,AdapterRAM,Caption,Description,DriverDate,DriverVersion,InfFilename,InfSection,Manufacturer,Name,PNPDeviceID,VideoProcessor"
echo.

echo ========================== Storage Devices (Disks) =========================
echo Storage Devices (Disks) Information:
powershell -Command "Get-WmiObject Win32_DiskDrive | Format-List Caption,DeviceID,Manufacturer,Model,Name,PNPDeviceID,SerialNumber,Size,InterfaceType,MediaType,Partitions"
echo.

echo ========================== Audio Devices =========================
echo Audio Devices Information:
powershell -Command "Get-WmiObject Win32_SoundDevice | Format-List Caption,DeviceID,Manufacturer,ProductName,Status"
echo.

echo ========================== Network Adapters =========================
echo Network Adapters Information:
:: Enhanced Network Adapter Information using PowerShell
powershell -Command "Get-NetAdapter | Where-Object {$_.NetEnabled -eq \$true} | Format-List Name,InterfaceDescription,InterfaceName,MacAddress,Status,LinkSpeed,MediaType,DriverInformation"
echo.

echo ========================== Monitor/Display =========================
echo Monitor/Display Information:
powershell -Command "Get-WmiObject WmiMonitorID -Namespace root\wmi | ForEach-Object { \$ManufacturerNameBytes = \$_.ManufacturerName -ne \$null ? \$_.ManufacturerName : @(0) ; \$ProductNameBytes = \$_.ProductName -ne \$null ? \$_.ProductName : @(0) ; \$ManufacturerName = ([System.Text.Encoding]::ASCII).GetString(\$ManufacturerNameBytes).Trim(\"`0`"); \$ProductName = ([System.Text.Encoding]::ASCII).GetString(\$ProductNameBytes).Trim(\"`0`"); Write-Host 'Manufacturer:' \$ManufacturerName; Write-Host 'Product Name:' \$ProductName ; Write-Host 'Serial Number (Raw):' \$_.SerialNumberID ;  Write-Host 'InstanceName:' \$_.InstanceName ; Write-Host '-------------------' }"
echo.

echo ========================== Input Devices (Mouse/Keyboard) =========================
echo Input Devices (Mouse/Keyboard) Information:
echo --- Mouse Devices ---
powershell -Command "Get-WmiObject Win32_PointingDevice | Format-List Caption,DeviceID,Manufacturer,Name,PNPDeviceID"
echo.
echo --- Keyboard Devices ---
powershell -Command "Get-WmiObject Win32_Keyboard | Format-List Caption,DeviceID,Layout,Manufacturer,Name,PNPDeviceID"
echo.

echo ===================================================================
echo     Detailed Hardware and System Information Display Completed - Check Output Above
echo ===================================================================
pause
goto menu

:option_19
:optimize_privacy
cls
echo ======================================================
echo              Privacy Optimization - Advanced
echo ======================================================
echo Please select a category to optimize privacy settings:
echo ======================================================

echo 1. Telemetry and Data Collection
echo 2. Advertising and Personalization
echo 3. User Experience and Feedback
echo 4. Connected Experiences
echo ------------------------------------------------------
echo 5. Revert all Privacy Optimizations (Undo Changes)
echo 6. Return to main menu
echo ======================================================
set /p privacy_choice=Enter your choice (1-6):

:: Validate user input
if not "%privacy_choice%"=="" (
    if %privacy_choice% geq 1 if %privacy_choice% leq 6 (
        goto privacy_option_%privacy_choice%
    )
)

:: If invalid choice, prompt again
echo Invalid choice. Please try again.
pause
goto optimize_privacy

:privacy_option_1
:privacy_telemetry
cls
echo ======================================================
echo          Telemetry and Data Collection Settings
echo ======================================================
echo 1. Disable Telemetry (Basic Level - Recommended)
echo 2. Disable Customer Experience Improvement Program (CEIP)
echo 3. Disable Error Reporting
echo 4. Disable Compatibility Telemetry
echo ------------------------------------------------------
echo 5. Revert Telemetry & Data Collection Optimizations
echo 6. Return to Privacy Optimization Menu
echo ======================================================
set /p telemetry_choice=Enter your choice (1-6):

if "%telemetry_choice%"=="1" goto disable_telemetry_adv
if "%telemetry_choice%"=="2" goto disable_ceip_adv
if "%telemetry_choice%"=="3" goto disable_error_reporting_adv
if "%telemetry_choice%"=="4" goto disable_compatibility_telemetry_adv
if "%telemetry_choice%"=="5" goto revert_telemetry_optimizations
if "%telemetry_choice%"=="6" goto optimize_privacy
echo Invalid choice. Please try again.
pause
goto privacy_telemetry

:disable_telemetry_adv
echo Disabling Telemetry and Data Collection (Basic Level)...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
echo Telemetry and Data Collection (Basic Level) disabled.
pause
goto privacy_telemetry

:disable_ceip_adv
echo Disabling Customer Experience Improvement Program (CEIP)...
call :modify_registry "HKCU\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" "0"
echo Customer Experience Improvement Program (CEIP) disabled.
pause
goto privacy_telemetry

:disable_error_reporting_adv
echo Disabling Error Reporting...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "Disabled" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "DontConsentPrompt" "REG_DWORD" "1"
echo Error Reporting disabled.
pause
goto privacy_telemetry

:disable_compatibility_telemetry_adv
echo Disabling Compatibility Telemetry...
sc config "DiagTrack" start= disabled
sc stop "DiagTrack"
echo Compatibility Telemetry (Diagnostic Tracking Service) disabled.
pause
goto privacy_telemetry

:revert_telemetry_optimizations
echo Reverting Telemetry & Data Collection Optimizations...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" /d 1 /f
call :modify_registry "HKCU\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" /d 1 /f
call :modify_registry "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" /d 1 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "Disabled" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "DontConsentPrompt" "REG_DWORD" /d 0 /f
sc config "DiagTrack" start= auto
sc start "DiagTrack"
echo Telemetry & Data Collection optimizations reverted.
pause
goto privacy_telemetry


:privacy_option_2
:privacy_advertising
cls
echo ======================================================
echo          Advertising and Personalization Settings
echo ======================================================
echo 1. Disable Advertising ID
echo 2. Disable Location Services (System-wide)
echo 3. Disable Camera Access (For all apps)
echo 4. Disable Microphone Access (For all apps)
echo ------------------------------------------------------
echo 5. Revert Advertising & Personalization Optimizations
echo 6. Return to Privacy Optimization Menu
echo ======================================================
set /p advertising_choice=Enter your choice (1-6):

if "%advertising_choice%"=="1" goto disable_advertising_id_adv
if "%advertising_choice%"=="2" goto disable_location_services_adv
if "%advertising_choice%"=="3" goto disable_camera_access_adv
if "%advertising_choice%"=="4" goto disable_microphone_access_adv
if "%advertising_choice%"=="5" goto revert_advertising_optimizations
if "%advertising_choice%"=="6" goto optimize_privacy
echo Invalid choice. Please try again.
pause
goto privacy_advertising

:disable_advertising_id_adv
echo Disabling Advertising ID...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "1"
echo Advertising ID disabled.
pause
goto privacy_advertising

:disable_location_services_adv
echo Disabling Location Services (System-wide)...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "NoGlobalLocationControl" "REG_DWORD" "1"
echo Location Services (System-wide) disabled.
pause
goto privacy_advertising

:disable_camera_access_adv
echo Disabling Camera Access (For all apps)...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceAllowTheseApps" "REG_SZ" ""
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceDenyTheseApps" "REG_SZ" "*"
echo Camera Access (For all apps) disabled.
pause
goto privacy_advertising

:disable_microphone_access_adv
echo Disabling Microphone Access (For all apps)...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceAllowTheseApps" "REG_SZ" ""
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceDenyTheseApps" "REG_SZ" "*"
echo Microphone Access (For all apps) disabled.
pause
goto privacy_advertising

:revert_advertising_optimizations
echo Reverting Advertising & Personalization Optimizations...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "NoGlobalLocationControl" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera" "REG_DWORD" /d 1 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceAllowTheseApps" "REG_SZ" "" /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceDenyTheseApps" "REG_SZ" "" /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone" "REG_DWORD" /d 1 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceAllowTheseApps" "REG_SZ" "" /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceDenyTheseApps" "REG_SZ" "" /f
echo Advertising & Personalization optimizations reverted.
pause
goto privacy_advertising


:privacy_option_3
:privacy_ux_feedback
cls
echo ======================================================
echo          User Experience and Feedback Settings
echo ======================================================
echo 1. Disable Windows Tips and Notifications
echo 2. Disable Lock Screen Ads and Spotlight
echo 3. Disable Start Menu Suggestions and Ads
echo ------------------------------------------------------
echo 4. Revert User Experience & Feedback Optimizations
echo 5. Return to Privacy Optimization Menu
echo ======================================================
set /p ux_feedback_choice=Enter your choice (1-5):

if "%ux_feedback_choice%"=="1" goto disable_windows_tips_adv
if "%ux_feedback_choice%"=="2" goto disable_lockscreen_ads_adv
if "%ux_feedback_choice%"=="3" goto disable_startmenu_suggestions_adv
if "%ux_feedback_choice%"=="4" goto revert_ux_feedback_optimizations
if "%ux_feedback_choice%"=="5" goto optimize_privacy
echo Invalid choice. Please try again.
pause
goto privacy_ux_feedback

:disable_windows_tips_adv
echo Disabling Windows Tips and Notifications...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" "1"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastApplicationNotification" "REG_DWORD" "1"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastNotificationQueue" "REG_DWORD" "1"
echo Windows Tips and Notifications disabled.
pause
goto privacy_ux_feedback

:disable_lockscreen_ads_adv
echo Disabling Lock Screen Ads and Spotlight...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsSpotlightFeatures" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableContentDeliveryAds" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableLockScreenSpotlight" "REG_DWORD" "1"
echo Lock Screen Ads and Spotlight disabled.
pause
goto privacy_ux_feedback

:disable_startmenu_suggestions_adv
echo Disabling Start Menu Suggestions and Ads...
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "0"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" "REG_DWORD" "0"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" "REG_DWORD" "0"
echo Start Menu Suggestions and Ads disabled.
pause
goto privacy_ux_feedback

:revert_ux_feedback_optimizations
echo Reverting User Experience & Feedback Optimizations...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" /d 0 /f
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastApplicationNotification" "REG_DWORD" /d 0 /f
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastNotificationQueue" "REG_DWORD" /d 0 /f
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" /d 1 /f
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" "REG_DWORD" /d 1 /f
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" "REG_DWORD" /d 1 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsSpotlightFeatures" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableContentDeliveryAds" "REG_DWORD" /d 0 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableLockScreenSpotlight" "REG_DWORD" /d 0 /f
echo User Experience & Feedback optimizations reverted.
pause
goto privacy_ux_feedback


:privacy_option_4
:privacy_connected_experiences
cls
echo ======================================================
echo          Connected Experiences Settings
echo ======================================================
echo 1. Disable Activity Feed (Timeline)
echo 2. Disable Cortana
echo 3. Disable Web Search in Start Menu
echo 4. Disable People Bar (My People)
echo 5. Uninstall OneDrive (Optional - Requires User Confirmation)
echo ------------------------------------------------------
echo 6. Revert Connected Experiences Optimizations
echo 7. Return to Privacy Optimization Menu
echo ======================================================
set /p connected_choice=Enter your choice (1-7):

if "%connected_choice%"=="1" goto disable_activity_feed_adv
if "%connected_choice%"=="2" goto disable_cortana_adv
if "%connected_choice%"=="3" goto disable_web_search_startmenu_adv
if "%connected_choice%"=="4" goto disable_people_bar_adv
if "%connected_choice%"=="5" goto uninstall_onedrive_adv
if "%connected_choice%"=="6" goto revert_connected_optimizations
if "%connected_choice%"=="7" goto optimize_privacy
echo Invalid choice. Please try again.
pause
goto privacy_connected_experiences

:disable_activity_feed_adv
echo Disabling Activity Feed (Timeline)...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" "0"
echo Activity Feed (Timeline) disabled.
pause
goto privacy_connected_experiences

:disable_cortana_adv
echo Disabling Cortana...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "0"
echo Cortana disabled.
pause
goto privacy_connected_experiences

:disable_web_search_startmenu_adv
echo Disabling Web Search in Start Menu...
call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" "REG_DWORD" "1"
call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "NoInternetOpenWith" "REG_DWORD" "1"
echo Web Search in Start Menu disabled.
pause
goto privacy_connected_experiences

:disable_people_bar_adv
echo Disabling People Bar (My People)...
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "PeopleBand" "REG_DWORD" "0"
echo People Bar (My People) disabled.
pause
goto privacy_connected_experiences

:uninstall_onedrive_adv
echo Uninstalling OneDrive (Optional)...
set /p confirm_onedrive_adv=Are you sure you want to uninstall OneDrive? (Y/N - Recommended to choose N if you use OneDrive):
if /i "%confirm_onedrive_adv%"=="Y" (
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
goto privacy_connected_experiences

:revert_connected_optimizations
echo Reverting Connected Experiences Optimizations...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" /d 1 /f
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" /d 1 /f
call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" "REG_DWORD" /d 0 /f
call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "NoInternetOpenWith" "REG_DWORD" /d 0 /f
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "PeopleBand" "REG_DWORD" /d 1 /f
echo Connected Experiences optimizations reverted.
pause
goto privacy_connected_experiences


:privacy_option_5
:revert_privacy_optimizations
echo Reverting All Privacy Optimizations...
echo Restoring default privacy settings.
goto revert_telemetry_optimizations
goto revert_advertising_optimizations
goto revert_ux_feedback_optimizations
goto revert_connected_optimizations
echo All privacy optimizations reverted to default settings.
pause
goto optimize_privacy


:privacy_option_6
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
echo ======================================================
echo              Network Optimization - Advanced
echo ======================================================
echo 1. Optimize TCP Settings (General Performance)
echo 2. Reset Windows Sockets (Winsock Reset)
echo 3. Flush DNS Resolver Cache (Clear DNS Cache)
echo 4. Optimize Network Adapter Settings (Advanced Tuning)
echo 5. Disable IPv6 (Caution: Compatibility Issues Possible)
echo 6. Enable QoS Packet Scheduler (Prioritize Network Traffic)
echo 7. Set Static DNS Servers (Custom DNS)
echo 8. Reset All Network Settings (Comprehensive Reset - Requires Restart)
echo 9. Release and Renew IP Address (DHCP Refresh)
echo 10. Test Internet Connection (Ping Test)
echo 11. Revert All Network Optimizations (Undo Changes)
echo 12. Return to Main Menu
echo ======================================================
set /p net_choice=Enter your choice (1-12):

if "%net_choice%"=="1" goto optimize_tcp
if "%net_choice%"=="2" goto reset_winsock
if "%net_choice%"=="3" goto flush_dns_cache
if "%net_choice%"=="4" goto optimize_adapter
if "%net_choice%"=="5" goto disable_ipv6
if "%net_choice%"=="6" goto enable_qos
if "%net_choice%"=="7" goto set_static_dns
if "%net_choice%"=="8" goto reset_network_comprehensive
if "%net_choice%"=="9" goto renew_ip_address
if "%net_choice%"=="10" goto test_internet_connection
if "%net_choice%"=="11" goto revert_net_optimizations
if "%net_choice%"=="12" goto menu
echo Invalid choice. Please try again.
pause
goto network_optimization

:optimize_tcp
echo Optimizing TCP Settings (General Performance)...
netsh int tcp set global autotuninglevel=normal
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set global congestionprovider=ctcp
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set global ecncapability=enabled
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set heuristics disabled
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set global rss=enabled
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set global fastopen=enabled
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set global timestamps=disabled
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set global initialRto=2000
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set global nonsackrttresiliency=disabled
if %errorlevel% neq 0 goto netsh_error
echo TCP Settings Optimized for General Performance.
pause
goto network_optimization

:reset_winsock
echo Resetting Windows Sockets (Winsock Reset)...
echo This will reset Winsock catalog to default configuration.
netsh winsock reset
if %errorlevel% equ 0 (
    echo Windows Sockets Reset Completed Successfully.
    echo Please restart your computer for changes to take effect.
) else (
    echo Error: Failed to Reset Windows Sockets. Error Code: %errorlevel%
    echo Please check your permissions and system logs.
)
pause
goto network_optimization

:flush_dns_cache
echo Flushing DNS Resolver Cache (Clear DNS Cache)...
ipconfig /flushdns
if %errorlevel% equ 0 (
    echo DNS Resolver Cache Flushed Successfully.
) else (
    echo Error: Failed to Flush DNS Resolver Cache. Error Code: %errorlevel%
)
pause
goto network_optimization

:optimize_adapter
echo Optimizing Network Adapter Settings (Advanced Tuning)...
echo Applying advanced tuning parameters to connected network adapters...
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    echo Tuning adapter: "%%j"
    netsh int ip set interface "%%j" dadtransmits=0 store=persistent
    if %errorlevel% neq 0 goto netsh_error
    netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent
    if %errorlevel% neq 0 goto netsh_error
    powershell -Command "Get-NetAdapterAdvancedProperty -Name '%%j' | Where-Object {$_.DisplayName -in ('*FlowControl', '*InterruptModeration', '*PriorityVLANTag', '*SpeedDuplex', '*ReceiveSideScaling') } | ForEach-Object {Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword $_.RegistryKeyword -RegistryValue 0}"
    if %errorlevel% neq 0 goto powershell_error
    powershell -Command "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*PriorityVLANTag' -RegistryValue 3"
    if %errorlevel% neq 0 goto powershell_error
    powershell -Command "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*SpeedDuplex' -RegistryValue 0"
    if %errorlevel% neq 0 goto powershell_error
)
echo Network Adapter Settings Optimized (Advanced Tuning).
pause
goto network_optimization

:disable_ipv6
echo ==================================================================================
echo  !!! WARNING: DISABLING IPv6 MAY CAUSE CONNECTIVITY ISSUES ON SOME NETWORKS !!!
echo  IPv6 is increasingly important for modern internet functionality.
echo  Disable IPv6 ONLY if you are certain it is not needed in your network environment.
echo  Proceeding may limit compatibility with some websites and services.
echo ==================================================================================
echo.
set /p ipv6_confirm=Are you sure you want to DISABLE IPv6? (Type YES to confirm - POTENTIAL ISSUES):
if /i "%ipv6_confirm%"=="YES" (
    echo Disabling IPv6...
    netsh interface ipv6 set global randomizeidentifiers=disabled
    if %errorlevel% neq 0 goto netsh_error
    netsh interface ipv6 set privacy state=disabled
    if %errorlevel% neq 0 goto netsh_error
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f
    if %errorlevel% neq 0 goto registry_error
    echo IPv6 Disabled.
    echo Please restart your computer for changes to take effect.
) else (
    echo IPv6 Disabling Cancelled. IPv6 remains enabled.
)
pause
goto network_optimization

:enable_qos
echo Enabling QoS Packet Scheduler (Prioritize Network Traffic)...
netsh int tcp set global packetcoalescinginbound=disabled
if %errorlevel% neq 0 goto netsh_error
sc config "Qwave" start= auto
if %errorlevel% neq 0 goto sc_config_error
sc start Qwave
if %errorlevel% neq 0 goto sc_start_error
echo QoS Packet Scheduler Enabled.
pause
goto network_optimization

:set_static_dns
echo Setting Static DNS Servers (Custom DNS)...
set /p primary_dns=Enter Primary DNS Server Address (e.g., 8.8.8.8):
set /p secondary_dns=Enter Secondary DNS Server Address (e.g., 8.8.4.4 - Optional, press Enter to skip):
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    echo Setting DNS for interface: "%%j"
    netsh interface ip set dns name="%%j" source=static address="%primary_dns%"
    if %errorlevel% neq 0 goto netsh_error
    if not "%secondary_dns%"=="" (
        netsh interface ip add dns name="%%j" address="%secondary_dns%" index=2
        if %errorlevel% neq 0 goto netsh_error
    )
)
echo Static DNS Servers Set.
pause
goto network_optimization

:reset_network_comprehensive
echo Resetting All Network Settings (Comprehensive Reset - Requires Restart)...
echo This will reset Winsock, IP configuration, Firewall, Routing, and flush DNS.
echo Please wait, this may take a moment...
netsh winsock reset
if %errorlevel% neq 0 goto netsh_error
netsh int ip reset all
if %errorlevel% neq 0 goto netsh_error
netsh advfirewall reset
if %errorlevel% neq 0 goto netsh_error
route -f
ipconfig /release *
ipconfig /renew *
ipconfig /flushdns
echo Comprehensive Network Settings Reset Completed.
echo Please restart your computer for changes to fully take effect.
pause
goto network_optimization

:renew_ip_address
echo Releasing and Renewing IP Address (DHCP Refresh)...
echo Releasing current IP configuration...
ipconfig /release
echo Renewing IP configuration from DHCP server...
ipconfig /renew
if %errorlevel% equ 0 (
    echo IP Address Released and Renewed Successfully.
    echo Check the output above for new IP configuration details.
) else (
    echo Error: Failed to Release and Renew IP Address. Error Code: %errorlevel%
    echo Please check your network connection and DHCP server availability.
)
pause
goto network_optimization

:test_internet_connection
echo Testing Internet Connection (Ping Test)...
echo Pinging google.com to test internet connectivity and latency...
ping -n 3 google.com
echo.
echo Ping test completed. Check the output above for latency and connectivity status.
echo If ping fails, check your internet connection and DNS settings.
pause
goto network_optimization

:revert_net_optimizations
echo Reverting All Network Optimizations (Undo Changes)...
echo Restoring default network settings...
netsh int tcp set global autotuninglevel=normal
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set global congestionprovider=default
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set global ecncapability=default
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set global timestamps=default
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set global rss=default
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set global fastopen=default
if %errorlevel% neq 0 goto netsh_error
netsh int tcp set heuristics enabled
if %errorlevel% neq 0 goto netsh_error
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPNoDelay" "REG_DWORD" /d 0 /f
if %errorlevel% neq 0 goto registry_error
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPDelAckTicks" "REG_DWORD" /d 2 /f
if %errorlevel% neq 0 goto registry_error
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    echo Restoring adapter settings for: "%%j"
    netsh int ip set interface "%%j" dadtransmits=3 store=persistent
    if %errorlevel% neq 0 goto netsh_error
    netsh int ip set interface "%%j" routerdiscovery=enabled store=persistent
    if %errorlevel% neq 0 goto netsh_error
    powershell -Command "Get-NetAdapterAdvancedProperty -Name '%%j' | Where-Object {$_.DisplayName -in ('*FlowControl', '*InterruptModeration', '*PriorityVLANTag', '*SpeedDuplex', '*ReceiveSideScaling', '*JumboPacket') } | ForEach-Object {Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword $_.RegistryKeyword -RegistryValue \$null}"
    if %errorlevel% neq 0 goto powershell_error
    powershell -Command "Set-NetAdapterPowerManagement -Name '%%j' -AllowComputerToTurnOffDevice \$true"
    if %errorlevel% neq 0 goto powershell_error
    netsh interface ip set dns name="%%j" source=dhcp
    if %errorlevel% neq 0 goto netsh_error
)
echo Network Optimizations Reverted to Default Settings.
echo Please restart your computer for changes to fully take effect.
pause
goto network_optimization

:netsh_error
echo.
echo !!! ERROR: Failed to execute NETSH command. Error Code: %errorlevel% !!!
echo Please ensure you are running this script as an Administrator and network services are functioning.
pause
goto network_optimization

:registry_error
echo.
echo !!! ERROR: Failed to modify Registry. Error Code: %errorlevel% !!!
echo Please ensure you are running this script as an Administrator.
echo Registry modification is required for this operation.
pause
goto network_optimization

:powershell_error
echo.
echo !!! ERROR: Failed to execute PowerShell command. Error Code: %errorlevel% !!!
echo Please ensure PowerShell is installed and functioning correctly.
pause
goto network_optimization

:sc_config_error
echo.
echo !!! ERROR: Failed to configure service using SC CONFIG. Error Code: %errorlevel% !!!
echo Please ensure you are running this script as an Administrator and the service name is correct.
pause
goto network_optimization

:sc_start_error
echo.
echo !!! ERROR: Failed to start service using SC START. Error Code: %errorlevel% !!!
echo Please ensure you are running this script as an Administrator and the service name is correct.
pause
goto network_optimization

:option_22
:endexit
echo Thank you for using the Windows Optimization Script!
echo Script developed by [GT Singtaro]
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
