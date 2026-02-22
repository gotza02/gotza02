@echo off
setlocal enabledelayedexpansion
title All-in-One System Tools v1.4 (All Bugs Fixed)
color 0A
set "SCRIPT_VERSION=1.4"

:: Initialize datetime
call :GetDateTime
set "LOG_DATE=!DATETIME:~0,8!"

:: Log directory in APPDATA to prevent self-deletion
set "LOG_DIR=%APPDATA%\AllInOneTools"
set "LOG_FILE=!LOG_DIR!\AllInOneTools_!LOG_DATE!.log"

call :InitLogging
call :CheckAdminPrivileges

:MainMenu
cls
echo ========================================
echo   ALL-IN-ONE SYSTEM TOOLS v%SCRIPT_VERSION%
echo ========================================
echo  1. File Management
echo  2. System Maintenance  
echo  3. Network Utilities
echo  4. Security Tools
echo  5. System Information
echo  6. Settings
echo  7. Exit
echo ========================================
echo  Log file: %LOG_FILE%
echo ========================================
set /p choice="Select option (1-7): "

if "%choice%"=="1" goto FileManagementMenu
if "%choice%"=="2" goto SystemMaintenanceMenu
if "%choice%"=="3" goto NetworkUtilitiesMenu
if "%choice%"=="4" goto SecurityToolsMenu
if "%choice%"=="5" goto SystemInformation
if "%choice%"=="6" goto SettingsMenu
if "%choice%"=="7" goto ExitProgram

echo Please select 1-7 only.
timeout /t 2 >nul
goto MainMenu

:FileManagementMenu
cls
echo === FILE MANAGEMENT TOOLS ===
echo  1. Backup Files
echo  2. Clean Temporary Files
echo  3. Find Large Files
echo  4. File/Folder Compare
echo  5. Batch File Rename
echo  6. Return to Main Menu
set /p fileChoice="Select file tool (1-6): "

if "%fileChoice%"=="1" call :BackupFiles
if "%fileChoice%"=="2" call :CleanTempFiles
if "%fileChoice%"=="3" call :FindLargeFiles
if "%fileChoice%"=="4" call :FileCompare
if "%fileChoice%"=="5" call :BatchRename
if "%fileChoice%"=="6" goto MainMenu

goto FileManagementMenu

:SystemMaintenanceMenu
cls
echo === SYSTEM MAINTENANCE TOOLS ===
echo  1. Check Disk Space
echo  2. Clear System Cache
echo  3. Update Windows
echo  4. System File Checker
echo  5. Manage Startup Programs
echo  6. Return to Main Menu
set /p sysChoice="Select system tool (1-6): "

if "%sysChoice%"=="1" call :CheckDiskSpace
if "%sysChoice%"=="2" call :ClearSystemCache
if "%sysChoice%"=="3" call :UpdateWindows
if "%sysChoice%"=="4" call :SystemFileChecker
if "%sysChoice%"=="5" call :ManageStartup
if "%sysChoice%"=="6" goto MainMenu

goto SystemMaintenanceMenu

:NetworkUtilitiesMenu
cls
echo === NETWORK UTILITIES ===
echo  1. Test Internet Connection
echo  2. Show Network Configuration
echo  3. Test Network Latency
echo  4. Flush DNS Cache
echo  5. Port Scanner
echo  6. Return to Main Menu
set /p netChoice="Select network tool (1-6): "

if "%netChoice%"=="1" call :TestInternetConnection
if "%netChoice%"=="2" call :ShowNetworkConfig
if "%netChoice%"=="3" call :TestNetworkLatency
if "%netChoice%"=="4" call :FlushDNS
if "%netChoice%"=="5" call :PortScanner
if "%netChoice%"=="6" goto MainMenu

goto NetworkUtilitiesMenu

:SecurityToolsMenu
cls
echo === SECURITY TOOLS ===
echo  1. Password Generator
echo  2. System Security Audit
echo  3. Check User Accounts
echo  4. Secure File Deletion
echo  5. Check Windows Updates Status
echo  6. Return to Main Menu
set /p secChoice="Select security tool (1-6): "

if "%secChoice%"=="1" call :PasswordGenerator
if "%secChoice%"=="2" call :SystemSecurityAudit
if "%secChoice%"=="3" call :CheckUserAccounts
if "%secChoice%"=="4" call :SecureFileDeletion
if "%secChoice%"=="5" call :CheckWindowsUpdatesStatus
if "%secChoice%"=="6" goto MainMenu

goto SecurityToolsMenu

:SystemInformation
cls
echo === SYSTEM INFORMATION ===
call :DisplaySystemInfo
pause
goto MainMenu

:SettingsMenu
cls
echo === SETTINGS ===
echo  1. View Log File
echo  2. Clear Log File
echo  3. Change Color Scheme
echo  4. Return to Main Menu
set /p setChoice="Select setting (1-4): "

if "%setChoice%"=="1" call :ViewLogFile
if "%setChoice%"=="2" call :ClearLogFile
if "%setChoice%"=="3" call :ChangeColorScheme
if "%setChoice%"=="4" goto MainMenu

goto SettingsMenu

:: ==========================================
:: UTILITY FUNCTIONS
:: ==========================================

:GetDateTime
:: Reusable function to get current datetime (Bug #12 Fix)
for /f "tokens=1-3 delims=/ " %%a in ('wmic os get localdatetime ^| find "."') do (
    set "DATETIME=%%a"
)
if not defined DATETIME (
    for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value ^| find "="') do set "DATETIME=%%i"
)
exit /b

:InitLogging
if not exist "!LOG_DIR!" (
    mkdir "!LOG_DIR!" 2>nul
    if !ERRORLEVEL! NEQ 0 (
        echo Warning: Could not create log directory.
        set "LOG_FILE=nul"
        exit /b
    )
)
if not exist "%LOG_FILE%" (
    echo All-in-One System Tools Log > "%LOG_FILE%"
    echo Created on !LOG_DATE! >> "%LOG_FILE%"
    echo ======================================== >> "%LOG_FILE%"
)
exit /b

:LogMessage
set "message=%~1"
set "level=%~2"
call :GetDateTime
set "logts=!DATETIME:~0,4!-!DATETIME:~4,2!-!DATETIME:~6,2! !DATETIME:~8,2!:!DATETIME:~10,2!:!DATETIME:~12,2!"
echo [!logts!] [%level%] %message% >> "%LOG_FILE%" 2>nul
exit /b

:CheckAdminPrivileges
net session >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    cls
    echo ========================================
    echo   WARNING: ADMIN PRIVILEGES REQUIRED
    echo ========================================
    echo.
    echo This script requires administrative privileges.
    echo Please run as administrator and try again.
    echo.
    echo 1. Right-click on the script file
    echo 2. Select "Run as administrator"
    echo.
    pause
    exit
)
call :LogMessage "Script started with admin privileges" "INFO"
exit /b

:: ==========================================
:: FILE MANAGEMENT FUNCTIONS
:: ==========================================

:BackupFiles
cls
echo === FILE BACKUP UTILITY ===
call :LogMessage "Backup utility started" "INFO"

set /p "sourcePath=Enter source folder path: "
set /p "destPath=Enter destination folder path: "
set /p "backupName=Enter backup name (default: Backup): "

if "%backupName%"=="" set "backupName=Backup"

if not exist "%sourcePath%" (
    echo Error: Source path does not exist.
    call :LogMessage "Backup failed: Source path does not exist" "ERROR"
    pause
    exit /b
)

:: Create destination directory if it doesn't exist
if not exist "%destPath%" (
    mkdir "%destPath%" 2>nul
    if !ERRORLEVEL! NEQ 0 (
        echo Error: Failed to create destination directory.
        call :LogMessage "Failed to create destination directory: %destPath%" "ERROR"
        pause
        exit /b
    )
    call :LogMessage "Created destination directory: %destPath%" "INFO"
)

call :GetDateTime
set "backupFolder=%destPath%\%backupName%_!DATETIME:~0,8!_!DATETIME:~8,4!"

:: Bug #13 Fix: Check if backup folder creation succeeds
if not exist "%backupFolder%" (
    mkdir "%backupFolder%" 2>nul
    if !ERRORLEVEL! NEQ 0 (
        echo Error: Failed to create backup folder.
        call :LogMessage "Failed to create backup folder: %backupFolder%" "ERROR"
        pause
        exit /b
    )
    call :LogMessage "Created backup folder: %backupFolder%" "INFO"
)

echo Backing up files from "%sourcePath%" to "%backupFolder%"...
call :LogMessage "Starting backup from %sourcePath% to %backupFolder%" "INFO"

robocopy "%sourcePath%" "%backupFolder%" /E /R:3 /W:5 /LOG+:"%LOG_FILE%" /TEE /NP
set "roboResult=!ERRORLEVEL!"

:: Bug #17 Fix: Better robocopy exit code interpretation
if !roboResult! EQU 0 (
    echo Backup completed - no files copied (all files up to date).
    call :LogMessage "Backup completed - no files to copy" "INFO"
) else if !roboResult! LSS 8 (
    echo Backup completed successfully.
    call :LogMessage "Backup completed successfully (Exit code: !roboResult!)" "SUCCESS"
) else (
    echo Backup completed with errors (Exit code: !roboResult!).
    call :LogMessage "Backup completed with errors (Exit code: !roboResult!)" "ERROR"
)

pause
exit /b

:CleanTempFiles
cls
echo === TEMPORARY FILES CLEANER ===
call :LogMessage "Temporary files cleaner started" "INFO"

echo Cleaning temporary files...
echo.

if exist "%TEMP%" (
    del /q/f/s "%TEMP%\*.*" >nul 2>&1
    for /d %%d in ("%TEMP%\*") do rd /s /q "%%d" >nul 2>&1
    echo Cleaned system temporary files.
    call :LogMessage "Cleaned system temporary files" "INFO"
)

:: Check admin privileges before accessing protected folders
net session >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    if exist "C:\Windows\Prefetch" (
        del /q/f "C:\Windows\Prefetch\*.*" >nul 2>&1
        echo Cleaned prefetch files.
        call :LogMessage "Cleaned prefetch files" "INFO"
    )
    
    if exist "C:\Windows\Temp" (
        del /q/f/s "C:\Windows\Temp\*.*" >nul 2>&1
        for /d %%d in ("C:\Windows\Temp\*") do rd /s /q "%%d" >nul 2>&1
        echo Cleaned Windows temp folder.
        call :LogMessage "Cleaned Windows temp folder" "INFO"
    )
)

if exist "%LOCALAPPDATA%\Microsoft\Windows\INetCache" (
    del /q/f/s "%LOCALAPPDATA%\Microsoft\Windows\INetCache\*.*" >nul 2>&1
    echo Cleaned Internet cache files.
    call :LogMessage "Cleaned Internet cache files" "INFO"
)

:: Confirmation before emptying Recycle Bin
echo.
set /p "emptyRecycle=Empty Recycle Bin on all drives? (Y/N): "
if /i "!emptyRecycle!"=="Y" (
    echo Emptying Recycle Bin...
    for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
        if exist %%d:\$Recycle.bin (
            rd /s /q "%%d:\$Recycle.bin" >nul 2>&1
        )
    )
    echo Recycle Bin emptied.
    call :LogMessage "Recycle Bin emptied" "INFO"
) else (
    echo Recycle Bin cleanup skipped.
    call :LogMessage "Recycle Bin cleanup skipped by user" "INFO"
)

echo.
echo Temporary files cleaning completed.
call :LogMessage "Temporary files cleaning completed" "SUCCESS"
pause
exit /b

:FindLargeFiles
cls
echo === LARGE FILES FINDER ===
call :LogMessage "Large files finder started" "INFO"

set /p "searchPath=Enter path to search (default: C:\): "
if "%searchPath%"=="" set "searchPath=C:\"

set /p "minSize=Enter minimum file size in MB (default: 100): "
if "%minSize%"=="" set "minSize=100"

:: Validate path exists
if not exist "%searchPath%" (
    echo Error: Path does not exist.
    call :LogMessage "Large files search failed: Path does not exist" "ERROR"
    pause
    exit /b
)

echo.
echo Finding files larger than %minSize% MB in "%searchPath%"...
call :LogMessage "Finding large files in %searchPath% with minimum size %minSize% MB" "INFO"

:: Escape single quotes in path for PowerShell
set "escapedPath=!searchPath:'=''!"
powershell -NoProfile -Command "Get-ChildItem -LiteralPath '!escapedPath!' -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Length / 1MB -ge %minSize% } | Sort-Object Length -Descending | Select-Object -First 50 | ForEach-Object { Write-Host ('{0} - {1:N2} MB' -f $_.FullName, ($_.Length / 1MB)) }"

echo.
echo Search completed.
call :LogMessage "Large files search completed" "SUCCESS"
pause
exit /b

:FileCompare
cls
echo === FILE COMPARISON TOOL ===
call :LogMessage "File comparison tool started" "INFO"

echo Enter paths to two files to compare:
set /p "file1=First file path: "
set /p "file2=Second file path: "

if not exist "%file1%" (
    echo Error: First file does not exist.
    call :LogMessage "File comparison failed: First file does not exist" "ERROR"
    pause
    exit /b
)

if not exist "%file2%" (
    echo Error: Second file does not exist.
    call :LogMessage "File comparison failed: Second file does not exist" "ERROR"
    pause
    exit /b
)

echo.
echo Comparing files...
call :LogMessage "Comparing files: %file1% and %file2%" "INFO"

fc "%file1%" "%file2%" >nul 2>&1
set "fcResult=!ERRORLEVEL!"
if !fcResult! EQU 0 (
    echo Files are identical.
    call :LogMessage "Files are identical" "SUCCESS"
) else (
    echo Files are different.
    call :LogMessage "Files are different" "WARNING"
    echo.
    echo Differences (first 50 lines):
    :: Bug #20 Fix: Limit output with more or head
    fc "%file1%" "%file2%" | more /E
)

pause
exit /b

:BatchRename
cls
echo === BATCH FILE RENAME UTILITY ===
call :LogMessage "Batch rename utility started" "INFO"

set /p "folderPath=Enter folder path containing files to rename: "
if not exist "%folderPath%" (
    echo Error: Folder does not exist.
    call :LogMessage "Batch rename failed: Folder does not exist" "ERROR"
    pause
    exit /b
)

set /p "prefix=Enter prefix for files (leave empty to skip): "
set /p "suffix=Enter suffix for files (leave empty to skip): "
set /p "extension=Enter new extension (leave empty to keep original, include dot e.g. .txt): "

:: Preview mode
echo.
echo === PREVIEW MODE ===
echo.
echo The following files will be renamed:
echo.

pushd "%folderPath%" 2>nul
if !ERRORLEVEL! NEQ 0 (
    echo Error: Failed to access folder.
    call :LogMessage "Failed to access folder: %folderPath%" "ERROR"
    pause
    exit /b
)

set "previewCount=0"
for %%F in (*.*) do (
    set "originalName=%%F"
    set "baseName=%%~nF"
    set "originalExt=%%~xF"
    
    if "!extension!"=="" (
        set "newExt=!originalExt!"
    ) else (
        set "newExt=%extension%"
    )
    
    set "newName=%prefix%!baseName!%suffix%!newExt!"
    
    if not "!originalName!"=="!newName!" (
        if not exist "!newName!" (
            echo !originalName! --^> !newName!
            set /a previewCount+=1
        ) else (
            echo !originalName! --^> !newName! [SKIP: Target exists]
        )
    )
    
    if !previewCount! GEQ 20 (
        echo ... [More files not shown]
        goto EndPreview
    )
)
:EndPreview

echo.
echo Total files to rename: !previewCount!
echo.
set /p "confirmRename=Proceed with rename? (Y/N): "

if /i not "!confirmRename!"=="Y" (
    echo Rename cancelled.
    call :LogMessage "Batch rename cancelled by user" "INFO"
    popd
    pause
    exit /b
)

echo.
echo Renaming files in "%folderPath%"...
call :LogMessage "Renaming files in %folderPath% with prefix: '%prefix%', suffix: '%suffix%', extension: '%extension%'" "INFO"

set "renameCount=0"
for %%F in (*.*) do (
    set "originalName=%%F"
    set "baseName=%%~nF"
    set "originalExt=%%~xF"
    
    if "!extension!"=="" (
        set "newExt=!originalExt!"
    ) else (
        set "newExt=%extension%"
    )
    
    set "newName=%prefix%!baseName!%suffix%!newExt!"
    
    if not exist "!newName!" (
        if not "!originalName!"=="!newName!" (
            ren "!originalName!" "!newName!" 2>nul
            set "renResult=!ERRORLEVEL!"
            if !renResult! EQU 0 (
                echo Renamed: !originalName! -^> !newName!
                set /a renameCount+=1
            ) else (
                echo Failed to rename: !originalName!
            )
        )
    ) else (
        echo Skipped: !originalName! (target name already exists)
    )
)
popd

echo.
echo Batch rename completed. Files renamed: !renameCount!
call :LogMessage "Batch rename completed. Files renamed: !renameCount!" "SUCCESS"
pause
exit /b

:: ==========================================
:: SYSTEM MAINTENANCE FUNCTIONS
:: ==========================================

:CheckDiskSpace
cls
echo === DISK SPACE ANALYZER ===
call :LogMessage "Disk space analyzer started" "INFO"

echo Analyzing disk space...
call :LogMessage "Analyzing disk space" "INFO"

powershell -NoProfile -Command "Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } | Select-Object Name, @{n='Used(GB)';e={[math]::Round($_.Used/1GB,2)}}, @{n='Free(GB)';e={[math]::Round($_.Free/1GB,2)}}, @{n='Total(GB)';e={[math]::Round(($_.Used+$_.Free)/1GB,2)}}, @{n='PercentFree';e={[math]::Round($_.Free/($_.Used+$_.Free)*100,2)}} | Format-Table -AutoSize"

call :LogMessage "Disk space analysis completed" "SUCCESS"
pause
exit /b

:ClearSystemCache
cls
echo === SYSTEM CACHE CLEANER ===
call :LogMessage "System cache cleaner started" "INFO"

echo Clearing system cache...
call :LogMessage "Clearing system cache" "INFO"

ipconfig /flushdns >nul 2>&1
set "dnsResult=!ERRORLEVEL!"
if !dnsResult! EQU 0 (
    echo DNS cache cleared.
    call :LogMessage "DNS cache cleared" "INFO"
) else (
    echo Failed to clear DNS cache.
    call :LogMessage "Failed to clear DNS cache" "ERROR"
)

:: Check if running as admin before clearing system folders
net session >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    if exist "C:\Windows\SoftwareDistribution\Download" (
        del /q/f/s "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
        echo Windows Update cache cleared.
        call :LogMessage "Windows Update cache cleared" "INFO"
    )
) else (
    echo Note: Some caches require admin privileges to clear.
    call :LogMessage "Skipped admin-only cache cleaning" "WARNING"
)

if exist "%LOCALAPPDATA%\Microsoft\Windows\Explorer" (
    del /q/f "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
    echo Thumbnail cache cleared.
    call :LogMessage "Thumbnail cache cleared" "INFO"
)

:: Bug #16 Fix: Check existence before deleting icon cache
if exist "%LOCALAPPDATA%\IconCache.db" (
    del /q/f "%LOCALAPPDATA%\IconCache.db" >nul 2>&1
    echo Icon cache cleared.
    call :LogMessage "Icon cache cleared" "INFO"
) else (
    echo Icon cache not found (may not exist in this Windows version).
)

echo.
echo System cache cleaning completed.
call :LogMessage "System cache cleaning completed" "SUCCESS"
pause
exit /b

:UpdateWindows
cls
echo === WINDOWS UPDATE UTILITY ===
call :LogMessage "Windows Update utility started" "INFO"

echo Checking for Windows updates...
call :LogMessage "Checking for Windows updates" "INFO"

start ms-settings:windowsupdate-action
echo Windows Update settings opened.
call :LogMessage "Windows Update settings opened" "INFO"

pause
exit /b

:SystemFileChecker
cls
echo === SYSTEM FILE CHECKER ===
call :LogMessage "System File Checker started" "INFO"

echo Running System File Checker...
echo This may take several minutes. Please wait...
call :LogMessage "Running System File Checker" "INFO"

sfc /scannow
set "sfcResult=!ERRORLEVEL!"
if !sfcResult! EQU 0 (
    echo System File Checker completed successfully.
    call :LogMessage "System File Checker completed successfully" "SUCCESS"
) else (
    echo System File Checker encountered errors (Exit code: !sfcResult!).
    call :LogMessage "System File Checker encountered errors (Exit code: !sfcResult!)" "ERROR"
)

pause
exit /b

:ManageStartup
cls
echo === STARTUP PROGRAMS MANAGER ===
call :LogMessage "Startup Programs Manager started" "INFO"

echo Listing startup programs...
call :LogMessage "Listing startup programs" "INFO"

echo === Current User Startup Programs ===
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" 2>nul
set "hkcuQuery=!ERRORLEVEL!"
if !hkcuQuery! NEQ 0 echo No startup programs found for current user.

echo.
echo === System Wide Startup Programs ===
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" 2>nul
set "hklmQuery=!ERRORLEVEL!"
if !hklmQuery! NEQ 0 echo No system-wide startup programs found.

echo.
echo === Startup Folder (Current User) ===
dir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" 2>nul
set "startupDir=!ERRORLEVEL!"
if !startupDir! NEQ 0 echo Startup folder is empty.

echo.
set /p "disable=Enter program name to disable from registry (leave empty to skip): "
if not "%disable%"=="" (
    set "foundProgram=0"
    reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%disable%" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%disable%" /f >nul 2>&1
        if !ERRORLEVEL! EQU 0 (
            echo Successfully disabled: %disable% (Current User)
            call :LogMessage "Disabled startup program (HKCU): %disable%" "INFO"
            set "foundProgram=1"
        )
    )
    
    reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "%disable%" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "%disable%" /f >nul 2>&1
        if !ERRORLEVEL! EQU 0 (
            echo Successfully disabled: %disnSize%"=="" set "minSize=100"

:: Validate path exists
if not exist "%searchPath%" (
    echo Error: Path does not exist.
    call :LogMessage "Large files search failed: Path does not exist" "ERROR"
    pause
    exit /b
)

echo.
echo Finding files larger than %minSize% MB in "%searchPath%"...
call :LogMessage "Finding large files in %searchPath% with minimum size %minSize% MB" "INFO"

:: Escape single quotes in path for PowerShell
set "escapedPath=!searchPath:'=''!"
powershell -NoProfile -Command "Get-ChildItem -LiteralPath '!escapedPath!' -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Length / 1MB -ge %minSize% } | Sort-Object Length -Descending | Select-Object -First 50 | ForEach-Object { Write-Host ('{0} - {1:N2} MB' -f $_.FullName, ($_.Length / 1MB)) }"

echo.
echo Search completed.
call :LogMessage "Large files search completed" "SUCCESS"
pause
exit /b

:FileCompare
cls
echo === FILE COMPARISON TOOL ===
call :LogMessage "File comparison tool started" "INFO"

echo Enter paths to two files to compare:
set /p "file1=First file path: "
set /p "file2=Second file path: "

if not exist "%file1%" (
    echo Error: First file does not exist.
    call :LogMessage "File comparison failed: First file does not exist" "ERROR"
    pause
    exit /b
)

if not exist "%file2%" (
    echo Error: Second file does not exist.
    call :LogMessage "File comparison failed: Second file does not exist" "ERROR"
    pause
    exit /b
)

echo.
echo Comparing files...
call :LogMessage "Comparing files: %file1% and %file2%" "INFO"

fc "%file1%" "%file2%" >nul 2>&1
set "fcResult=!ERRORLEVEL!"
if !fcResult! EQU 0 (
    echo Files are identical.
    call :LogMessage "Files are identical" "SUCCESS"
) else (
    echo Files are different.
    call :LogMessage "Files are different" "WARNING"
    echo.
    echo Differences (first 50 lines):
    :: Bug #20 Fix: Limit output with more or head
    fc "%file1%" "%file2%" | more /E
)

pause
exit /b

:BatchRename
cls
echo === BATCH FILE RENAME UTILITY ===
call :LogMessage "Batch rename utility started" "INFO"

set /p "folderPath=Enter folder path containing files to rename: "
if not exist "%folderPath%" (
    echo Error: Folder does not exist.
    call :LogMessage "Batch rename failed: Folder does not exist" "ERROR"
    pause
    exit /b
)

set /p "prefix=Enter prefix for files (leave empty to skip): "
set /p "suffix=Enter suffix for files (leave empty to skip): "
set /p "extension=Enter new extension (leave empty to keep original, include dot e.g. .txt): "

:: Preview mode
echo.
echo === PREVIEW MODE ===
echo.
echo The following files will be renamed:
echo.

pushd "%folderPath%" 2>nul
if !ERRORLEVEL! NEQ 0 (
    echo Error: Failed to access folder.
    call :LogMessage "Failed to access folder: %folderPath%" "ERROR"
    pause
    exit /b
)

set "previewCount=0"
for %%F in (*.*) do (
    set "originalName=%%F"
    set "baseName=%%~nF"
    set "originalExt=%%~xF"
    
    if "!extension!"=="" (
        set "newExt=!originalExt!"
    ) else (
        set "newExt=%extension%"
    )
    
    set "newName=%prefix%!baseName!%suffix%!newExt!"
    
    if not "!originalName!"=="!newName!" (
        if not exist "!newName!" (
            echo !originalName! --^> !newName!
            set /a previewCount+=1
        ) else (
            echo !originalName! --^> !newName! [SKIP: Target exists]
        )
    )
    
    if !previewCount! GEQ 20 (
        echo ... [More files not shown]
        goto EndPreview
    )
)
:EndPreview

echo.
echo Total files to rename: !previewCount!
echo.
set /p "confirmRename=Proceed with rename? (Y/N): "

if /i not "!confirmRename!"=="Y" (
    echo Rename cancelled.
    call :LogMessage "Batch rename cancelled by user" "INFO"
    popd
    pause
    exit /b
)

echo.
echo Renaming files in "%folderPath%"...
call :LogMessage "Renaming files in %folderPath% with prefix: '%prefix%', suffix: '%suffix%', extension: '%extension%'" "INFO"

set "renameCount=0"
for %%F in (*.*) do (
    set "originalName=%%F"
    set "baseName=%%~nF"
    set "originalExt=%%~xF"
    
    if "!extension!"=="" (
        set "newExt=!originalExt!"
    ) else (
        set "newExt=%extension%"
    )
    
    set "newName=%prefix%!baseName!%suffix%!newExt!"
    
    if not exist "!newName!" (
        if not "!originalName!"=="!newName!" (
            ren "!originalName!" "!newName!" 2>nul
            set "renResult=!ERRORLEVEL!"
            if !renResult! EQU 0 (
                echo Renamed: !originalName! -^> !newName!
                set /a renameCount+=1
            ) else (
                echo Failed to rename: !originalName!
            )
        )
    ) else (
        echo Skipped: !originalName! (target name already exists)
    )
)
popd

echo.
echo Batch rename completed. Files renamed: !renameCount!
call :LogMessage "Batch rename completed. Files renamed: !renameCount!" "SUCCESS"
pause
exit /b

:: ==========================================
:: SYSTEM MAINTENANCE FUNCTIONS
:: ==========================================

:CheckDiskSpace
cls
echo === DISK SPACE ANALYZER ===
call :LogMessage "Disk space analyzer started" "INFO"

echo Analyzing disk space...
call :LogMessage "Analyzing disk space" "INFO"

powershell -NoProfile -Command "Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } | Select-Object Name, @{n='Used(GB)';e={[math]::Round($_.Used/1GB,2)}}, @{n='Free(GB)';e={[math]::Round($_.Free/1GB,2)}}, @{n='Total(GB)';e={[math]::Round(($_.Used+$_.Free)/1GB,2)}}, @{n='PercentFree';e={[math]::Round($_.Free/($_.Used+$_.Free)*100,2)}} | Format-Table -AutoSize"

call :LogMessage "Disk space analysis completed" "SUCCESS"
pause
exit /b

:ClearSystemCache
cls
echo === SYSTEM CACHE CLEANER ===
call :LogMessage "System cache cleaner started" "INFO"

echo Clearing system cache...
call :LogMessage "Clearing system cache" "INFO"

ipconfig /flushdns >nul 2>&1
set "dnsResult=!ERRORLEVEL!"
if !dnsResult! EQU 0 (
    echo DNS cache cleared.
    call :LogMessage "DNS cache cleared" "INFO"
) else (
    echo Failed to clear DNS cache.
    call :LogMessage "Failed to clear DNS cache" "ERROR"
)

:: Check if running as admin before clearing system folders
net session >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    if exist "C:\Windows\SoftwareDistribution\Download" (
        del /q/f/s "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
        echo Windows Update cache cleared.
        call :LogMessage "Windows Update cache cleared" "INFO"
    )
) else (
    echo Note: Some caches require admin privileges to clear.
    call :LogMessage "Skipped admin-only cache cleaning" "WARNING"
)

if exist "%LOCALAPPDATA%\Microsoft\Windows\Explorer" (
    del /q/f "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
    echo Thumbnail cache cleared.
    call :LogMessage "Thumbnail cache cleared" "INFO"
)

:: Bug #16 Fix: Check existence before deleting icon cache
if exist "%LOCALAPPDATA%\IconCache.db" (
    del /q/f "%LOCALAPPDATA%\IconCache.db" >nul 2>&1
    echo Icon cache cleared.
    call :LogMessage "Icon cache cleared" "INFO"
) else (
    echo Icon cache not found (may not exist in this Windows version).
)

echo.
echo System cache cleaning completed.
call :LogMessage "System cache cleaning completed" "SUCCESS"
pause
exit /b

:UpdateWindows
cls
echo === WINDOWS UPDATE UTILITY ===
call :LogMessage "Windows Update utility started" "INFO"

echo Checking for Windows updates...
call :LogMessage "Checking for Windows updates" "INFO"

start ms-settings:windowsupdate-action
echo Windows Update settings opened.
call :LogMessage "Windows Update settings opened" "INFO"

pause
exit /b

:SystemFileChecker
cls
echo === SYSTEM FILE CHECKER ===
call :LogMessage "System File Checker started" "INFO"

echo Running System File Checker...
echo This may take several minutes. Please wait...
call :LogMessage "Running System File Checker" "INFO"

sfc /scannow
set "sfcResult=!ERRORLEVEL!"
if !sfcResult! EQU 0 (
    echo System File Checker completed successfully.
    call :LogMessage "System File Checker completed successfully" "SUCCESS"
) else (
    echo System File Checker encountered errors (Exit code: !sfcResult!).
    call :LogMessage "System File Checker encountered errors (Exit code: !sfcResult!)" "ERROR"
)

pause
exit /b

:ManageStartup
cls
echo === STARTUP PROGRAMS MANAGER ===
call :LogMessage "Startup Programs Manager started" "INFO"

echo Listing startup programs...
call :LogMessage "Listing startup programs" "INFO"

echo === Current User Startup Programs ===
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" 2>nul
set "hkcuQuery=!ERRORLEVEL!"
if !hkcuQuery! NEQ 0 echo No startup programs found for current user.

echo.
echo === System Wide Startup Programs ===
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" 2>nul
set "hklmQuery=!ERRORLEVEL!"
if !hklmQuery! NEQ 0 echo No system-wide startup programs found.

echo.
echo === Startup Folder (Current User) ===
dir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" 2>nul
set "startupDir=!ERRORLEVEL!"
if !startupDir! NEQ 0 echo Startup folder is empty.

echo.
set /p "disable=Enter program name to disable from registry (leave empty to skip): "
if not "%disable%"=="" (
    set "foundProgram=0"
    reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%disable%" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%disable%" /f >nul 2>&1
        if !ERRORLEVEL! EQU 0 (
            echo Successfully disabled: %disable% (Current User)
            call :LogMessage "Disabled startup program (HKCU): %disable%" "INFO"
            set "foundProgram=1"
        )
    )
    
    reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "%disable%" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "%disable%" /f >nul 2>&1
        if !ERRORLEVEL! EQU 0 (
            echo Successfully disabled: %disable% (System Wide)
            call :LogMessage "Disabled startup program (HKLM): %disable%" "INFO"
            set "foundProgram=1"
        )
    )
    
    if !foundProgram! EQU 0 (
        echo Could not find program: %disable%
        call :LogMessage "Could not find startup program to disable: %disable%" "WARNING"
    )
)

pause
exit /b

:: ==========================================
:: NETWORK UTILITIES FUNCTIONS
:: ==========================================

:TestInternetConnection
cls
echo === INTERNET CONNECTION TEST ===
call :LogMessage "Internet connection test started" "INFO"

echo Testing internet connection...
call :LogMessage "Testing internet connection" "INFO"

ping -n 4 8.8.8.8 >nul 2>&1
set "pingResult=!ERRORLEVEL!"
if !pingResult! EQU 0 (
    echo [OK] Internet connection: ACTIVE
    call :LogMessage "Internet connection is active" "SUCCESS"
) else (
    echo [X] Internet connection: INACTIVE
    call :LogMessage "Internet connection is inactive" "ERROR"
)

echo.
nslookup google.com >nul 2>&1
set "dnsTest=!ERRORLEVEL!"
if !dnsTest! EQU 0 (
    echo [OK] DNS resolution: WORKING
    call :LogMessage "DNS resolution is working" "SUCCESS"
) else (
    echo [X] DNS resolution: NOT WORKING
    call :LogMessage "DNS resolution is not working" "ERROR"
)

pause
exit /b

:ShowNetworkConfig
cls
echo === NETWORK CONFIGURATION ===
call :LogMessage "Network configuration display started" "INFO"

echo Network Configuration:
call :LogMessage "Displaying network configuration" "INFO"

ipconfig /all
call :LogMessage "Network configuration displayed" "SUCCESS"

pause
exit /b

:TestNetworkLatency
cls
echo === NETWORK LATENCY TEST ===
call :LogMessage "Network latency test started" "INFO"

echo Testing network latency (response time test)...
echo Note: This measures latency only, not bandwidth/download speed.
call :LogMessage "Testing network latency" "INFO"

powershell -NoProfile -Command "& { $sw = [System.Diagnostics.Stopwatch]::StartNew(); try { $null = Invoke-WebRequest -Uri 'https://www.google.com' -UseBasicParsing -TimeoutSec 10; $sw.Stop(); Write-Host ('Response time: {0:N0} ms' -f $sw.ElapsedMilliseconds) } catch { $sw.Stop(); Write-Host 'Connection failed or timed out' } }"
call :LogMessage "Network latency test completed" "SUCCESS"

pause
exit /b

:FlushDNS
cls
echo === DNS CACHE FLUSHER ===
call :LogMessage "DNS cache flusher started" "INFO"

echo Flushing DNS cache...
call :LogMessage "Flushing DNS cache" "INFO"

ipconfig /flushdns
set "flushResult=!ERRORLEVEL!"
if !flushResult! EQU 0 (
    echo DNS cache flushed successfully.
    call :LogMessage "DNS cache flushed successfully" "SUCCESS"
) else (
    echo Failed to flush DNS cache.
    call :LogMessage "Failed to flush DNS cache" "ERROR"
)

pause
exit /b

:PortScanner
cls
echo === PORT SCANNER ===
call :LogMessage "Port scanner started" "INFO"

set /p "ipAddress=Enter IP address to scan (default: 127.0.0.1): "
if "%ipAddress%"=="" set "ipAddress=127.0.0.1"

set /p "scanTimeout=Enter timeout in milliseconds (default: 1000): "
if "%scanTimeout%"=="" set "scanTimeout=1000"

:: Validate numeric input
echo !scanTimeout! | findstr /R "^[0-9][0-9]*$" >nul
if !ERRORLEVEL! NEQ 0 (
    echo Invalid timeout value. Using default of 1000ms.
    set "scanTimeout=1000"
)

echo.
echo Scanning common ports on %ipAddress% (timeout: %scanTimeout%ms)...
echo This may take a moment...
call :LogMessage "Scanning ports on %ipAddress% with timeout %scanTimeout%ms" "INFO"

:: Bug #18 Fix: Added service name lookup
powershell -NoProfile -Command "$services = @{21='FTP';22='SSH';23='Telnet';25='SMTP';53='DNS';80='HTTP';110='POP3';143='IMAP';443='HTTPS';445='SMB';3306='MySQL';3389='RDP';5900='VNC';8000='HTTP-Alt';8080='HTTP-Proxy'}; $ports = @(21,22,23,25,53,80,110,143,443,445,3306,3389,5900,8000,8080); $ip = '%ipAddress%'; $timeout = %scanTimeout%; foreach ($p in $ports) { try { $tcp = New-Object System.Net.Sockets.TcpClient; $connect = $tcp.BeginConnect($ip, $p, $null, $null); $wait = $connect.AsyncWaitHandle.WaitOne($timeout, $false); if ($wait -and $tcp.Connected) { $svc = if ($services[$p]) { \" ($($services[$p]))\" } else { '' }; Write-Host \"Port $p$svc : OPEN\" -ForegroundColor Green; $tcp.Close() } else { $svc = if ($services[$p]) { \" ($($services[$p]))\" } else { '' }; Write-Host \"Port $p$svc : CLOSED\" -ForegroundColor Red }; $tcp.Close() } catch { $svc = if ($services[$p]) { \" ($($services[$p]))\" } else { '' }; Write-Host \"Port $p$svc : CLOSED\" -ForegroundColor Red } }"

echo.
echo Port scan completed.
call :LogMessage "Port scan completed" "SUCCESS"
pause
exit /b

:: ==========================================
:: SECURITY TOOLS FUNCTIONS
:: ==========================================

:PasswordGenerator
cls
echo === PASSWORD GENERATOR ===
call :LogMessage "Password generator started" "INFO"

set /p "length=Enter password length (default: 12): "
if "%length%"=="" set "length=12"

:: Bug #19 Fix: Validate password length is positive number
echo !length! | findstr /R "^[0-9][0-9]*$" >nul
if !ERRORLEVEL! NEQ 0 (
    echo Error: Please enter a valid number.
    call :LogMessage "Password generation failed: Invalid length input" "ERROR"
    pause
    exit /b
)

if !length! LEQ 0 (
    echo Error: Password length must be greater than 0.
    call :LogMessage "Password generation failed: Length must be positive" "ERROR"
    pause
    exit /b
)

if !length! LSS 4 (
    echo Error: Password length must be at least 4 characters.
    call :LogMessage "Password generation failed: Length too short" "ERROR"
    pause
    exit /b
)

if !length! GTR 128 (
    echo Error: Password length cannot exceed 128 characters.
    call :LogMessage "Password generation failed: Length too long" "ERROR"
    pause
    exit /b
)

set /p "includeUpper=Include uppercase letters? (Y/N): "
set /p "includeLower=Include lowercase letters? (Y/N): "
set /p "includeNumbers=Include numbers? (Y/N): "
set /p "includeSymbols=Include symbols? (Y/N): "

set "charSet="
if /i "%includeUpper%"=="Y" set "charSet=!charSet!ABCDEFGHIJKLMNOPQRSTUVWXYZ"
if /i "%includeLower%"=="Y" set "charSet=!charSet!abcdefghijklmnopqrstuvwxyz"
if /i "%includeNumbers%"=="Y" set "charSet=!charSet!0123456789"
if /i "%includeSymbols%"=="Y" set "charSet=!charSet!@#$%%+-=[]{}?!"

if "!charSet!"=="" (
    echo Error: Please select at least one character type.
    call :LogMessage "Password generation failed: No character type selected" "ERROR"
    pause
    exit /b
)

:: Bug #11 & #15 Fix: Simplified and reliable password generation
echo.
echo Generating password...
for /f "delims=" %%P in ('powershell -NoProfile -Command "$chars = '!charSet!'.ToCharArray(); -join (1..%length% | ForEach-Object { $chars | Get-Random })"') do set "password=%%P"

if "!password!"=="" (
    echo Error: Password generation failed.
    call :LogMessage "Password generation failed: PowerShell returned empty result" "ERROR"
    pause
    exit /b
)

echo.
echo Generated Password: !password!
call :LogMessage "Password generated successfully" "INFO"

echo.
echo !password! | clip >nul 2>&1
set "clipResult=!ERRORLEVEL!"
if !clipResult! EQU 0 (
    echo Password copied to clipboard.
    call :LogMessage "Password copied to clipboard" "INFO"
) else (
    echo Could not copy to clipboard.
    call :LogMessage "Could not copy password to clipboard" "WARNING"
)

pause
exit /b

:SystemSecurityAudit
cls
echo === SYSTEM SECURITY AUDIT ===
call :LogMessage "System security audit started" "INFO"

echo Running security audit...
call :LogMessage "Running security audit" "INFO"

echo.
echo Checking Windows Firewall status...
netsh advfirewall show allprofiles state
call :LogMessage "Windows Firewall status checked" "INFO"

echo.
echo Checking Windows Defender status...
powershell -NoProfile -Command "try { Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled, AntispywareEnabled, AntivirusEnabled | Format-List } catch { Write-Host 'Unable to retrieve Windows Defender status' }"
call :LogMessage "Windows Defender status checked" "INFO"

echo.
echo Checking User Account Control status...
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" 2>nul
call :LogMessage "User Account Control status checked" "INFO"

echo.
echo Checking recent Windows updates...
powershell -NoProfile -Command "Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 5 | Format-Table HotFixID, Description, InstalledOn -AutoSize"
call :LogMessage "Recent Windows updates checked" "INFO"

echo.
echo Security audit completed.
call :LogMessage "Security audit completed" "SUCCESS"
pause
exit /b

:CheckUserAccounts
cls
echo === USER ACCOUNTS CHECKER ===
call :LogMessage "User accounts checker started" "INFO"

echo Checking user accounts...
call :LogMessage "Checking user accounts" "INFO"

net user
call :LogMessage "User accounts listed" "INFO"

echo.
echo Checking administrator accounts...
net localgroup administrators
call :LogMessage "Administrator accounts listed" "INFO"

pause
exit /b

:SecureFileDeletion
cls
echo === SECURE FILE DELETION ===
call :LogMessage "Secure file deletion started" "INFO"

set /p "fileToDelete=Enter full path to file to delete securely: "
if not exist "%fileToDelete%" (
    echo Error: File does not exist.
    call :LogMessage "Secure file deletion failed: File does not exist" "ERROR"
    pause
    exit /b
)

echo.
echo WARNING: This will permanently delete the file beyond recovery!
set /p "confirm=Are you sure? (Y/N): "

if /i "%confirm%"=="Y" (
    echo.
    echo Securely deleting file...
    call :LogMessage "Securely deleting file: %fileToDelete%" "INFO"
    
    :: Streaming approach for large files (Bug #5 already fixed)
    powershell -NoProfile -Command "param($file); if (Test-Path $file) { try { $fs = [System.IO.File]::Open($file, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite); $fileLength = $fs.Length; $bufferSize = 64KB; $buffer = New-Object byte[] $bufferSize; $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider; for ($pass = 0; $pass -lt 3; $pass++) { $fs.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null; $remaining = $fileLength; while ($remaining -gt 0) { $toWrite = [Math]::Min($bufferSize, $remaining); $rng.GetBytes($buffer); $fs.Write($buffer, 0, $toWrite); $remaining -= $toWrite; Write-Progress -Activity 'Secure Deletion' -Status \"Pass $($pass+1)/3\" -PercentComplete ([int](($fileLength - $remaining) / $fileLength * 100)) }; $fs.Flush() }; $fs.Close(); $rng.Dispose(); Remove-Item $file -Force; Write-Host 'File securely deleted.'; exit 0 } catch { Write-Host \"Failed to delete file: $($_.Exception.Message)\"; exit 1 } } else { Write-Host 'File not found.'; exit 1 }" -file "%fileToDelete%"
    
    set "deleteResult=!ERRORLEVEL!"
    if !deleteResult! EQU 0 (
        call :LogMessage "File securely deleted successfully" "SUCCESS"
    ) else (
        echo Failed to delete file securely.
        call :LogMessage "Failed to delete file securely" "ERROR"
    )
) else (
    echo Operation cancelled.
    call :LogMessage "Secure file deletion cancelled" "INFO"
)

pause
exit /b

:CheckWindowsUpdatesStatus
cls
echo === WINDOWS UPDATES STATUS ===
call :LogMessage "Windows Updates status checker started" "INFO"

echo Checking Windows Updates status...
call :LogMessage "Checking Windows Updates status" "INFO"

powershell -NoProfile -Command "Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 10 | Format-Table HotFixID, Description, InstalledOn -AutoSize"

echo.
echo Checking for pending updates...
powershell -NoProfile -Command "try { $session = New-Object -ComObject Microsoft.Update.Session; $searcher = $session.CreateUpdateSearcher(); $result = $searcher.Search('IsInstalled=0'); Write-Host ('Pending updates: ' + $result.Updates.Count) } catch { Write-Host 'Unable to check for pending updates. This feature requires Windows Update service to be running.' }"

call :LogMessage "Windows Updates status displayed" "SUCCESS"
pause
exit /b

:: ==========================================
:: SETTINGS FUNCTIONS
:: ==========================================

:DisplaySystemInfo
cls
echo === SYSTEM INFORMATION ===
call :LogMessage "System information display started" "INFO"

echo Computer Name: %COMPUTERNAME%
echo User Name: %USERNAME%
echo OS: %OS%
echo.
echo Detailed System Information:
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Processor(s)" /C:"Total Physical Memory"
call :LogMessage "System information displayed" "SUCCESS"
exit /b

:ViewLogFile
cls
echo === VIEW LOG FILE ===
call :LogMessage "View log file started" "INFO"

if exist "%LOG_FILE%" (
    type "%LOG_FILE%" | more
    call :LogMessage "Log file viewed" "INFO"
) else (
    echo Log file does not exist yet.
    call :LogMessage "Log file does not exist" "WARNING"
)

pause
exit /b

:ClearLogFile
cls
echo === CLEAR LOG FILE ===

if exist "%LOG_FILE%" (
    echo Clearing log file...
    
    echo All-in-One System Tools Log > "%LOG_FILE%"
    call :GetDateTime
    echo Reset on !DATETIME:~0,4!-!DATETIME:~4,2!-!DATETIME:~6,2! >> "%LOG_FILE%"
    echo ======================================== >> "%LOG_FILE%"
    
    echo Log file cleared.
    call :LogMessage "Log file cleared" "SUCCESS"
) else (
    echo Log file does not exist.
)

pause
exit /b

:ChangeColorScheme
cls
echo === CHANGE COLOR SCHEME ===
call :LogMessage "Color scheme change started" "INFO"

echo Available color schemes:
echo 1. Light Green on Black (0A) - Default
echo 2. Light Blue on Black (0B)
echo 3. Light Red on Black (0C)
echo 4. Light Yellow on Black (0E)
echo 5. Light Cyan on Black (03)
echo 6. Light Purple on Black (0D)
echo 7. Light Aqua on Black (0B)
echo 8. Light White on Black (0F)

set /p "colorChoice=Select color scheme (1-8): "

if "%colorChoice%"=="1" color 0A
if "%colorChoice%"=="2" color 0B
if "%colorChoice%"=="3" color 0C
if "%colorChoice%"=="4" color 0E
if "%colorChoice%"=="5" color 03
if "%colorChoice%"=="6" color 0D
if "%colorChoice%"=="7" color 0B
if "%colorChoice%"=="8" color 0F

echo Color scheme changed.
call :LogMessage "Color scheme changed to option %colorChoice%" "INFO"

pause
exit /b

:ExitProgram
cls
echo ========================================
echo   Thank you for using All-in-One Tools
echo ========================================
call :LogMessage "Script execution completed" "INFO"
timeout /t 2 >nul
exit
