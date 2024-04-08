@echo off
setlocal EnableDelayedExpansion

echo Scanning for drivers and updating them...

set "driverdir=%SystemRoot%\System32\DriverStore\FileRepository"
set "tempdir=%TEMP%\driver_updates"
set "logfile=%TEMP%\driver_update.log"
set "backupdir=%TEMP%\driver_backup"

if not exist "%tempdir%" mkdir "%tempdir%"
if not exist "%backupdir%" mkdir "%backupdir%"

echo Driver update log > "%logfile%"
echo Date: %date% >> "%logfile%"
echo Time: %time% >> "%logfile%"
echo. >> "%logfile%"

for /f "delims=" %%i in ('dir /b /ad "%driverdir%"') do (
    set "inf_file="
    for /f "delims=" %%j in ('dir /b /s "%driverdir%\%%i\*.inf"') do (
        set "inf_file=%%j"
        goto :break
    )
    :break
    if defined inf_file (
        echo Processing driver: %%i
        echo Processing driver: %%i >> "%logfile%"
        
        for /f "tokens=2 delims==" %%k in ('findstr /i /c:"DriverVer" "!inf_file!"') do (
            set "current_version=%%k"
            set "current_version=!current_version:~0,19!"
        )
        
        echo Current driver version: !current_version!
        echo Current driver version: !current_version! >> "%logfile%"
        
        for /f "tokens=1 delims=," %%l in ('pnputil /enum-drivers "!inf_file!" ^| findstr /i /c:"Published name"') do (
            set "driver_name=%%l"
            set "driver_name=!driver_name:~16!"
        )
        
        for /f "tokens=2 delims=," %%m in ('pnputil /enum-drivers "!driver_name!" ^| findstr /i /c:"Driver package provider"') do (
            set "provider=%%m"
            set "provider=!provider:~25!"
        )
        
        for /f "tokens=2 delims=," %%n in ('pnputil /enum-drivers "!driver_name!" ^| findstr /i /c:"Class"') do (
            set "class=%%n"
            set "class=!class:~7!"
        )
        
        for /f "tokens=2 delims=," %%o in ('pnputil /enum-drivers "!driver_name!" ^| findstr /i /c:"Version"') do (
            set "available_version=%%o"
            set "available_version=!available_version:~9!"
        )
        
        echo Available driver version: !available_version!
        echo Available driver version: !available_version! >> "%logfile%"
        
        if "!available_version!" neq "!current_version!" (
            echo Updating driver...
            echo Updating driver... >> "%logfile%"
            
            set "backup_file=%backupdir%\%%i_!current_version!.inf"
            echo Backing up current driver to: "!backup_file!"
            echo Backing up current driver to: "!backup_file!" >> "%logfile%"
            copy "!inf_file!" "!backup_file!" > nul
            
            pnputil /add-driver "!inf_file!" >> "%logfile%" 2>&1
            if !errorlevel! equ 0 (
                echo Driver updated successfully.
                echo Driver updated successfully. >> "%logfile%"
            ) else (
                echo Failed to update driver. Rolling back...
                echo Failed to update driver. Rolling back... >> "%logfile%"
                pnputil /delete-driver "!inf_file!" >> "%logfile%" 2>&1
                pnputil /add-driver "!backup_file!" >> "%logfile%" 2>&1
            )
        ) else (
            echo Driver is up to date.
            echo Driver is up to date. >> "%logfile%"
        )
        
        echo. >> "%logfile%"
    )
)

echo Driver update process completed.
echo Log file: "%logfile%"
echo Backup directory: "%backupdir%"

endlocal
