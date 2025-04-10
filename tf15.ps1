if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "FATAL: This script MUST be run as Administrator!"
    Read-Host "Press Enter to exit..."
    Exit
}

Write-Host "==========================================================================" -ForegroundColor Black -BackgroundColor Red
Write-Host "                 ULTIMATE WARNING - EXTREME RISK AHEAD                  " -ForegroundColor Black -BackgroundColor Red
Write-Host "==========================================================================" -ForegroundColor Black -BackgroundColor Red
Write-Host "This script is designed for MAXIMUM PERFORMANCE ONLY, disregarding safety!" -ForegroundColor Red
Write-Host "It WILL:" -ForegroundColor Yellow
Write-Host "  1. Attempt aggressive system tuning (Power, Visuals, Services, Tasks)." -ForegroundColor Yellow
Write-Host "  2. Attempt network latency optimizations (May impact throughput)." -ForegroundColor Yellow
Write-Host "  3. COMPLETELY DISABLE Windows Defender (NO ANTIVIRUS!)." -ForegroundColor Red -BackgroundColor Black
Write-Host "     -> Requires Tamper Protection MANUALLY disabled FIRST!" -ForegroundColor Magenta
Write-Host "     -> Your PC will be DEFENSELESS against malware." -ForegroundColor Red
Write-Host "  4. COMPLETELY DISABLE Windows Update (NO SECURITY PATCHES!)." -ForegroundColor Red -BackgroundColor Black
Write-Host "     -> Your PC will become increasingly VULNERABLE over time." -ForegroundColor Red
Write-Host "  5. Potentially cause SYSTEM INSTABILITY, CRASHES, or BOOT ISSUES." -ForegroundColor Red
Write-Host "  6. Install software via winget (Check the list inside the script)." -ForegroundColor Yellow
Write-Host "  7. Add standard desktop icons (This PC, Control Panel, Network)." -ForegroundColor Yellow
Write-Host ""
Write-Host "*** BACK UP YOUR DATA NOW IF YOU HAVEN'T ALREADY. THIS IS YOUR LAST CHANCE. ***" -ForegroundColor Cyan
Write-Host "*** YOU ARE 100% RESPONSIBLE FOR ANY NEGATIVE OUTCOME. ***" -ForegroundColor Red
Write-Host "==========================================================================" -ForegroundColor Black -BackgroundColor Red

$confirmation = Read-Host "Type 'I ACCEPT THE RISKS' (exactly as shown) to proceed:"
if ($confirmation -ne 'I ACCEPT THE RISKS') {
    Write-Host "Script aborted by user. No changes made." -ForegroundColor Green
    Read-Host "Press Enter to exit..."
    Exit
}

Write-Host "`nProceeding with aggressive optimization... Good luck." -ForegroundColor Magenta
Start-Sleep -Seconds 5

Write-Host "`n===== Section 1: Pre-Optimization Updates =====" -ForegroundColor Cyan

Write-Host "Attempting to install latest Windows Updates first..."
try {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser -ErrorAction SilentlyContinue
    Install-Module PSWindowsUpdate -Force -SkipPublisherCheck -Scope CurrentUser -ErrorAction Stop
    Import-Module PSWindowsUpdate -Force -ErrorAction Stop
    Write-Host "  Running Get-WindowsUpdate & Install (This may take time)..." -ForegroundColor Gray
    Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot -Verbose -ErrorAction SilentlyContinue
    Write-Host "  Windows Update check/install finished." -ForegroundColor Green
} catch {
    Write-Warning "  PSWindowsUpdate module execution failed. Skipping Windows Update."
}

Write-Host "Attempting to update all drivers and installed packages using winget..."
Write-Warning "Winget is good, but for BEST NVIDIA performance, use GeForce Experience or NVIDIA's website."
try {
    winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements --disable-interactivity --silent
    Write-Host "  Winget upgrade command executed." -ForegroundColor Green
} catch {
    Write-Warning "  Winget upgrade command failed or encountered an error: $($_.Exception.Message)"
}

Write-Host "`n===== Section 2: Aggressive Performance Tuning =====" -ForegroundColor Cyan

Write-Host "Setting Ultimate Performance Power Plan..."
try {
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    $ultimatePerfGuid = (powercfg /LIST | Where-Object { $_ -match 'Ultimate Performance' } | Select-String -Pattern '\(([^)]+)\)' | ForEach-Object { $_.Matches.Groups[1].Value })
    if ($ultimatePerfGuid) {
        powercfg /SETACTIVE $ultimatePerfGuid
        Write-Host "  Ultimate Performance Activated." -ForegroundColor Green
    } else {
        Write-Warning "  Ultimate Performance not found/enabled. Falling back to High Performance."
        $highPerfGuid = (powercfg /LIST | Where-Object { $_ -match 'High performance' } | Select-String -Pattern '\(([^)]+)\)' | ForEach-Object { $_.Matches.Groups[1].Value })
        if ($highPerfGuid) {
            powercfg /SETACTIVE $highPerfGuid
            Write-Host "  High Performance Activated." -ForegroundColor Green
        } else { Write-Error "  Could not find High or Ultimate Performance plan!" }
    }
} catch { Write-Warning "  Failed to set power plan: $($_.Exception.Message)" }

Write-Host "Optimizing Visual Effects..."
try {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 3 -Type DWord -Force -ErrorAction Stop
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'FontSmoothing' -Value "2" -Type String -Force -ErrorAction Stop
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x90, 0x12, 0x03, 0x80, 16, 0, 0, 0)) -Type Binary -Force -ErrorAction Stop
    Write-Host "  Visual Effects set for performance (font smoothing kept)." -ForegroundColor Green
} catch { Write-Warning "  Failed to set visual effects: $($_.Exception.Message)" }

Write-Host "Disabling Xbox Game Bar and related features..."
try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -Type DWord -Force -ErrorAction Stop
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "UseNexusForGameBarEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -Type DWord -Force -ErrorAction Stop
    Write-Host "  Game Bar disabled via Registry." -ForegroundColor Green
} catch { Write-Warning "  Failed to disable Game Bar fully: $($_.Exception.Message)" }

Write-Host "Applying performance/latency registry tweaks..."
try {
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Force -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 26 -Type DWord -Force -ErrorAction Stop

    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Force -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0 -Type DWord -Force -ErrorAction Stop

    Write-Host "  Registry performance tweaks applied." -ForegroundColor Green
} catch { Write-Warning "  Failed to apply some registry tweaks: $($_.Exception.Message)" }

Write-Host "`n===== Section 3: Disabling Services & Tasks =====" -ForegroundColor Cyan
Write-Warning "Disabling services/tasks can break functionality or cause instability!"

$servicesToDisable = @(
    "DiagTrack",
    "dmwappushservice",
    "SysMain"
)

Write-Host "Disabling selected services..."
foreach ($serviceName in $servicesToDisable) {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($service) {
        try {
            Write-Host "  Disabling '$($serviceName)'..." -ForegroundColor Gray
            Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
            Set-Service -Name $serviceName -StartupType Disabled -ErrorAction Stop
            Write-Host "    '$($serviceName)' stopped and disabled." -ForegroundColor Green
        } catch {
            Write-Warning "    Failed to disable service '$($serviceName)': $($_.Exception.Message)"
        }
    } else {
        Write-Host "  Service '$($serviceName)' not found. Skipping." -ForegroundColor DarkGray
    }
}

Write-Host "Disabling selected scheduled tasks..."
$tasksToDisable = @(
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "\Microsoft\Windows\Application Experience\StartupAppTask",
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
    "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask",
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
)

foreach ($taskPath in $tasksToDisable) {
    try {
        $task = Get-ScheduledTask -TaskPath $(Split-Path $taskPath -Parent) -TaskName $(Split-Path $taskPath -Leaf) -ErrorAction SilentlyContinue
        if ($task -and $task.State -ne 'Disabled') {
            Write-Host "  Disabling task '$($taskPath)'..." -ForegroundColor Gray
            Disable-ScheduledTask -TaskPath $(Split-Path $taskPath -Parent) -TaskName $(Split-Path $taskPath -Leaf) -ErrorAction Stop
            Write-Host "    Task '$($taskPath)' disabled." -ForegroundColor Green
        } elseif ($task.State -eq 'Disabled') {
             Write-Host "  Task '$($taskPath)' already disabled." -ForegroundColor DarkGray
        }
         else {
             Write-Host "  Task '$($taskPath)' not found. Skipping." -ForegroundColor DarkGray
        }
    } catch {
        Write-Warning "    Failed to disable task '$($taskPath)': $($_.Exception.Message)"
    }
}

Write-Host "`n===== Section 4: Network Latency Optimizations =====" -ForegroundColor Cyan
Write-Warning "These aim for lower latency (gaming), but might reduce maximum download/upload speeds."

try {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Force -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord -Force -ErrorAction Stop
    Write-Host "  Network Throttling Disabled." -ForegroundColor Green

    $tcpInterfacesPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
    Get-ChildItem -Path $tcpInterfacesPath | ForEach-Object {
        $interfacePath = $_.PSPath
        Set-ItemProperty -Path $interfacePath -Name "TcpAckFrequency" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $interfacePath -Name "TCPNoDelay" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    }
    Write-Host "  Attempted to disable Nagle's Algorithm globally (TcpAckFrequency=1, TCPNoDelay=1)." -ForegroundColor Green

} catch {
    Write-Warning "  Failed to apply some network optimizations: $($_.Exception.Message)"
}

Write-Host "`n===== Section 5: Disabling Windows Defender =====" -ForegroundColor Red
Write-Host "!!! FINAL REMINDER: TAMPER PROTECTION MUST BE OFF MANUALLY FOR THIS TO WORK !!!" -ForegroundColor Magenta
Start-Sleep -Seconds 3

try {
    Write-Host "Applying registry changes to disable Defender..."
    $defenderRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
    New-Item -Path $defenderRegPath -Force -ErrorAction Stop | Out-Null

    Set-ItemProperty -Path $defenderRegPath -Name "DisableAntiSpyware" -Value 1 -Type DWord -Force -ErrorAction Stop
    Set-ItemProperty -Path $defenderRegPath -Name "DisableRealtimeMonitoring" -Value 1 -Type DWord -Force -ErrorAction Stop

    $rtpPath = "$defenderRegPath\Real-Time Protection"
    New-Item -Path $rtpPath -Force -ErrorAction Stop | Out-Null
    Set-ItemProperty -Path $rtpPath -Name "DisableBehaviorMonitoring" -Value 1 -Type DWord -Force -ErrorAction Stop
    Set-ItemProperty -Path $rtpPath -Name "DisableOnAccessProtection" -Value 1 -Type DWord -Force -ErrorAction Stop
    Set-ItemProperty -Path $rtpPath -Name "DisableScanOnRealtimeEnable" -Value 1 -Type DWord -Force -ErrorAction Stop

    $spyNetPath = "$defenderRegPath\Spynet"
    New-Item -Path $spyNetPath -Force -ErrorAction Stop | Out-Null
    Set-ItemProperty -Path $spyNetPath -Name "SubmitSamplesConsent" -Value 2 -Type DWord -Force -ErrorAction Stop
    Set-ItemProperty -Path $spyNetPath -Name "SpynetReporting" -Value 0 -Type DWord -Force -ErrorAction Stop

    $MAPSPath = "$defenderRegPath\MAPS"
    New-Item -Path $MAPSPath -Force -ErrorAction Stop | Out-Null
    Set-ItemProperty -Path $MAPSPath -Name "MAPSReporting" -Value 0 -Type DWord -Force -ErrorAction Stop

    Write-Host "  Defender registry settings applied." -ForegroundColor Green

    Write-Host "Stopping and disabling Defender services..."
    Stop-Service -Name WinDefend -Force -ErrorAction SilentlyContinue
    Set-Service -Name WinDefend -StartupType Disabled -ErrorAction SilentlyContinue
    Write-Host "  WinDefend service stopped and disabled (attempted)." -ForegroundColor Green

    Write-Host "  Windows Defender disable sequence complete. REBOOT REQUIRED." -ForegroundColor Yellow

} catch {
    Write-Error "  FAILED TO APPLY DEFENDER REGISTRY/SERVICE SETTINGS! Tamper Protection likely still ON or other issue. Error: $($_.Exception.Message)"
}

Write-Host "`n===== Section 6: Disabling Windows Update =====" -ForegroundColor Red
Write-Warning "No more security patches, feature updates, or driver updates via WU!"
Start-Sleep -Seconds 3

try {
    Write-Host "Applying registry changes to disable Windows Update..."
    $wuRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    New-Item -Path $wuRegPath -Force -ErrorAction Stop | Out-Null
    Set-ItemProperty -Path $wuRegPath -Name "DoNotConnectToWindowsUpdateInternetLocations" -Value 1 -Type DWord -Force -ErrorAction Stop
    Set-ItemProperty -Path $wuRegPath -Name "SetDisableUXWUAccess" -Value 1 -Type DWord -Force -ErrorAction Stop

    $auRegPath = "$wuRegPath\AU"
    New-Item -Path $auRegPath -Force -ErrorAction Stop | Out-Null
    Set-ItemProperty -Path $auRegPath -Name "NoAutoUpdate" -Value 1 -Type DWord -Force -ErrorAction Stop
    Set-ItemProperty -Path $auRegPath -Name "AUOptions" -Value 1 -Type DWord -Force -ErrorAction Stop

    Write-Host "  Windows Update registry settings applied." -ForegroundColor Green

    Write-Host "Disabling Windows Update related services..."
    $wuServices = @( "wuauserv", "UsoSvc", "WaaSMedicSvc", "BITS" )
    foreach ($serviceName in $wuServices) {
         $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
         if ($service) {
            try {
                Write-Host "  Disabling '$($serviceName)'..." -ForegroundColor Gray
                Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
                Set-Service -Name $serviceName -StartupType Disabled -ErrorAction Stop
                Write-Host "    '$($serviceName)' stopped and disabled." -ForegroundColor Green
            } catch { Write-Warning "    Failed to disable service '$($serviceName)': $($_.Exception.Message)" }
         } else { Write-Host "  Service '$($serviceName)' not found." -ForegroundColor DarkGray }
    }

    Write-Host "  Windows Update disable sequence complete. REBOOT REQUIRED." -ForegroundColor Yellow

} catch {
    Write-Error "  FAILED TO APPLY WINDOWS UPDATE SETTINGS/SERVICES! Error: $($_.Exception.Message)"
}

Write-Host "`n===== Section 7: Installing Essential Software via Winget =====" -ForegroundColor Cyan

$programsToInstall = @(
    "Mozilla.Firefox",
    "7zip.7zip",
    "VideoLAN.VLC",
    "Microsoft.PowerToys",
    "Nvidia.GeForceExperience",
    "Valve.Steam",
    "MSI.Afterburner"
)

Write-Host "Starting installations (Silent where possible)..."
foreach ($programId in $programsToInstall) {
    Write-Host "  Attempting to install: $programId" -ForegroundColor Gray
    try {
        $installed = winget list --id $programId -n 1 | Select-String $programId -ErrorAction SilentlyContinue
        if ($installed) {
            Write-Host "    '$programId' appears to be already installed. Skipping." -ForegroundColor Yellow
            continue
        }

        winget install --id $programId -e --accept-package-agreements --accept-source-agreements --disable-interactivity --silent
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "    Installation of '$programId' may have failed or requires interaction (Exit Code: $LASTEXITCODE)."
        } else {
            Write-Host "    Successfully installed '$programId' (or started)." -ForegroundColor Green
        }
    } catch {
         Write-Warning "    Winget error during installation of '$programId': $($_.Exception.Message)"
    }
    Start-Sleep -Seconds 1
}
Write-Host "Software installation section finished." -ForegroundColor Green

Write-Host "`n===== Section 8: Add Standard Desktop Icons =====" -ForegroundColor Cyan

try {
    $desktopIconsRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
    If (!(Test-Path $desktopIconsRegPath)) {
        New-Item -Path $desktopIconsRegPath -Force | Out-Null
        Write-Host "  Created registry key: $desktopIconsRegPath" -ForegroundColor Gray
    }

    $iconsToShow = @(
        "{20D04FE0-3AEA-1069-A2D8-08002B30309D}",
        "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}",
        "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"
    )

    Write-Host "Ensuring standard desktop icons are visible..."
    foreach ($iconGuid in $iconsToShow) {
        try {
            Remove-ItemProperty -Path $desktopIconsRegPath -Name $iconGuid -Force -ErrorAction SilentlyContinue
            Write-Host "  Ensured icon $iconGuid is set to visible." -ForegroundColor Green
        } catch {
            Write-Warning "Could not ensure visibility for"
        }
    }
    Write-Host "  Desktop icon settings applied. Changes require reboot." -ForegroundColor Yellow

} catch {
    Write-Warning "  Failed to modify desktop icon registry settings: $($_.Exception.Message)"
}


Write-Host "`n===== Section 9: Final Cleanup & Optimization =====" -ForegroundColor Cyan

Write-Host "Cleaning temporary files and Recycle Bin..."
$tempPaths = @("$env:TEMP", "$env:SystemRoot\Temp")
foreach ($path in $tempPaths) {
    if (Test-Path $path) {
        Write-Host "  Cleaning $path" -ForegroundColor Gray
        Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
}
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host "  Temp files and Recycle Bin cleaned." -ForegroundColor Green

Write-Host "Optimizing drive C: (TRIM/Defrag)..."
try {
    Optimize-Volume -DriveLetter C -Verbose -ErrorAction Stop
    Write-Host "  Drive C: optimization complete." -ForegroundColor Green
} catch {
    Write-Warning "  Failed to optimize drive C: $($_.Exception.Message)"
}

Write-Host "Clearing system event logs..."
try {
    Get-WinEvent -ListLog * -Force | Where-Object {$_.IsEnabled} | ForEach-Object {
        Write-Host "  Clearing $($_.LogName)..." -ForegroundColor Gray
        wevtutil.exe cl $_.LogName | Out-Null
    }
    Write-Host "  Event logs cleared." -ForegroundColor Green
} catch {
     Write-Warning "  Failed to clear some event logs: $($_.Exception.Message)"
}

Write-Host "`n==========================================================================" -ForegroundColor Green
Write-Host "                AGGRESSIVE OPTIMIZATION SCRIPT COMPLETE                 " -ForegroundColor Green
Write-Host "==========================================================================" -ForegroundColor Green
Write-Host "Summary of Aggressive Actions Attempted:"
Write-Host "  - Windows Updates applied (Pre-run)." -ForegroundColor White
Write-Host "  - Winget packages/drivers updated." -ForegroundColor White
Write-Host "  - Ultimate Performance Power Plan set." -ForegroundColor White
Write-Host "  - Visual Effects optimized." -ForegroundColor White
Write-Host "  - Game Bar disabled." -ForegroundColor White
Write-Host "  - Aggressive Registry/Network tweaks applied." -ForegroundColor Yellow
Write-Host "  - Non-essential Services/Tasks disabled (Potential Stability Risk)." -ForegroundColor Yellow
Write-Host "  - Windows Defender FULLY DISABLED (!!! NO ANTIVIRUS !!!)." -ForegroundColor Red -BackgroundColor Black
Write-Host "  - Windows Update FULLY DISABLED (!!! NO SECURITY PATCHES !!!)." -ForegroundColor Red -BackgroundColor Black
Write-Host "  - Essential Software installed." -ForegroundColor White
Write-Host "  - Standard Desktop Icons added." -ForegroundColor White
Write-Host "  - System Cleanup & Drive Optimization performed." -ForegroundColor White
Write-Host ""
Write-Host "*** CRITICAL REMINDER: A REBOOT IS ABSOLUTELY REQUIRED NOW! ***" -ForegroundColor Magenta
Write-Host "*** Your system is now running WITHOUT CORE SECURITY FEATURES. ***" -ForegroundColor Red
Write-Host "*** Be EXTREMELY careful online. Monitor system stability closely. ***" -ForegroundColor Red
Write-Host "*** USE GEFORCE EXPERIENCE or NVIDIA.COM for optimal graphics drivers! ***" -ForegroundColor Yellow

Read-Host "Press Enter to close this window and REBOOT YOUR COMPUTER MANUALLY."
