@echo off
setlocal enabledelayedexpansion

:: Script Name: Win11_Optimizer.bat
:: Author: AI Assistant (Gemini Pro 2.5)
:: Version: 1.0
:: Date: 2023-10-27
:: Description: A comprehensive menu-driven batch script for Windows 11
::              system management and performance optimization.
:: Requires: Administrator privileges.

::----------------------------------------------------------------------
:: Initial Setup & Admin Check
::----------------------------------------------------------------------
title Windows 11 Performance & Management Tool

:: Check for Administrator Privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrative permissions confirmed. Proceeding...
    timeout /t 1 /nobreak > nul
) else (
    cls
    echo ======================================
    echo  ERROR: Administrator Privileges Required
    echo ======================================
    echo This script needs to be run as Administrator to function correctly.
    echo Please right-click the script and select 'Run as administrator'.
    echo.
    pause
    exit /b 1
)

:: Optional: Set Console Window Size (Uncomment if desired)
:: mode con: cols=120 lines=45

::----------------------------------------------------------------------
:: Main Menu Loop
::----------------------------------------------------------------------
:MainMenu
cls
echo =======================================================
echo       Windows 11 Performance & Management Tool
echo =======================================================
echo                   ** MAIN MENU **
echo -------------------------------------------------------
echo  [1] System Cleanup              [6] System Status & Monitoring
echo  [2] Resource Management         [7] CPU Optimizations
echo  [3] Settings Customization      [8] Network & Internet Tools
echo  [4] Security Operations         [9] Software & Driver Management
echo  [5] Data Backup & Restore
echo -------------------------------------------------------
echo [10] Run Recommended Quick Optimizations
echo  [0] Exit Script
echo -------------------------------------------------------
echo.
set /p "mainChoice=Enter your choice (0-10): "

if /i "%mainChoice%"=="1" goto CleanupMenu
if /i "%mainChoice%"=="2" goto ResourceManagerMenu
if /i "%mainChoice%"=="3" goto SettingsMenu
if /i "%mainChoice%"=="4" goto SecurityMenu
if /i "%mainChoice%"=="5" goto BackupRestoreMenu
if /i "%mainChoice%"=="6" goto StatusMonitorMenu
if /i "%mainChoice%"=="7" goto CPUOptMenu
if /i "%mainChoice%"=="8" goto NetworkMenu
if /i "%mainChoice%"=="9" goto SoftwareDriverMenu
if /i "%mainChoice%"=="10" goto QuickOptimizations
if /i "%mainChoice%"=="0" goto ExitScript

echo Invalid choice. Please try again.
timeout /t 2 /nobreak > nul
goto MainMenu

::----------------------------------------------------------------------
:: 1. System Cleanup Menu
::----------------------------------------------------------------------
:CleanupMenu
cls
echo =======================================================
echo                  System Cleanup Menu
echo =======================================================
echo  [1] Clean Windows Update Cache (SoftwareDistribution)
echo  [2] Clean Temporary Files (User & System)
echo  [3] Clean Prefetch Files
echo  [4] Empty Recycle Bin
echo  [5] Run Disk Cleanup Utility (cleanmgr - Interactive)
echo  [6] Run DISM Image Cleanup (Analyze/Clean Component Store)
echo.
echo  [0] Back to Main Menu
echo -------------------------------------------------------
echo.
set /p "cleanupChoice=Enter your choice (0-6): "

if /i "%cleanupChoice%"=="1" goto CleanUpdateCache
if /i "%cleanupChoice%"=="2" goto CleanTempFiles
if /i "%cleanupChoice%"=="3" goto CleanPrefetch
if /i "%cleanupChoice%"=="4" goto EmptyRecycleBin
if /i "%cleanupChoice%"=="5" goto RunDiskCleanup
if /i "%cleanupChoice%"=="6" goto RunDISMCleanup
if /i "%cleanupChoice%"=="0" goto MainMenu

echo Invalid choice. Please try again.
timeout /t 2 /nobreak > nul
goto CleanupMenu

:CleanUpdateCache
cls
echo --- Cleaning Windows Update Cache ---
echo Stopping Windows Update Service (wuauserv) and BITS...
net stop wuauserv > nul 2>&1
net stop bits > nul 2>&1
echo Services stopped (or were not running).
echo.
echo Deleting SoftwareDistribution Download folder contents...
if exist "%SystemRoot%\SoftwareDistribution\Download" (
    pushd "%SystemRoot%\SoftwareDistribution\Download"
    if exist *.* (
      rd /s /q "%SystemRoot%\SoftwareDistribution\Download" > nul 2>&1
      if !errorlevel! neq 0 (
          echo WARNING: Could not fully remove folder, likely files in use. Trying to delete contents...
          del /f /s /q *.* > nul 2>&1
      )
      md "%SystemRoot%\SoftwareDistribution\Download" > nul 2>&1
      echo Cache folder contents removed and folder recreated.
    ) else (
        echo Download folder is already empty.
    )
    popd
) else (
    echo SoftwareDistribution\Download folder not found.
)
echo.
echo Restarting Windows Update Service (wuauserv) and BITS...
net start bits > nul 2>&1
net start wuauserv > nul 2>&1
echo Services restarted.
echo.
echo Windows Update Cache cleanup attempted.
echo.
pause
goto CleanupMenu

:CleanTempFiles
cls
echo --- Cleaning Temporary Files ---
set cleanedUser=0
set cleanedSystem=0
echo Cleaning User Temp Files (%TEMP%)...
if exist "%TEMP%" (
    pushd "%TEMP%"
    del /q /f /s *.* > nul 2>&1
    :: Optionally delete folders too, but some might be needed by running apps
    :: for /d %%i in (*) do rd /s /q "%%i" > nul 2>&1
    popd
    set cleanedUser=1
    echo User Temp cleanup attempted. Errors for files currently in use are normal.
) else (
    echo User Temp folder (%TEMP%) not found or inaccessible.
)
echo.
echo Cleaning System Temp Files (%SystemRoot%\Temp)...
if exist "%SystemRoot%\Temp" (
    pushd "%SystemRoot%\Temp"
    del /q /f /s *.* > nul 2>&1
    :: Optionally delete folders too, but be cautious with system temp
    :: for /d %%i in (*) do rd /s /q "%%i" > nul 2>&1
    popd
    set cleanedSystem=1
    echo System Temp cleanup attempted. Errors for files currently in use are normal.
) else (
    echo System Temp folder (%SystemRoot%\Temp) not found or inaccessible.
)
echo.
if %cleanedUser%==1 echo User Temp Folder Cleaned (partially or fully).
if %cleanedSystem%==1 echo System Temp Folder Cleaned (partially or fully).
pause
goto CleanupMenu

:CleanPrefetch
cls
echo --- Cleaning Prefetch Files ---
echo Location: %SystemRoot%\Prefetch
echo Deleting *.pf files...
if exist "%SystemRoot%\Prefetch\*.pf" (
    del /q /f "%SystemRoot%\Prefetch\*.pf" > nul 2>&1
    if !errorlevel! equ 0 (
        echo Prefetch files deleted successfully. Windows will recreate them as needed.
    ) else (
        echo ERROR: Could not delete prefetch files (check permissions or file locks).
    )
) else (
    echo No .pf files found in Prefetch folder.
)
echo.
pause
goto CleanupMenu

:EmptyRecycleBin
cls
echo --- Emptying Recycle Bin ---
echo WARNING: This will permanently delete all files in the Recycle Bin for ALL drives.
set /p "confirmEmpty=Are you sure you want to continue? (Y/N): "
if /i not "%confirmEmpty%"=="Y" goto CleanupMenu

echo Emptying Recycle Bin...
rd /s /q %SystemDrive%\$Recycle.bin > nul 2>&1
if %errorlevel% equ 0 (
    echo Recycle Bin emptied successfully.
) else (
    echo Recycle Bin may already be empty or encountered an access issue (Errorlevel: %errorlevel%).
)
echo.
pause
goto CleanupMenu

:RunDiskCleanup
cls
echo --- Running Disk Cleanup Utility (cleanmgr.exe) ---
echo The Disk Cleanup utility will now open.
echo Please select the drive (usually C:) and the items you wish to clean manually.
echo Consider clicking 'Clean up system files' within the tool for more options (like Windows Update Cleanup).
start "" cleanmgr.exe
echo Disk Cleanup launched. Please follow the prompts in its window.
echo.
pause
goto CleanupMenu

:RunDISMCleanup
cls
echo --- Running DISM Component Store Cleanup ---
echo This uses Deployment Image Servicing and Management (DISM)
echo to analyze and potentially clean up the component store (WinSxS),
echo which can reclaim significant disk space over time.
echo.
echo Choose an option:
echo  [1] Analyze Component Store Size (Check if cleanup is needed)
echo  [2] Start Component Store Cleanup (Recommended - can take time)
echo  [0] Cancel
echo.
set /p "dismChoice=Enter choice (0-2): "

if /i "%dismChoice%"=="1" (
    echo Analyzing Component Store... Please wait, this may take a few minutes.
    Dism.exe /Online /Cleanup-Image /AnalyzeComponentStore
    echo Analysis complete. Check the 'Component Store Cleanup Recommended' line above.
) else if /i "%dismChoice%"=="2" (
    echo Starting Component Store Cleanup... This may take a considerable amount of time.
    echo Please be patient and do not interrupt the process.
    Dism.exe /Online /Cleanup-Image /StartComponentCleanup
    echo DISM cleanup process completed. Check output for status.
) else if /i "%dismChoice%"=="0" (
    goto CleanupMenu
) else (
    echo Invalid choice. Returning to Cleanup Menu.
    timeout /t 2 /nobreak > nul
    goto CleanupMenu
)
echo.
pause
goto CleanupMenu

::----------------------------------------------------------------------
:: 2. Resource Management Menu
::----------------------------------------------------------------------
:ResourceManagerMenu
cls
echo =======================================================
echo                Resource Management Menu
echo =======================================================
echo  [1] Show Top CPU Consuming Processes (approx.)
echo  [2] Show Top Memory Consuming Processes (Working Set)
echo  [3] Show Disk Space Usage (All Drives)
echo  [4] List All Running Processes (Detailed)
echo  [5] Terminate a Process (by PID or Name - Use Caution!)
echo  [6] Show System Memory Information (Total/Available)
echo.
echo  [0] Back to Main Menu
echo -------------------------------------------------------
echo.
set /p "resChoice=Enter your choice (0-6): "

if /i "%resChoice%"=="1" goto ShowTopCPU
if /i "%resChoice%"=="2" goto ShowTopMemory
if /i "%resChoice%"=="3" goto ShowDiskUsage
if /i "%resChoice%"=="4" goto ListProcesses
if /i "%resChoice%"=="5" goto TerminateProcessPrompt
if /i "%resChoice%"=="6" goto ShowMemoryInfo
if /i "%resChoice%"=="0" goto MainMenu

echo Invalid choice. Please try again.
timeout /t 2 /nobreak > nul
goto ResourceManagerMenu

:ShowTopCPU
cls
echo --- Top CPU Consuming Processes ---
echo Gathering data using WMIC (can be slow)... Please wait.
echo Note: PercentProcessorTime is cumulative since process start, not instantaneous.
echo Sorted by current approximate CPU usage percentage (descending).
echo Results might differ slightly from Task Manager's real-time view.
echo.
wmic path Win32_PerfFormattedData_PerfProc_Process where "Name != 'Idle' and Name != '_Total'" get Name, PercentProcessorTime, IDProcess /format:table | more
:: WMIC query to get formatted performance data, excluding Idle and Total processes.
:: '/format:table' presents it neatly. '| more' allows scrolling.
echo.
echo For precise real-time CPU usage, Task Manager (Ctrl+Shift+Esc) is recommended.
echo.
pause
goto ResourceManagerMenu

:ShowTopMemory
cls
echo --- Top Memory Consuming Processes (Working Set) ---
echo Gathering data using WMIC... Please wait.
echo Sorted by Working Set Size (Memory Usage) in bytes (descending).
echo.
wmic process get Name, ProcessId, WorkingSetSize /value | sort /r | more
:: WMIC 'process get' retrieves process info. '/value' gives 'Key=Value' format.
:: 'sort /r' sorts in reverse (descending) based on the lines (WorkingSetSize usually comes last per process).
:: '| more' allows scrolling through the potentially long list.
echo.
echo Working Set Size is shown in bytes. Divide by 1048576 for MB.
echo.
pause
goto ResourceManagerMenu

:ShowDiskUsage
cls
echo --- Disk Space Usage ---
echo Retrieving disk information for logical drives...
echo.
wmic logicaldisk where "DriveType=3" get Caption, Size, FreeSpace, VolumeName, Description /format:table
:: WMIC 'logicaldisk where "DriveType=3"' selects fixed hard drives.
:: Gets Caption (Drive Letter), Size (Bytes), FreeSpace (Bytes), Volume Name, and Description.
echo.
echo Size and FreeSpace are in bytes.
echo 1 GB = 1,073,741,824 Bytes (approx.)
echo 1 MB = 1,048,576 Bytes
echo.
pause
goto ResourceManagerMenu

:ListProcesses
cls
echo --- List All Running Processes (Detailed) ---
echo Retrieving process list using tasklist...
echo.
tasklist /fo TABLE /v | more
:: 'tasklist' lists processes. '/fo TABLE' formats as a table.
:: '/v' provides verbose output including PID, Session Name, Mem Usage, Status, User Name, CPU Time, Window Title.
:: '| more' enables scrolling.
echo.
echo Use PID (Process ID) or Image Name to terminate a process using Option 5.
echo.
pause
goto ResourceManagerMenu

:TerminateProcessPrompt
cls
echo --- Terminate a Process ---
echo ================== WARNING! ==================
echo Terminating processes forcefully can cause:
echo   - Loss of unsaved data in applications.
echo   - System instability if a critical process is stopped.
echo   - Unexpected program behavior.
echo Only terminate processes you understand or if an application is unresponsive.
echo Avoid terminating 'System', 'csrss.exe', 'wininit.exe', 'smss.exe', 'lsass.exe', 'services.exe', 'winlogon.exe'.
echo ==============================================
echo.
set /p "terminateChoice=Terminate by [P]ID or Image [N]ame? (P/N): "

if /i "%terminateChoice%"=="P" (
    set /p "pidToKill=Enter the PID of the process to terminate: "
    if not defined pidToKill (
        echo No PID entered. Aborting.
        timeout /t 2 /nobreak > nul
        goto ResourceManagerMenu
    )
    rem Validate if PID is numeric (basic check)
    echo "%pidToKill%" | findstr /r /c:"^[1-9][0-9]*$" > nul
    if errorlevel 1 (
       echo Invalid PID entered. PID must be a number. Aborting.
       timeout /t 3 /nobreak > nul
       goto ResourceManagerMenu
    )
    echo Attempting to terminate process with PID: %pidToKill%...
    taskkill /pid %pidToKill% /f /t
    :: /f = Force termination, /t = Terminate process and any child processes.
) else if /i "%terminateChoice%"=="N" (
    set /p "nameToKill=Enter the Image Name (e.g., notepad.exe) to terminate: "
    if not defined nameToKill (
        echo No Image Name entered. Aborting.
        timeout /t 2 /nobreak > nul
        goto ResourceManagerMenu
    )
    echo Attempting to terminate all processes with Image Name: %nameToKill%...
    taskkill /im "%nameToKill%" /f /t
    :: /im = Image Name filter. Quotes handle names with spaces.
) else (
    echo Invalid choice. Aborting.
    timeout /t 2 /nobreak > nul
    goto ResourceManagerMenu
)

echo Taskkill command sent. Check output above for success or failure.
echo.
pause
goto ResourceManagerMenu

:ShowMemoryInfo
cls
echo --- System Memory Information ---
echo Retrieving memory details...
echo.
echo Using systeminfo (provides basic overview):
systeminfo | findstr /b /c:"Total Physical Memory" /c:"Available Physical Memory" /c:"Virtual Memory: Max Size" /c:"Virtual Memory: Available" /c:"Virtual Memory: In Use"
echo.
echo Using WMIC (provides raw values):
wmic ComputerSystem get TotalPhysicalMemory /value
wmic OS get FreePhysicalMemory, TotalVirtualMemorySize, FreeVirtualMemory /value
echo.
echo Note:
echo TotalPhysicalMemory (WMIC) is in Bytes.
echo FreePhysicalMemory (WMIC) is in Kilobytes.
echo Virtual Memory values (WMIC) are in Kilobytes.
echo Available Physical Memory (systeminfo) includes cached/standby memory that can be freed.
echo.
pause
goto ResourceManagerMenu

::----------------------------------------------------------------------
:: 3. Settings Customization Menu
::----------------------------------------------------------------------
:SettingsMenu
cls
echo =======================================================
echo               Settings Customization Menu
echo =======================================================
echo  [1] Manage Power Plans (List Current, Set Active)
echo  [2] Open Visual Effects Settings (SystemPropertiesPerformance)
echo  [3] Open Startup Apps Settings (Task Manager or Settings)
echo  [4] Open Background Apps Settings (Privacy - App Permissions)
echo  [5] Open Game Mode Settings
echo  [6] Enable / Disable Hibernation File (frees disk space)
echo.
echo  [0] Back to Main Menu
echo -------------------------------------------------------
echo Note: Most options open system dialogs or Settings pages directly.
echo       This script acts as a launcher for convenience.
echo.
set /p "settingsChoice=Enter your choice (0-6): "

if /i "%settingsChoice%"=="1" goto ManagePowerPlans
if /i "%settingsChoice%"=="2" goto OpenVisualEffects
if /i "%settingsChoice%"=="3" goto OpenStartupApps
if /i "%settingsChoice%"=="4" goto OpenBackgroundApps
if /i "%settingsChoice%"=="5" goto OpenGameMode
if /i "%settingsChoice%"=="6" goto ToggleHibernation
if /i "%settingsChoice%"=="0" goto MainMenu

echo Invalid choice. Please try again.
timeout /t 2 /nobreak > nul
goto SettingsMenu

:ManagePowerPlans
cls
echo --- Manage Power Plans ---
echo.
echo Listing Available Power Plans and Current Active Scheme:
echo -------------------------------------------------------
powercfg /list
echo -------------------------------------------------------
echo (The scheme marked with * is currently active)
echo.
set /p "setPlan=Do you want to set a different active power plan? (Y/N): "
if /i not "%setPlan%"=="Y" goto SettingsMenu

echo Enter the GUID of the power plan you wish to activate.
echo (Copy the GUID string from the list above, e.g., 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c)
set /p "planGuid="
if not defined planGuid (
    echo No GUID entered. Aborting.
    timeout /t 2 /nobreak > nul
    goto SettingsMenu
)
echo Setting active power plan to GUID: %planGuid%...
powercfg /setactive %planGuid%
echo.
echo Verifying the newly active plan:
echo -------------------------------------------------------
powercfg /getactivescheme
echo -------------------------------------------------------
echo.
pause
goto SettingsMenu

:OpenVisualEffects
cls
echo --- Opening Visual Effects Settings ---
echo This opens the 'Performance Options' dialog directly.
echo Adjusting settings here (e.g., 'Adjust for best performance') can impact UI responsiveness.
start "" SystemPropertiesPerformance.exe
echo System Properties (Performance Options) launched.
echo Navigate to the 'Visual Effects' tab.
echo.
pause
goto SettingsMenu

:OpenStartupApps
cls
echo --- Opening Startup Apps Settings ---
echo Managing startup applications can significantly improve boot time and reduce background resource usage.
echo Choose how to open the Startup Apps manager:
echo.
echo  [1] Task Manager (Classic Interface - Startup Tab)
echo  [2] Windows Settings App (Modern Interface - Apps > Startup)
echo  [0] Cancel
echo.
set /p "startupChoice=Enter choice (0-2): "
if /i "%startupChoice%"=="1" (
    echo Launching Task Manager...
    start "" taskmgr.exe
    echo Please navigate to the 'Startup' or 'Startup apps' tab in Task Manager.
) else if /i "%startupChoice%"=="2" (
    echo Launching Settings App (Startup Apps)...
    start "" ms-settings:startupapps
    echo Settings App (Apps > Startup) launched.
) else if /i "%startupChoice%"=="0" (
    goto SettingsMenu
) else (
    echo Invalid choice. Returning to menu.
    timeout /t 2 /nobreak > nul
    goto SettingsMenu
)
echo.
pause
goto SettingsMenu

:OpenBackgroundApps
cls
echo --- Opening Background Apps Settings ---
echo In modern Windows 11, managing background app permissions is often done per-app.
echo This command attempts to open the relevant Privacy settings page for App Permissions.
start "" ms-settings:privacy-backgroundapps
:: Fallback if the specific link doesn't work on all builds:
:: start "" ms-settings:privacy
echo Settings App (Background Apps / Privacy / App permissions) launched.
echo Review which apps are allowed to run in the background to potentially save resources.
echo.
pause
goto SettingsMenu

:OpenGameMode
cls
echo --- Opening Game Mode Settings ---
echo Game Mode aims to optimize your PC for gaming by prioritizing game processes
echo and limiting background activity when a game is detected.
start "" ms-settings:gaming-gamemode
echo Settings App (Gaming > Game Mode) launched.
echo.
pause
goto SettingsMenu

:ToggleHibernation
cls
echo --- Enable / Disable Hibernation ---
echo Hibernation saves your current session to a file (hiberfil.sys) on the hard drive
echo and then powers down the computer completely. Resuming is faster than a cold boot.
echo Disabling hibernation deletes hiberfil.sys, freeing disk space equal to a percentage
echo of your installed RAM, but removes the 'Hibernate' option from power menus.
echo Note: Fast Startup in Windows relies on the hibernation engine. Disabling hibernation
echo       will also effectively disable Fast Startup.
echo.
echo Checking current hibernation status...
powercfg /a | findstr /i /c:"Hibernation has not been enabled" /c:"The following sleep states are available on this system:"
:: More reliable check: check file existence
set HiberFileExists=0
if exist %SystemDrive%\hiberfil.sys set HiberFileExists=1
if %HiberFileExists% == 1 (
   echo Hibernation appears to be ENABLED (hiberfil.sys exists).
) else (
   echo Hibernation appears to be DISABLED (hiberfil.sys not found).
)
echo.
set /p "toggleHiber=Do you want to [E]nable or [D]isable Hibernation? (E/D/Cancel): "

if /i "%toggleHiber%"=="E" (
    echo Enabling Hibernation...
    powercfg /hibernate on
    if !errorlevel! equ 0 (
       echo Hibernation enabled successfully. The hiberfil.sys file will be created.
    ) else (
       echo ERROR: Failed to enable hibernation (Errorlevel: !errorlevel!). Check power settings or disk space.
    )
) else if /i "%toggleHiber%"=="D" (
    echo Disabling Hibernation...
    powercfg /hibernate off
     if !errorlevel! equ 0 (
       echo Hibernation disabled successfully. The hiberfil.sys file (if present) will be removed.
    ) else (
       echo ERROR: Failed to disable hibernation (Errorlevel: !errorlevel!).
    )
) else (
    echo Action cancelled. No changes made.
)
echo.
echo Verifying status again:
set HiberFileExists=0
if exist %SystemDrive%\hiberfil.sys set HiberFileExists=1
if %HiberFileExists% == 1 (
   echo Hibernation appears to be ENABLED (hiberfil.sys exists).
) else (
   echo Hibernation appears to be DISABLED (hiberfil.sys not found).
)
echo.
pause
goto SettingsMenu


::----------------------------------------------------------------------
:: 4. Security Operations Menu
::----------------------------------------------------------------------
:SecurityMenu
cls
echo =======================================================
echo                 Security Operations Menu
echo =======================================================
echo  [1] Run Windows Defender Quick Scan
echo  [2] Run Windows Defender Full Scan (Can take a VERY long time!)
echo  [3] Check Windows Defender Definition Status & Update Definitions
echo  [4] Run System File Checker (SFC /scannow - Checks system file integrity)
echo  [5] Run DISM Health Checks (Check/Scan/Restore Component Store)
echo  [6] Check Firewall Status (Current Profile)
echo  [7] Open Windows Security Center (Main Dashboard)
echo  [8] Open Windows Update Settings (Check for updates)
echo.
echo  [0] Back to Main Menu
echo -------------------------------------------------------
echo.
set /p "secChoice=Enter your choice (0-8): "

if /i "%secChoice%"=="1" goto RunDefenderQuickScan
if /i "%secChoice%"=="2" goto RunDefenderFullScan
if /i "%secChoice%"=="3" goto CheckDefenderDefs
if /i "%secChoice%"=="4" goto RunSFC
if /i "%secChoice%"=="5" goto RunDISMHealth
if /i "%secChoice%"=="6" goto CheckFirewallStatus
if /i "%secChoice%"=="7" goto OpenSecurityCenter
if /i "%secChoice%"=="8" goto OpenWindowsUpdate
if /i "%secChoice%"=="0" goto MainMenu

echo Invalid choice. Please try again.
timeout /t 2 /nobreak > nul
goto SecurityMenu

:RunDefenderQuickScan
cls
echo --- Running Windows Defender Quick Scan ---
echo This will scan common locations like startup folders, registry keys, and memory.
echo Please wait while the scan is initiated...
set DefenderPath="%ProgramFiles%\Windows Defender\MpCmdRun.exe"
if not exist %DefenderPath% set DefenderPath="%ProgramFiles(x86)%\Windows Defender\MpCmdRun.exe"

if exist %DefenderPath% (
    echo Found Defender CLI at %DefenderPath%
    %DefenderPath% -Scan -ScanType 1
    echo Quick Scan process initiated. Exit code: %errorlevel% (0 usually means success or completed).
    echo Note: The command initiates the scan; progress might continue in the background.
    echo You can monitor the full progress in the Windows Security Center (Option 7).
) else (
    echo ERROR: Windows Defender command line tool (MpCmdRun.exe) not found in standard locations.
)
echo.
pause
goto SecurityMenu

:RunDefenderFullScan
cls
echo --- Running Windows Defender Full Scan ---
echo ================== WARNING! ==================
echo A Full Scan checks ALL files and running programs on ALL connected drives.
echo This process can take SEVERAL HOURS to complete depending on the amount of data
echo and the speed of your system. Your computer may run slower during the scan.
echo ==============================================
echo.
set /p "confirmFullScan=Are you sure you want to start a Full Scan? (Y/N): "
if /i not "%confirmFullScan%"=="Y" goto SecurityMenu

echo Starting Full Scan... This will take a very long time. Please be patient.
set DefenderPath="%ProgramFiles%\Windows Defender\MpCmdRun.exe"
if not exist %DefenderPath% set DefenderPath="%ProgramFiles(x86)%\Windows Defender\MpCmdRun.exe"

if exist %DefenderPath% (
    echo Found Defender CLI at %DefenderPath%
    %DefenderPath% -Scan -ScanType 2
    echo Full Scan process initiated. Exit code: %errorlevel% (0 usually means success or completed).
    echo Note: The command initiates the scan; progress might continue in the background for hours.
    echo You can monitor the full progress in the Windows Security Center (Option 7).
) else (
    echo ERROR: Windows Defender command line tool (MpCmdRun.exe) not found in standard locations.
)
echo.
pause
goto SecurityMenu

:CheckDefenderDefs
cls
echo --- Checking/Updating Windows Defender Definitions ---
set DefenderPath="%ProgramFiles%\Windows Defender\MpCmdRun.exe"
if not exist %DefenderPath% set DefenderPath="%ProgramFiles(x86)%\Windows Defender\MpCmdRun.exe"

if exist %DefenderPath% (
    echo Found Defender CLI at %DefenderPath%
    echo.
    echo Attempting to update definitions (requires internet)...
    %DefenderPath% -SignatureUpdate
    echo Update check initiated/completed. Exit code: %errorlevel% (0 = success/up-to-date, 2 = failed).
    echo.
    echo Displaying current definition status:
    echo -------------------------------------
    %DefenderPath% -GetFiles | findstr /i "Engine Version Antivirus Antispyware Network"
    echo -------------------------------------
) else (
    echo ERROR: Windows Defender command line tool (MpCmdRun.exe) not found in standard locations.
)
echo.
pause
goto SecurityMenu

:RunSFC
cls
echo --- Running System File Checker (SFC /scannow) ---
echo This utility scans the integrity of all protected Windows system files
echo and replaces corrupted or incorrect versions with correct Microsoft versions.
echo This process may take some time (5-15 minutes typically). Please wait...
echo Do NOT close this window during the scan.
echo.
sfc /scannow
echo.
echo SFC scan completed. Review the messages above:
echo - "Windows Resource Protection did not find any integrity violations." -> No issues found.
echo - "Windows Resource Protection found corrupt files and successfully repaired them." -> Issues found and FIXED.
echo - "Windows Resource Protection found corrupt files but was unable to fix some of them." -> Issues found, NOT fixed. Try DISM RestoreHealth (Option 5.3) and run SFC again afterwards.
echo - Other errors may indicate SFC couldn't run.
echo.
pause
goto SecurityMenu

:RunDISMHealth
cls
echo --- Running DISM Health Checks (Component Store) ---
echo DISM can check and repair the Windows Component Store, which holds system files
echo and is used by SFC and Windows Update. Running these can fix deeper issues
echo that SFC alone cannot resolve. Requires Administrator privileges.
echo.
echo Choose an option:
echo  [1] CheckHealth (Quick check - Checks for corruption flags set by a failed process)
echo  [2] ScanHealth (Thorough scan - Verifies integrity of the component store. Takes longer)
echo  [3] RestoreHealth (Scans AND attempts repairs - Uses Windows Update by default. Needs Internet. Takes the longest)
echo  [0] Cancel
echo.
set /p "dismHealthChoice=Enter choice (0-3): "

if /i "%dismHealthChoice%"=="1" (
    echo Running DISM /Online /Cleanup-Image /CheckHealth...
    Dism.exe /Online /Cleanup-Image /CheckHealth
    echo CheckHealth complete. Indicates if corruption HAS BEEN DETECTED previously.
) else if /i "%dismHealthChoice%"=="2" (
    echo Running DISM /Online /Cleanup-Image /ScanHealth... This may take 5-20 minutes.
    Dism.exe /Online /Cleanup-Image /ScanHealth
    echo ScanHealth complete. Indicates if component store corruption IS CURRENTLY DETECTED.
) else if /i "%dismHealthChoice%"=="3" (
    echo Running DISM /Online /Cleanup-Image /RestoreHealth...
    echo This can take a significant amount of time (10-30+ minutes) and requires
    echo an active internet connection by default to download repair files from Windows Update.
    echo Please be patient and ensure connection stability.
    Dism.exe /Online /Cleanup-Image /RestoreHealth
    echo RestoreHealth complete. Check output for success or failure messages.
    echo If successful, it's recommended to run SFC /scannow (Option 4) again afterwards.
    echo If RestoreHealth fails, advanced troubleshooting (e.g., using install media as source) may be needed.
) else if /i "%dismHealthChoice%"=="0" (
    goto SecurityMenu
) else (
    echo Invalid choice. Returning to Security Menu.
    timeout /t 2 /nobreak > nul
    goto SecurityMenu
)
echo.
pause
goto SecurityMenu

:CheckFirewallStatus
cls
echo --- Checking Windows Defender Firewall Status ---
echo Displaying status for all network profiles (Domain, Private, Public)...
echo.
netsh advfirewall show allprofiles state
echo.
echo 'State ON' means the firewall is active for that profile.
echo 'State OFF' means it is disabled. It is strongly recommended to keep it ON.
echo To configure firewall rules, use the Windows Security Center (Option 7) or 'wf.msc'.
echo.
pause
goto SecurityMenu

:OpenSecurityCenter
cls
echo --- Opening Windows Security Center ---
echo The central hub for managing Windows Defender Antivirus, Firewall, Account Protection, etc.
start "" windowsdefender:
echo Windows Security launched.
echo.
pause
goto SecurityMenu

:OpenWindowsUpdate
cls
echo --- Opening Windows Update Settings ---
echo Keeping Windows updated is crucial for security, stability, and performance.
start "" ms-settings:windowsupdate
echo Windows Update settings launched.
echo Please check for and install any available updates, including Optional Updates which may contain drivers.
echo.
pause
goto SecurityMenu


::----------------------------------------------------------------------
:: 5. Data Backup & Restore Menu
::----------------------------------------------------------------------
:BackupRestoreMenu
cls
echo =======================================================
echo               Data Backup & Restore Menu
echo =======================================================
echo === IMPORTANT: System Restore is NOT a full backup! ===
echo It protects system files/settings but NOT personal data (documents, photos, etc.).
echo Use File History or third-party tools for personal file backups.
echo -------------------------------------------------------
echo  [1] Create System Restore Point (Manual checkpoint)
echo  [2] List Existing System Restore Points
echo  [3] Open System Restore Utility (to revert system state)
echo  [4] Open Backup Settings (Configure File History / Other Backup Options)
echo.
echo  [0] Back to Main Menu
echo -------------------------------------------------------
echo.
set /p "backupChoice=Enter your choice (0-4): "

if /i "%backupChoice%"=="1" goto CreateRestorePoint
if /i "%backupChoice%"=="2" goto ListRestorePoints
if /i "%backupChoice%"=="3" goto OpenSystemRestore
if /i "%backupChoice%"=="4" goto OpenBackupSettings
if /i "%backupChoice%"=="0" goto MainMenu

echo Invalid choice. Please try again.
timeout /t 2 /nobreak > nul
goto BackupRestoreMenu

:CreateRestorePoint
cls
echo --- Create System Restore Point ---
echo System Restore Points allow you to revert critical system files, drivers,
echo and registry settings to the state they were in when the point was created.
echo Useful before installing new software, drivers, or making significant system changes.
echo System Protection must be enabled on your system drive (usually C:) for this to work.
echo.
set /p "restoreDesc=Enter a descriptive name for this restore point (e.g., 'Before_Driver_Install'): "
if not defined restoreDesc set "restoreDesc=Manual_Restore_Point_via_Script_%DATE%_%TIME:~0,2%%TIME:~3,2%"

echo Creating Restore Point with description: "%restoreDesc%"
echo This may take a few moments... Please wait.
echo.
:: Using PowerShell embedded within Batch for potentially more reliable creation/feedback
powershell.exe -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description '%restoreDesc%' -RestorePointType 'MODIFY_SETTINGS'"

set RP_ERRORLEVEL=%errorlevel%
if %RP_ERRORLEVEL% equ 0 (
    echo System Restore Point '%restoreDesc%' created successfully.
) else (
    echo FAILED to create System Restore Point (Error Code: %RP_ERRORLEVEL%).
    echo Possible Reasons:
    echo   - System Protection service is disabled or not configured for the system drive (C:).
    echo   - Insufficient disk space reserved for System Restore.
    echo   - Volume Shadow Copy Service (VSS) issues.
    echo   - Other system errors.
    echo Please check System Properties > System Protection settings.
)
echo.
pause
goto BackupRestoreMenu

:ListRestorePoints
cls
echo --- List Existing System Restore Points ---
echo Retrieving list of available restore points...
echo.
:: Using PowerShell for potentially better formatting
powershell.exe -ExecutionPolicy Bypass -Command "Get-ComputerRestorePoint | Format-Table -AutoSize"

:: Fallback using WMIC if PowerShell fails or isn't preferred
:: echo Using WMIC (alternative method):
:: wmic /namespace:\\root\default path SystemRestore get Description, CreationTime, RestorePointType, SequenceNumber /format:list
echo.
echo Note: CreationTime is usually in UTC. SequenceNumber is the internal ID.
echo Use the System Restore Utility (Option 3) to choose and revert to one of these points.
echo.
pause
goto BackupRestoreMenu

:OpenSystemRestore
cls
echo --- Opening System Restore Utility ---
echo This utility guides you through selecting a restore point and reverting your system state.
echo Close all open applications before proceeding with a restore.
echo The process requires a restart and cannot be interrupted once started.
start "" rstrui.exe
echo System Restore wizard launched. Follow the instructions carefully.
echo.
pause
goto BackupRestoreMenu

:OpenBackupSettings
cls
echo --- Opening Backup Settings ---
echo Windows provides options like File History for backing up personal files
echo to another drive, and links to older backup methods.
echo It is CRUCIAL to have a regular backup strategy for your important data.
start "" ms-settings:backup
echo Settings App (Backup options) launched.
echo Please configure File History or another backup solution suitable for your needs.
echo Consider external hard drives or cloud storage for reliable backups.
echo.
pause
goto BackupRestoreMenu


::----------------------------------------------------------------------
:: 6. System Status & Monitoring Menu
::----------------------------------------------------------------------
:StatusMonitorMenu
cls
echo =======================================================
echo            System Status & Monitoring Menu
echo =======================================================
echo  [1] Display Basic System Information (OS, Model, RAM, CPU)
echo  [2] Display Detailed CPU Information (Cores, Speed, Cache)
echo  [3] Display Memory Module Information (RAM sticks - details vary)
echo  [4] Check Disk Drive Health Status (SMART via WMIC - basic check)
echo  [5] Run Check Disk (CHKDSK - Read-Only Scan for C:)
echo  [6] Run Check Disk (CHKDSK - Scan and Fix C: - REQUIRES REBOOT!)
echo  [7] Display System Uptime (Time since last boot)
echo  [8] Open Performance Monitor (perfmon - advanced real-time monitoring)
echo  [9] Generate System Diagnostics Report (perfmon health report)
echo [10] Check Windows Activation Status
echo.
echo  [0] Back to Main Menu
echo -------------------------------------------------------
echo.
set /p "statusChoice=Enter your choice (0-10): "

if /i "%statusChoice%"=="1" goto ShowSysInfo
if /i "%statusChoice%"=="2" goto ShowCPUInfo
if /i "%statusChoice%"=="3" goto ShowMemModules
if /i "%statusChoice%"=="4" goto CheckDiskHealth
if /i "%statusChoice%"=="5" goto RunChkdskScan
if /i "%statusChoice%"=="6" goto RunChkdskFix
if /i "%statusChoice%"=="7" goto ShowUptime
if /i "%statusChoice%"=="8" goto OpenPerfMon
if /i "%statusChoice%"=="9" goto GenPerfReport
if /i "%statusChoice%"=="10" goto CheckActivation
if /i "%statusChoice%"=="0" goto MainMenu

echo Invalid choice. Please try again.
timeout /t 2 /nobreak > nul
goto StatusMonitorMenu

:ShowSysInfo
cls
echo --- Basic System Information ---
echo Retrieving key system details using systeminfo...
echo.
systeminfo | findstr /b /c:"OS Name" /c:"OS Version" /c:"System Manufacturer" /c:"System Model" /c:"System Type" /c:"Processor(s)" /c:"Total Physical Memory" /c:"BIOS Version" /c:"Windows Directory" /c:"Boot Device"
echo.
pause
goto StatusMonitorMenu

:ShowCPUInfo
cls
echo --- Detailed CPU Information ---
echo Retrieving CPU details using WMIC...
echo.
wmic cpu get Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed, L2CacheSize, L3CacheSize, Manufacturer, SocketDesignation, Status, CurrentVoltage /format:list
echo.
echo Notes:
echo   MaxClockSpeed is the base speed in MHz. Actual speed varies with Turbo Boost/Power Saving.
echo   Cache sizes are in KB.
echo   CurrentVoltage reporting depends on hardware/BIOS support (may show 0 or 10).
echo   Status: 1=Other, 2=Unknown, 3=Enabled, 4=Disabled(User), 5=Disabled(BIOS), 6=Disabled(Idle), 7=Reserved
echo.
pause
goto StatusMonitorMenu

:ShowMemModules
cls
echo --- Memory Module Information (RAM Sticks) ---
echo Retrieving details of installed RAM modules using WMIC...
echo Note: Accuracy of Speed, Manufacturer, PartNumber depends on system BIOS/SMBIOS data. May be incomplete.
echo.
wmic memorychip get BankLabel, Capacity, MemoryType, TypeDetail, Speed, Manufacturer, PartNumber, DeviceLocator, FormFactor /format:table
echo.
echo Notes:
echo   Capacity is in bytes (Divide by 1073741824 for GB).
echo   Speed is in MHz (e.g., 3200).
echo   MemoryType: 20=DDR, 21=DDR2, 22=DDR2 FB-DIMM, 24=DDR3, 26=DDR4, etc. (0=Unknown)
echo   FormFactor: 8=DIMM, 12=SODIMM, etc. (0=Unknown)
echo   BankLabel/DeviceLocator indicate physical slot (e.g., BANK 0 / DIMM A1).
echo.
pause
goto StatusMonitorMenu

:CheckDiskHealth
cls
echo --- Check Disk Drive Health Status (S.M.A.R.T.) ---
echo Using WMIC to query the basic Self-Monitoring, Analysis, and Reporting Technology (SMART) status.
echo This is a PREDICTIVE failure status, not a guarantee of health or failure.
echo.
echo Retrieving SMART status for physical disk drives...
wmic diskdrive get Index, Caption, Model, InterfaceType, Status, Size /format:table
echo.
echo Status Interpretation:
echo   'OK': Drive reports it is functioning normally according to its internal SMART checks.
echo   'Pred Fail': Predictive Failure. The drive has detected attributes exceeding thresholds, indicating increased risk of failure. BACK UP DATA IMMEDIATELY and plan replacement.
echo   'Error', 'Unknown', other non-'OK' statuses: May indicate issues with the drive or SMART reporting. Investigate further.
echo.
echo For detailed SMART attributes, specialized tools like CrystalDiskInfo are recommended.
echo.
pause
goto StatusMonitorMenu

:RunChkdskScan
cls
echo --- Run Check Disk (CHKDSK - Read-Only Scan C:) ---
echo This will scan the C: drive file system for errors without attempting to fix them.
echo It runs online and does not typically require a reboot.
echo The scan can take some time depending on drive size and usage.
echo.
echo Starting read-only scan for C:...
chkdsk C:
echo.
echo Check Disk scan completed. Review the summary output above for any errors found.
echo If errors like "found problems" or "errors detected" are reported, consider running
echo Option 6 (Scan and Fix), which requires a reboot.
echo.
pause
goto StatusMonitorMenu

:RunChkdskFix
cls
echo --- Run Check Disk (CHKDSK - Scan and Fix C:) ---
echo ================== WARNING! ==================
echo This command attempts to fix file system errors found on the C: drive (/F).
echo Because the system drive is in use, CHKDSK cannot lock it and will typically
echo ask to schedule the scan to run on the NEXT REBOOT.
echo The scan during reboot can take a significant amount of time (minutes to hours).
echo DO NOT interrupt the process (e.g., by powering off) as this could lead to data loss or prevent Windows from booting.
echo Ensure laptops are plugged into power before rebooting.
echo ==============================================
echo.
set /p "confirmChkdskFix=Are you sure you want to schedule CHKDSK /F on drive C: for the next reboot? (Y/N): "
if /i not "%confirmChkdskFix%"=="Y" goto StatusMonitorMenu

echo Scheduling 'chkdsk C: /F' for the next reboot...
chkdsk C: /F
echo.
echo Please review the message above carefully.
echo If it prompts: "Chkdsk cannot run because the volume is in use... Would you like to schedule this volume to be checked the next time the system restarts? (Y/N)"
echo >>> You MUST type 'Y' and press Enter in THIS command prompt window <<<
echo for the scan to be scheduled.
echo.
echo If scheduled, the scan will run automatically before Windows loads on your next restart.
echo.
pause
goto StatusMonitorMenu

:ShowUptime
cls
echo --- System Uptime ---
echo Retrieving the last boot time to calculate uptime...
echo.
set Uptime=Unknown
for /f "tokens=2 delims==" %%a in ('wmic os get lastbootuptime /value') do set BootTime=%%a
if defined BootTime (
    set BootYear=%BootTime:~0,4%
    set BootMonth=%BootTime:~4,2%
    set BootDay=%BootTime:~6,2%
    set BootHour=%BootTime:~8,2%
    set BootMinute=%BootTime:~10,2%
    set BootSecond=%BootTime:~12,2%
    echo Last Boot Time: %BootYear%-%BootMonth%-%BootDay% %BootHour%:%BootMinute%:%BootSecond%

    :: Simple approximation using systeminfo (less precise but easier in pure batch)
    systeminfo | find "System Boot Time:"
    systeminfo | find "System Up Time:"

    :: Calculating exact duration in pure batch is complex. The systeminfo output is usually sufficient.
) else (
    echo Could not retrieve boot time using WMIC.
    echo Trying systeminfo...
    systeminfo | find "System Boot Time:"
    systeminfo | find "System Up Time:"
)
echo.
pause
goto StatusMonitorMenu

:OpenPerfMon
cls
echo --- Opening Performance Monitor ---
echo Performance Monitor (perfmon) is an advanced MMC snap-in for detailed real-time
echo and historical system performance monitoring. You can track CPU, memory, disk,
echo network activity, and hundreds of other counters.
start "" perfmon.msc
echo Performance Monitor launched.
echo Explore 'Performance Monitor' for real-time graphs and 'Data Collector Sets' for logging.
echo.
pause
goto StatusMonitorMenu

:GenPerfReport
cls
echo --- Generate System Diagnostics Report ---
echo This uses Performance Monitor to collect system data for 60 seconds and then
echo generate a comprehensive HTML report detailing system health, performance issues,
echo and configuration information.
echo.
echo Starting data collection (runs for ~60 seconds)... Please wait.
perfmon /report
echo.
echo Report generation initiated. An HTML report should open automatically when complete.
echo If it doesn't open, check the output above for the report file path (usually under C:\PerfLogs\System\...).
echo This report can be valuable for diagnosing complex performance problems.
echo.
pause
goto StatusMonitorMenu

:CheckActivation
cls
echo --- Check Windows Activation Status ---
echo Running the Software License Manager script (slmgr.vbs) to check activation status...
echo This may take a moment.
echo.
cscript //nologo %windir%\system32\slmgr.vbs /dli
echo.
echo Review the 'License Status' line above:
echo   'Licensed' indicates successful activation.
echo   'Notification' or 'Initial grace period' may indicate activation issues or pending activation.
echo The output also shows partial product key and license type (Retail, OEM, Volume).
echo For expiration details (if applicable), use '/xpr' instead of '/dli'.
echo.
pause
goto StatusMonitorMenu


::----------------------------------------------------------------------
:: 7. CPU Optimizations Menu
::----------------------------------------------------------------------
:CPUOptMenu
cls
echo =======================================================
echo                   CPU Optimizations Menu
echo =======================================================
echo  [1] Monitor CPU Load (Basic WMIC View - Updates every 5s)
echo  [2] Adjust Process Priority (Advanced - Use with EXTREME Caution!)
echo  [3] View CPU Core Count and Speed (Link to Status Menu)
echo  [4] Manage Power Plans (Link to Settings Menu - Impacts CPU speed)
echo  [5] [Info] CPU Temperature & Thermal Management Recommendations
echo.
echo  [0] Back to Main Menu
echo -------------------------------------------------------
echo Note: Advanced CPU tuning (core parking, frequency locking, voltage)
echo       is BEYOND the scope of Batch scripts and typically requires
echo       BIOS/UEFI settings or specialized manufacturer utilities.
echo.
set /p "cpuChoice=Enter your choice (0-5): "

if /i "%cpuChoice%"=="1" goto MonitorCPULoadBasic
if /i "%cpuChoice%"=="2" goto AdjustProcessPriorityPrompt
if /i "%cpuChoice%"=="3" goto ShowCPUInfo_Link
if /i "%cpuChoice%"=="4" goto ManagePowerPlans_Link
if /i "%cpuChoice%"=="5" goto InfoThermalMgmt
if /i "%cpuChoice%"=="0" goto MainMenu

echo Invalid choice. Please try again.
timeout /t 2 /nobreak > nul
goto CPUOptMenu

:MonitorCPULoadBasic
cls
echo --- Monitor CPU Load (Basic WMIC View) ---
echo This view refreshes every 5 seconds using WMIC. Press Ctrl+C to stop.
echo Shows approximate current percentage load per process (excluding Idle/_Total).
echo.
:CPULoop
cls
echo Refreshing CPU Load... Current Time: %TIME% (Press Ctrl+C to Stop)
echo ==================================================================
wmic path Win32_PerfFormattedData_PerfProc_Process where "Name != 'Idle' and Name != '_Total'" get Name, PercentProcessorTime, IDProcess /format:table
echo ==================================================================
timeout /t 5 /nobreak > nul
goto CPULoop
:: Note: User must press Ctrl+C to exit this loop. Script execution will stop here.
:: Graceful exit from loop requires more complex handling not easily done in pure batch.
goto CPUOptMenu :: This line likely won't be reached after Ctrl+C

:AdjustProcessPriorityPrompt
cls
echo --- Adjust Process Priority ---
echo ================== WARNING! DANGER! ==================
echo Changing process priorities from 'Normal' is for ADVANCED USERS ONLY.
echo Incorrect settings can severely impact system performance and stability.
echo   - Setting HIGH/REALTIME can starve critical system processes, leading to freezes or crashes.
echo   - Setting LOW/IDLE can make applications unresponsive.
echo USE EXTREME CAUTION. PROCEED AT YOUR OWN RISK.
echo =======================================================
echo.
echo First, you need the Process ID (PID) of the target process.
echo Use Option 4 in the Resource Management Menu ([2]) to find the PID.
echo.
set /p "targetPID=Enter the PID of the process to modify priority for: "
if not defined targetPID ( echo No PID entered. Aborting. & timeout /t 2 /nobreak > nul & goto CPUOptMenu )
echo "%targetPID%" | findstr /r /c:"^[1-9][0-9]*$" > nul
if errorlevel 1 ( echo Invalid PID entered. PID must be a number. Aborting. & timeout /t 3 /nobreak > nul & goto CPUOptMenu )

echo.
echo Available Priority Levels (Use the numeric value):
echo   64  = Idle (Lowest)
echo   16384 = Below Normal
echo   32  = Normal (Default for most applications)
echo   32768 = Above Normal
echo   128 = High
echo   256 = Realtime (EXTREMELY DANGEROUS - Avoid unless you know EXACTLY why)
echo.
set /p "newPriorityValue=Enter the NUMERIC value for the desired priority: "

:: Validate numeric input and range (basic check)
set validPriority=0
for %%p in (64 16384 32 32768 128 256) do (
    if "%newPriorityValue%"=="%%p" set validPriority=1
)
if "%validPriority%"=="0" (
    echo Invalid numeric priority value entered: "%newPriorityValue%". Aborting.
    timeout /t 3 /nobreak > nul
    goto CPUOptMenu
)

echo Attempting to set priority %newPriorityValue% for PID %targetPID%...
wmic process where ProcessId="%targetPID%" call setpriority %newPriorityValue%

set PRIO_ERRORLEVEL=%errorlevel%
if %PRIO_ERRORLEVEL% equ 0 (
   echo Priority change command sent successfully.
   echo Verification (Current Priority):
   wmic process where ProcessId="%targetPID%" get Name, ProcessId, Priority /format:list
   echo (Note: This priority value might differ slightly from the input value but represents the category.)
) else (
   echo FAILED to set priority (Error Code: %PRIO_ERRORLEVEL%).
   echo Ensure PID %targetPID% exists and is not a protected system process. Check permissions.
)
echo.
pause
goto CPUOptMenu

:ShowCPUInfo_Link
cls
echo --- Linking to Detailed CPU Information (System Status Menu Option 2) ---
timeout /t 2 /nobreak > nul
goto ShowCPUInfo

:ManagePowerPlans_Link
cls
echo --- Linking to Power Plan Management (Settings Menu Option 1) ---
echo Power plans (Balanced, High Performance, Power Saver) directly influence CPU speed scaling and performance.
timeout /t 2 /nobreak > nul
goto ManagePowerPlans

:InfoThermalMgmt
cls
echo --- Information: CPU Temperature & Thermal Management ---
echo Keeping your CPU cool is vital for sustained performance and hardware longevity.
echo When a CPU gets too hot, it engages 'Thermal Throttling', automatically reducing
echo its speed (and thus performance) to prevent damage.
echo.
echo Key Factors & Recommendations:
echo * **Airflow:** Ensure PC case vents are clear. Clean dust from fans (CPU, case, GPU) and heatsinks regularly using compressed air. Good airflow is paramount.
echo * **Fans:** Verify CPU and case fans are spinning correctly. Listen for unusual noises.
echo * **Ambient Temperature:** A cooler room helps keep PC temperatures lower.
echo * **Monitoring:** Batch scripts CANNOT reliably read CPU temperatures. Use dedicated third-party software:
echo     - HWMonitor (CPUID)
echo     - Core Temp
echo     - HWiNFO64
echo     - Manufacturer-specific utilities (e.g., Ryzen Master, Intel XTU)
echo     Monitor temps under IDLE (desktop) and LOAD (gaming, video rendering, stress test) conditions. Check your CPU's safe operating temperature ('Tjmax') online.
echo * **Power Plans:** 'High Performance' plan keeps CPU clocks higher, potentially increasing heat. 'Balanced' is generally recommended for a mix of performance and efficiency.
echo * **Laptops:** Never block ventilation grills (e.g., by using on a soft surface like a bed or sofa). Consider a quality laptop cooling pad if needed.
echo * **Thermal Paste:** The paste between the CPU and its heatsink transfers heat. It degrades over years. If temps are consistently high despite clean fans/good airflow, reapplying thermal paste may help (moderate to advanced task).
echo.
echo Maintaining good thermals is proactive performance optimization!
echo.
pause
goto CPUOptMenu


::----------------------------------------------------------------------
:: 8. Network & Internet Tools Menu
::----------------------------------------------------------------------
:NetworkMenu
cls
echo =======================================================
echo               Network & Internet Tools Menu
echo =======================================================
echo Common tools for diagnosing connectivity and network configuration issues.
echo -------------------------------------------------------
echo  [1] Ping a Host (Test reachability & latency)
echo  [2] Display Full IP Configuration (ipconfig /all)
echo  [3] Flush DNS Resolver Cache (Clear cached website lookups)
echo  [4] Renew IP Configuration (Release/Renew DHCP lease)
echo  [5] Reset TCP/IP Stack (Network protocol reset - REQUIRES REBOOT!)
echo  [6] Reset Winsock Catalog (Network socket reset - REQUIRES REBOOT!)
echo  [7] Run Network & Internet Troubleshooter (Windows built-in)
echo  [8] View Active Network Connections (netstat -ano)
echo.
echo  [0] Back to Main Menu
echo -------------------------------------------------------
echo Note: Options 5 & 6 are powerful fixes but require a restart.
echo.
set /p "netChoice=Enter your choice (0-8): "

if /i "%netChoice%"=="1" goto PingHost
if /i "%netChoice%"=="2" goto ShowIPConfig
if /i "%netChoice%"=="3" goto FlushDNS
if /i "%netChoice%"=="4" goto RenewIP
if /i "%netChoice%"=="5" goto ResetTCPIP
if /i "%netChoice%"=="6" goto ResetWinsock
if /i "%netChoice%"=="7" goto RunNetTroubleshooter
if /i "%netChoice%"=="8" goto ViewNetConnections
if /i "%netChoice%"=="0" goto MainMenu

echo Invalid choice. Please try again.
timeout /t 2 /nobreak > nul
goto NetworkMenu

:PingHost
cls
echo --- Ping a Host ---
set /p "hostToPing=Enter the hostname or IP address to ping (e.g., google.com or 8.8.8.8): "
if not defined hostToPing set "hostToPing=8.8.8.8"

echo Pinging %hostToPing% with 4 packets...
echo.
ping %hostToPing%
echo.
echo Ping results:
echo   'Reply from...': Successful communication. 'time=' shows latency in ms.
echo   'Request timed out': No reply received within the default time limit.
echo   'Destination host unreachable': Router or local system cannot find a route.
echo   'Ping request could not find host...': DNS issue or incorrect hostname.
echo.
pause
goto NetworkMenu

:ShowIPConfig
cls
echo --- Display Full IP Configuration ---
echo Retrieving detailed network adapter configuration using 'ipconfig /all'...
echo.
ipconfig /all | more
echo.
echo Look for your active network adapter (Ethernet or Wi-Fi). Key information includes:
echo   - IPv4 Address, Subnet Mask, Default Gateway
echo   - DNS Servers
echo   - DHCP Enabled (Yes/No), DHCP Server
echo   - Physical Address (MAC Address)
echo.
pause
goto NetworkMenu

:FlushDNS
cls
echo --- Flush DNS Resolver Cache ---
echo This clears the local cache of DNS name-to-IP address resolutions.
echo Useful if you're having trouble accessing a specific website that may have
echo recently changed its IP address, or experiencing unusual redirect issues.
echo.
ipconfig /flushdns
echo.
echo DNS Resolver Cache flushed successfully (or was already empty).
echo.
pause
goto NetworkMenu

:RenewIP
cls
echo --- Renew IP Configuration (DHCP) ---
echo This command attempts to release the current IP address assigned by your
echo DHCP server (usually your router) and request a new one.
echo Useful for resolving IP address conflicts or if DHCP isn't assigning an address correctly.
echo Note: This only works for network adapters configured to obtain an IP address automatically (DHCP).
echo It will have no effect on statically assigned IP addresses.
echo.
echo Releasing current IP configuration for all adapters...
ipconfig /release
echo.
echo Renewing IP configuration for all adapters...
ipconfig /renew
echo.
echo IP release/renew process attempted. Check 'ipconfig /all' (Option 2) to verify the new configuration.
echo If errors occur (e.g., "Unable to contact your DHCP server"), check router/network connection.
echo.
pause
goto NetworkMenu

:ResetTCPIP
cls
echo --- Reset TCP/IP Stack ---
echo ================== WARNING! ==================
echo This command rewrites critical TCP/IP registry keys to their default state.
echo It can resolve complex, persistent network connectivity problems caused by
echo corrupted TCP/IP configuration (e.g., after malware removal or software conflicts).
echo >>> A SYSTEM REBOOT IS REQUIRED <<< after running this command for changes to take effect.
echo Save all work before proceeding and rebooting.
echo ==============================================
echo.
set /p "confirmTcpReset=Are you sure you want to reset the TCP/IP stack and REBOOT afterwards? (Y/N): "
if /i not "%confirmTcpReset%"=="Y" goto NetworkMenu

echo Resetting TCP/IP stack using 'netsh int ip reset'...
netsh int ip reset resetlog.txt
:: Log file 'resetlog.txt' will be created in the current directory (%~dp0 or system32 if run directly)

set RESET_ERROR=%errorlevel%
if %RESET_ERROR% equ 0 (
   echo TCP/IP stack reset command executed successfully.
   echo >>> IMPORTANT: You MUST REBOOT your computer NOW <<< for the changes to be applied.
) else (
   echo ERROR: Failed to execute TCP/IP reset command (Error Code: %RESET_ERROR%).
   echo Ensure you are running the script as Administrator.
   echo A reboot is likely still required if partial changes were made.
)
echo.
pause
goto NetworkMenu

:ResetWinsock
cls
echo --- Reset Winsock Catalog ---
echo ================== WARNING! ==================
echo This command resets the Winsock Catalog back to its default clean state.
echo Winsock handles network input/output requests for applications. Corruption here
echo (often due to malware, firewalls, or network software installs) can cause various
echo connectivity issues (e.g., unable to browse, specific apps can't connect).
echo >>> A SYSTEM REBOOT IS REQUIRED <<< after running this command for changes to take effect.
echo Save all work before proceeding and rebooting.
echo ==============================================
echo.
set /p "confirmWinsockReset=Are you sure you want to reset the Winsock Catalog and REBOOT afterwards? (Y/N): "
if /i not "%confirmWinsockReset%"=="Y" goto NetworkMenu

echo Resetting Winsock Catalog using 'netsh winsock reset'...
netsh winsock reset

set RESET_ERROR=%errorlevel%
if %RESET_ERROR% equ 0 (
   echo Winsock Catalog reset command executed successfully.
   echo >>> IMPORTANT: You MUST REBOOT your computer NOW <<< for the changes to be applied.
) else (
   echo ERROR: Failed to execute Winsock reset command (Error Code: %RESET_ERROR%).
   echo Ensure you are running the script as Administrator.
   echo A reboot is likely still required if partial changes were made.
)
echo.
pause
goto NetworkMenu

:RunNetTroubleshooter
cls
echo --- Run Network & Internet Troubleshooter ---
echo Launching the built-in Windows troubleshooter designed to automatically
echo detect and fix common network connectivity problems.
start "" msdt.exe /id NetworkDiagnosticsWeb
echo Please follow the prompts in the troubleshooter window. It may ask questions
echo or suggest fixes to apply.
echo.
pause
goto NetworkMenu

:ViewNetConnections
cls
echo --- View Active Network Connections (netstat -ano) ---
echo Displaying active TCP and UDP connections, listening ports, and the Process ID (PID)
echo of the executable associated with each connection.
echo This can help identify which programs are using the network.
echo.
echo Retrieving connections (this may take a few seconds)...
netstat -ano | more
:: -a Displays all active TCP connections and the TCP and UDP ports on which the computer is listening.
:: -n Displays addresses and port numbers in numerical form (prevents slow DNS lookups).
:: -o Displays the process identifier (PID) associated with each connection.
:: | more Allows scrolling through the output.
echo.
echo Columns: Proto | Local Address | Foreign Address | State | PID
echo   - Proto: Protocol (TCP/UDP)
echo   - Local Address: Your IP address and port number (0.0.0.0 means listening on all interfaces)
echo   - Foreign Address: Remote IP address and port number (*:* means listening or no established connection)
echo   - State: Connection state (LISTENING, ESTABLISHED, TIME_WAIT, CLOSE_WAIT, etc.)
echo   - PID: Process ID. Use Task Manager or 'tasklist' to match PID to an application name.
echo.
pause
goto NetworkMenu


::----------------------------------------------------------------------
:: 9. Software & Driver Management Menu
::----------------------------------------------------------------------
:SoftwareDriverMenu
cls
echo =======================================================
echo            Software & Driver Management Menu
echo =======================================================
echo Tools for managing installed applications and device drivers.
echo -------------------------------------------------------
echo  [1] Open Apps & Features (Uninstall/Modify Programs - Settings)
echo  [2] List Installed Software (via WMIC - may be slow/incomplete)
echo  [3] Check for App Updates (using Winget - requires Winget installed)
echo  [4] Upgrade All Upgradable Apps (using Winget - Use Caution!)
echo  [5] Open Device Manager (Manage Hardware & Drivers manually)
echo  [6] [Info] Driver Update Best Practices & Recommendations
echo.
echo  [0] Back to Main Menu
echo -------------------------------------------------------
echo Note: Winget options require the 'App Installer' from the Microsoft Store to be updated.
echo.
set /p "swChoice=Enter your choice (0-6): "

if /i "%swChoice%"=="1" goto OpenAppsFeatures
if /i "%swChoice%"=="2" goto ListInstalledSoftware
if /i "%swChoice%"=="3" goto WingetCheckUpdates
if /i "%swChoice%"=="4" goto WingetUpgradeAll
if /i "%swChoice%"=="5" goto OpenDeviceManager
if /i "%swChoice%"=="6" goto InfoDriverUpdates
if /i "%swChoice%"=="0" goto MainMenu

echo Invalid choice. Please try again.
timeout /t 2 /nobreak > nul
goto SoftwareDriverMenu

:OpenAppsFeatures
cls
echo --- Opening Apps & Features ---
echo This opens the Windows Settings page where you can uninstall, modify,
echo or reset installed applications (including Store apps and traditional desktop programs).
start "" ms-settings:appsfeatures
echo Settings App (Apps > Apps & features) launched.
echo.
pause
goto SoftwareDriverMenu

:ListInstalledSoftware
cls
echo --- List Installed Software (via WMIC) ---
echo Retrieving list of installed programs from Windows Management Instrumentation (WMI)...
echo Please wait, this can take a significant amount of time (minutes).
echo Note: This list primarily includes programs installed using Windows Installer (MSI)
echo       and may NOT include all installed software (e.g., many Store apps, portable apps,
echo       or programs installed via custom installers might be missing).
echo.
wmic product get Name, Version, Vendor, InstallDate /format:table | more
echo.
echo For a more complete view, use the Apps & Features settings page (Option 1) or specialized tools.
echo.
pause
goto SoftwareDriverMenu

:WingetCheckUpdates
cls
echo --- Check for App Updates (using Winget) ---
echo Checking if Winget (Windows Package Manager) is available...
where winget >nul 2>nul
if %errorlevel% neq 0 (
    echo ==================== Winget Not Found ====================
    echo ERROR: Windows Package Manager (winget.exe) not found in your system PATH.
    echo Winget is typically included with Windows 11 via the 'App Installer'
    echo app from the Microsoft Store.
    echo.
    echo To fix this:
    echo   1. Open the Microsoft Store app.
    echo   2. Search for 'App Installer'.
    echo   3. Ensure it is installed and UPDATED to the latest version.
    echo   4. Restart this script after updating App Installer.
    echo ==========================================================
    echo.
    pause
    goto SoftwareDriverMenu
)
echo Winget found.
echo.
echo Checking for available application updates using 'winget upgrade'...
echo This may take a moment as Winget queries its configured sources.
echo.
winget upgrade
echo.
echo The list above shows packages with available updates. Note the 'Name' and 'Id'.
echo Use Option 4 to attempt upgrading all listed packages automatically,
echo or manually run 'winget upgrade <PackageId>' in a separate Command Prompt or PowerShell.
echo.
pause
goto SoftwareDriverMenu

:WingetUpgradeAll
cls
echo --- Upgrade All Apps (using Winget) ---
echo Checking if Winget (Windows Package Manager) is available...
where winget >nul 2>nul
if %errorlevel% neq 0 (
    echo ==================== Winget Not Found ====================
    echo ERROR: Windows Package Manager (winget.exe) not found. See Option 3 for details.
    echo ==========================================================
    echo.
    pause
    goto SoftwareDriverMenu
)
echo Winget found.
echo.
echo ================== WARNING! ==================
echo This command ('winget upgrade --all') will attempt to automatically download
echo and install updates for ALL packages that Winget currently reports as upgradable.
echo   - This may include applications you prefer to update manually.
echo   - Some installers might still require user interaction or prompts.
echo   - Updates could potentially introduce unexpected issues (rare, but possible).
echo Consider reviewing the list from Option 3 first if unsure.
echo ==============================================
echo.
set /p "confirmWingetUpgrade=Are you sure you want to attempt upgrading ALL available packages via Winget? (Y/N): "
if /i not "%confirmWingetUpgrade%"=="Y" goto SoftwareDriverMenu

echo Starting 'winget upgrade --all' process...
echo Please monitor the output and respond to any installer prompts that may appear.
echo This may take some time depending on the number and size of updates.
echo Using flags to try and minimize prompts, but some installers ignore them.
echo.
winget upgrade --all --accept-source-agreements --accept-package-agreements --silent
:: --silent flag added for less interaction, but might not work for all packages.
:: Remove --silent if you prefer to see installer UIs.
echo.
echo Winget upgrade process finished or attempted for all packages.
echo Review the output above for details on successes, failures, or skipped packages.
echo It's recommended to check Winget's logs for detailed information if issues occurred.
echo.
pause
goto SoftwareDriverMenu

:OpenDeviceManager
cls
echo --- Opening Device Manager ---
echo Device Manager (devmgmt.msc) allows you to view and manage all hardware
echo components recognized by Windows. You can:
echo   - Check device status (for errors - yellow exclamation mark!)
echo   - Update drivers (manually or search automatically)
echo   - Roll back drivers (if an update causes issues)
echo   - Disable or uninstall devices (Use caution!)
echo.
echo Be careful when making changes in Device Manager, especially uninstalling devices.
start "" devmgmt.msc
echo Device Manager launched.
echo.
pause
goto SoftwareDriverMenu

:InfoDriverUpdates
cls
echo --- Information: Driver Update Best Practices ---
echo Keeping device drivers updated is important for performance, stability, bug fixes,
echo and sometimes security, especially for Graphics Cards, Chipsets, and Network Adapters.
echo However, using the WRONG method can cause problems.
echo.
echo Recommended Hierarchy for Driver Updates:
echo 1.  **PC/Laptop Manufacturer Website:** (BEST for Laptops & Pre-built Desktops)
echo     Go to the Support section for your SPECIFIC model. Download drivers listed there,
echo     especially Chipset, Audio, Network, Wi-Fi/Bluetooth, Touchpad, and other integrated components.
echo     They provide tested drivers tailored for your system hardware.
echo 2.  **Component Manufacturer Website:** (BEST for individual components, esp. Graphics Cards)
echo     - **Graphics:** NVIDIA (GeForce Experience/Website), AMD (Adrenalin Software/Website), Intel (Graphics Command Center/Website). Get drivers directly from them.
echo     - **Motherboard:** (For custom-built PCs) Go to the motherboard manufacturer's website (ASUS, Gigabyte, MSI, ASRock) for Chipset, LAN, Audio drivers.
echo     - **Other Peripherals:** Printers, Scanners, Webcams often have drivers on their manufacturer's site.
echo 3.  **Windows Update:**
echo     Windows Update often delivers certified drivers automatically. Check Settings > Windows Update > Advanced options > Optional updates > Driver updates.
echo     This is generally safe but might not always provide the absolute latest version (especially for GPUs).
echo 4.  **Device Manager ('Update Driver'):**
echo     Can search online automatically, but often finds only generic or older drivers already known to Windows. Useful mainly if a device isn't working at all or to install a manually downloaded driver file (.inf).
echo.
echo !! AVOID Third-Party Driver Updater Tools !!
echo Generic "Driver Booster/Updater" software is often unnecessary and potentially HARMFUL.
echo They can install incorrect, unstable, outdated, or even malware-bundled drivers.
echo Stick to the official sources listed above (1, 2, 3).
echo.
pause
goto SoftwareDriverMenu


::----------------------------------------------------------------------
:: 10. Run Recommended Quick Optimizations
::----------------------------------------------------------------------
:QuickOptimizations
cls
echo =======================================================
echo         Run Recommended Quick Optimizations
echo =======================================================
echo This sequence performs several common, generally safe cleanup
echo and maintenance tasks quickly.
echo.
echo Tasks to be performed:
echo   [1] Clean Temporary Files (User: %TEMP%, System: C:\Windows\Temp)
echo   [2] Clean Prefetch Files (%SystemRoot%\Prefetch)
echo   [3] Flush DNS Resolver Cache
echo   [4] Run DISM Quick Component Store Cleanup (Non-intrusive version)
echo   [5] Optionally: Run SFC /scannow (System File Checker - can take time)
echo   [6] Optionally: Run Defender Quick Scan (Can take time)
echo.
set /p "confirmQuickOpt=Proceed with Quick Optimizations? (Y/N): "
if /i not "%confirmQuickOpt%"=="Y" goto MainMenu

echo.
echo --- Starting Quick Optimizations ---
echo.

:: 1. Clean Temp Files
echo [TASK 1/6] Cleaning Temporary Files...
set cleanedUser=0
set cleanedSystem=0
if exist "%TEMP%" ( pushd "%TEMP%" & del /q /f /s *.* > nul 2>&1 & popd & set cleanedUser=1 )
if exist "%SystemRoot%\Temp" ( pushd "%SystemRoot%\Temp" & del /q /f /s *.* > nul 2>&1 & popd & set cleanedSystem=1 )
if %cleanedUser%==1 echo    User Temp cleaned (errors for files in use are normal).
if %cleanedSystem%==1 echo    System Temp cleaned (errors for files in use are normal).
timeout /t 1 /nobreak > nul

:: 2. Clean Prefetch
echo [TASK 2/6] Cleaning Prefetch Files...
if exist "%SystemRoot%\Prefetch\*.pf" ( del /q /f "%SystemRoot%\Prefetch\*.pf" > nul 2>&1 )
echo    Prefetch files deleted (if any existed).
timeout /t 1 /nobreak > nul

:: 3. Flush DNS
echo [TASK 3/6] Flushing DNS Cache...
ipconfig /flushdns > nul
echo    DNS Cache flushed.
timeout /t 1 /nobreak > nul

:: 4. DISM Quick Cleanup
echo [TASK 4/6] Running DISM Quick Component Cleanup (may take a moment)...
Dism.exe /Online /Cleanup-Image /StartComponentCleanup /Quiet > nul
echo    DISM Quick Cleanup command sent (runs in background).
timeout /t 1 /nobreak > nul

:: 5. Optional SFC Scan
echo [TASK 5/6] System File Checker (SFC /scannow)...
set /p "runSFC=Run SFC Scan now? (Checks system files, can take 5-15 mins) (Y/N): "
if /i "%runSFC%"=="Y" (
    echo    Starting SFC /scannow... Please wait, do not close window.
    sfc /scannow
    echo    SFC scan finished. Review results above.
) else (
    echo    SFC Scan skipped by user.
)
timeout /t 1 /nobreak > nul

:: 6. Optional Defender Quick Scan
echo [TASK 6/6] Windows Defender Quick Scan...
set /p "runDefScan=Run Defender Quick Scan now? (Checks common malware locations, can take a few mins) (Y/N): "
if /i "%runDefScan%"=="Y" (
    echo    Initiating Defender Quick Scan...
    set DefenderPath="%ProgramFiles%\Windows Defender\MpCmdRun.exe"
    if not exist %DefenderPath% set DefenderPath="%ProgramFiles(x86)%\Windows Defender\MpCmdRun.exe"
    if exist %DefenderPath% (
        %DefenderPath% -Scan -ScanType 1
        echo    Defender Quick Scan initiated (check Security Center for results).
    ) else (
        echo    ERROR: MpCmdRun.exe not found, scan skipped.
    )
) else (
    echo    Defender Quick Scan skipped by user.
)

echo.
echo --- Quick Optimizations Sequence Completed ---
echo.
pause
goto MainMenu


::----------------------------------------------------------------------
:: Exit Script
::----------------------------------------------------------------------
:ExitScript
cls
echo =======================================================
echo Exiting Windows 11 Performance & Management Tool.
echo Thank you for using!
echo =======================================================
timeout /t 2 /nobreak > nul
exit /b 0

::----------------------------------------------------------------------
:: End of Script
::----------------------------------------------------------------------
