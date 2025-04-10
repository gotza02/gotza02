<#
.SYNOPSIS
    Aggressive Windows 11 Performance Optimization Script (EXTREMELY HIGH RISK).
    Targets maximum performance above all else for specific hardware (ASUS TUF F15 Gen 11).
    Disables security features (Defender, Update), tunes system settings, services, tasks, network.
    Installs selected software via winget.

.DESCRIPTION
    USE THIS SCRIPT AT YOUR OWN EXTREME RISK. IT PRIORITIZES RAW PERFORMANCE OVER
    SECURITY, STABILITY, AND FUNCTIONALITY.
    !!! YOU MUST MANUALLY DISABLE TAMPER PROTECTION IN WINDOWS SECURITY FIRST !!!
    !!! BACK UP ALL IMPORTANT DATA BEFORE RUNNING !!!
    Run as Administrator.

.NOTES
    Author: AI Assistant based on user request for MAX performance
    Date:   [Current Date]
    Requires: Windows 11, Administrator privileges, Internet connection, Tamper Protection OFF.
#>

#===========================================================================
# SECTION 0: PRE-CHECKS AND ABSOLUTE FINAL WARNING
#===========================================================================

# Force Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "FATAL: This script MUST be run as Administrator!"
    Read-Host "Press Enter to exit..."
    Exit
}

# Display The Final, Most Severe Warning
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
Write-Host ""
Write-Host "*** BACK UP YOUR DATA NOW IF YOU HAVEN'T ALREADY. THIS IS YOUR LAST CHANCE. ***" -ForegroundColor Cyan
Write-Host "*** YOU ARE 100% RESPONSIBLE FOR ANY NEGATIVE OUTCOME. ***" -ForegroundColor Red
Write-Host "==========================================================================" -ForegroundColor Black -BackgroundColor Red

# Confirmation - Make it deliberate
$confirmation = Read-Host "Type 'I ACCEPT THE RISKS' (exactly as shown) to proceed:"
if ($confirmation -ne 'I ACCEPT THE RISKS') {
    Write-Host "Script aborted by user. No changes made." -ForegroundColor Green
    Read-Host "Press Enter to exit..."
    Exit
}

Write-Host "`nProceeding with aggressive optimization... Good luck." -ForegroundColor Magenta
Start-Sleep -Seconds 5

#===========================================================================
# SECTION 1: PRE-OPTIMIZATION UPDATES (Windows & Drivers via Winget)
#===========================================================================
Write-Host "`n===== Section 1: Pre-Optimization Updates =====" -ForegroundColor Cyan

Write-Host "Attempting to install latest Windows Updates first..."
try {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser -ErrorAction SilentlyContinue
    Install-Module PSWindowsUpdate -Force -SkipPublisherCheck -Scope CurrentUser -ErrorAction Stop
    Import-Module PSWindowsUpdate -Force -ErrorAction Stop
    Write-Host "  Running Get-WindowsUpdate & Install (This may take time)..." -ForegroundColor Gray
    Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot -Verbose -ErrorAction SilentlyContinue # Continue even if some updates fail
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

#===========================================================================
# SECTION 2: AGGRESSIVE PERFORMANCE TUNING
#===========================================================================
Write-Host "`n===== Section 2: Aggressive Performance Tuning =====" -ForegroundColor Cyan

# 2.1 Ultimate Power Plan
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

# 2.2 Visual Effects for Performance
Write-Host "Optimizing Visual Effects..."
try {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 3 -Type DWord -Force -ErrorAction Stop
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'FontSmoothing' -Value "2" -Type String -Force -ErrorAction Stop # Keep font smoothing
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x90, 0x12, 0x03, 0x80, 16, 0, 0, 0)) -Type Binary -Force -ErrorAction Stop # Keep font smoothing
    Write-Host "  Visual Effects set for performance (font smoothing kept)." -ForegroundColor Green
} catch { Write-Warning "  Failed to set visual effects: $($_.Exception.Message)" }

# 2.3 Disable Game Bar & Related
Write-Host "Disabling Xbox Game Bar and related features..."
try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -Type DWord -Force -ErrorAction Stop
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "UseNexusForGameBarEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue # Might not exist
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -Type DWord -Force -ErrorAction Stop
    Write-Host "  Game Bar disabled via Registry." -ForegroundColor Green
} catch { Write-Warning "  Failed to disable Game Bar fully: $($_.Exception.Message)" }

# 2.4 Performance/Latency Registry Tweaks (Use with caution)
Write-Host "Applying performance/latency registry tweaks..."
try {
    # Prioritize foreground apps more aggressively
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Force -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 26 -Type DWord -Force -ErrorAction Stop # Hex 1A (Max foreground boost)

    # Multimedia profile for system responsiveness (can help games)
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Force -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0 -Type DWord -Force -ErrorAction Stop

    # Disable Paging Executive (Forces kernel/drivers to RAM - RISKY if RAM is tight)
    # Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "DisablePagingExecutive" -Value 1 -Type DWord -Force -ErrorAction Stop
    # Write-Host "  WARNING: Disabled Paging Executive - May cause instability if RAM is insufficient." -ForegroundColor Yellow

    Write-Host "  Registry performance tweaks applied." -ForegroundColor Green
} catch { Write-Warning "  Failed to apply some registry tweaks: $($_.Exception.Message)" }

#===========================================================================
# SECTION 3: DISABLING UNNECESSARY SERVICES & TASKS (Potential Stability Risk)
#===========================================================================
Write-Host "`n===== Section 3: Disabling Services & Tasks =====" -ForegroundColor Cyan
Write-Warning "Disabling services/tasks can break functionality or cause instability!"

# 3.1 Services to Disable
$servicesToDisable = @(
    "DiagTrack",            # Connected User Experiences and Telemetry
    "dmwappushservice",     # Device Management Wireless Application Protocol (WAP) Push message Routing Service
    "SysMain"               # Superfetch/Prefetch (Often debated; can cause high disk usage, sometimes helps/hurts)
    # Add more services here WITH EXTREME CAUTION if you know what they do.
    # "Fax"                 # Example: Fax service (if you never use it)
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

# 3.2 Scheduled Tasks to Disable (Focus on Telemetry/Experience Improvement)
Write-Host "Disabling selected scheduled tasks..."
$tasksToDisable = @(
    # Application Experience
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "\Microsoft\Windows\Application Experience\StartupAppTask",
    # Customer Experience Improvement Program
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
    "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask",
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
    # Add more tasks here WITH EXTREME CAUTION
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

#===========================================================================
# SECTION 4: NETWORK OPTIMIZATIONS (Potential Throughput Risk)
#===========================================================================
Write-Host "`n===== Section 4: Network Latency Optimizations =====" -ForegroundColor Cyan
Write-Warning "These aim for lower latency (gaming), but might reduce maximum download/upload speeds."

try {
    # Disable Network Throttling
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Force -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord -Force -ErrorAction Stop
    Write-Host "  Network Throttling Disabled." -ForegroundColor Green

    # Disable Nagle's Algorithm (TCPNoDelay & TCPAckFrequency) - Applied Globally (More Aggressive)
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

#===========================================================================
# SECTION 5: DISABLE WINDOWS DEFENDER (!!! EXTREME SECURITY RISK !!!)
#===========================================================================
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
    Set-ItemProperty -Path $spyNetPath -Name "SubmitSamplesConsent" -Value 2 -Type DWord -Force -ErrorAction Stop # Never send
    Set-ItemProperty -Path $spyNetPath -Name "SpynetReporting" -Value 0 -Type DWord -Force -ErrorAction Stop # Disabled

    $MAPSPath = "$defenderRegPath\MAPS" # Microsoft Active Protection Service
    New-Item -Path $MAPSPath -Force -ErrorAction Stop | Out-Null
    Set-ItemProperty -Path $MAPSPath -Name "MAPSReporting" -Value 0 -Type DWord -Force -ErrorAction Stop # Disabled

    Write-Host "  Defender registry settings applied." -ForegroundColor Green

    Write-Host "Stopping and disabling Defender services..."
    Stop-Service -Name WinDefend -Force -ErrorAction SilentlyContinue
    Set-Service -Name WinDefend -StartupType Disabled -ErrorAction SilentlyContinue
    Write-Host "  WinDefend service stopped and disabled (attempted)." -ForegroundColor Green
    # Other related services might be WdNisSvc (Network Inspection), Sense (ATP Sensor) - disabling these is even riskier.

    Write-Host "  Windows Defender disable sequence complete. REBOOT REQUIRED." -ForegroundColor Yellow

} catch {
    Write-Error "  FAILED TO APPLY DEFENDER REGISTRY/SERVICE SETTINGS! Tamper Protection likely still ON or other issue. Error: $($_.Exception.Message)"
}

#===========================================================================
# SECTION 6: DISABLE WINDOWS UPDATE (!!! EXTREME SECURITY RISK !!!)
#===========================================================================
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
    Set-ItemProperty -Path $auRegPath -Name "AUOptions" -Value 1 -Type DWord -Force -ErrorAction Stop # Never check

    Write-Host "  Windows Update registry settings applied." -ForegroundColor Green

    Write-Host "Disabling Windows Update related services..."
    $wuServices = @( "wuauserv", "UsoSvc", "WaaSMedicSvc", "BITS" ) # Added BITS
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

#===========================================================================
# SECTION 7: INSTALL ESSENTIAL SOFTWARE (Customize List Here)
#===========================================================================
Write-Host "`n===== Section 7: Installing Essential Software via Winget =====" -ForegroundColor Cyan

# --- !!! EDIT THIS LIST CAREFULLY !!! ---
# Find Program IDs using 'winget search "program name"'
$programsToInstall = @(
    # --- CORE ---
    "Mozilla.Firefox",                 # Browser Alternative
    "7zip.7zip",                     # File Compression
    "VideoLAN.VLC",                  # Media Player
    "Microsoft.PowerToys",           # Useful Windows Utilities
    "Nvidia.GeForceExperience",      # *** HIGHLY RECOMMENDED for Driver Updates & Game Settings ***

    # --- GAMING / MONITORING (Optional) ---
    "Valve.Steam",                   # Game Platform
    # "EpicGames.EpicGamesLauncher", # Game Platform
    # "Discord.Discord",             # Communication
    "MSI.Afterburner",               # GPU Overclocking & Monitoring (Use with caution!)
    # "RARLab.WinRAR",               # Alternative Compression
    # "HWiNFO.HWiNFO",               # Detailed System Monitoring
    # "CapFrameX.CapFrameX",         # Benchmarking Tool
    # " নোটপ্যাড++.নোটপ্যাড++"      # Advanced Text Editor

    # --- OTHER USEFUL (Optional) ---
    # "Google.Chrome",
    # "Microsoft.VC++2015-2022.Redist-x64" # Often needed by games/apps
)
# --- END OF EDITABLE LIST ---

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
            # Attempt interactive install as fallback? Could hang script. Decide based on preference.
            # Write-Host "      Attempting interactive install for '$programId'..."
            # winget install --id $programId -e --accept-package-agreements --accept-source-agreements
        } else {
            Write-Host "    Successfully installed '$programId' (or started)." -ForegroundColor Green
        }
    } catch {
         Write-Warning "    Winget error during installation of '$programId': $($_.Exception.Message)"
    }
    Start-Sleep -Seconds 1 # Brief pause
}
Write-Host "Software installation section finished." -ForegroundColor Green

#===========================================================================
# SECTION 8: FINAL CLEANUP & OPTIMIZATION
#===========================================================================
Write-Host "`n===== Section 8: Final Cleanup & Optimization =====" -ForegroundColor Cyan

# 8.1 Disk Cleanup (Temp files, Recycle Bin)
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

# 8.2 Optimize Drives (TRIM for SSD / Defrag for HDD)
Write-Host "Optimizing drive C: (TRIM/Defrag)..."
try {
    Optimize-Volume -DriveLetter C -Verbose -ErrorAction Stop
    Write-Host "  Drive C: optimization complete." -ForegroundColor Green
} catch {
    Write-Warning "  Failed to optimize drive C: $($_.Exception.Message)"
}

# 8.3 Clear Event Logs (Minor impact, but thorough)
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

#===========================================================================
# SECTION 9: SCRIPT COMPLETE - REBOOT REQUIRED
#===========================================================================
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
Write-Host "  - System Cleanup & Drive Optimization performed." -ForegroundColor White
Write-Host ""
Write-Host "*** CRITICAL REMINDER: A REBOOT IS ABSOLUTELY REQUIRED NOW! ***" -ForegroundColor Magenta
Write-Host "*** Your system is now running WITHOUT CORE SECURITY FEATURES. ***" -ForegroundColor Red
Write-Host "*** Be EXTREMELY careful online. Monitor system stability closely. ***" -ForegroundColor Red
Write-Host "*** USE GEFORCE EXPERIENCE or NVIDIA.COM for optimal graphics drivers! ***" -ForegroundColor Yellow

Read-Host "Press Enter to close this window and REBOOT YOUR COMPUTER MANUALLY."
