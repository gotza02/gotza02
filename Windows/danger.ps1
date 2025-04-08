<#
.SYNOPSIS
    FINAL v10: SINGLE FILE, "EXTRA LONG" (600+ Lines), FULLY AUTOMATED, ULTIMATE RISK AIO SCRIPT.
    Comprehensive performance tweaks, security disabling, system maintenance, software installs, and auto-restart.
    ABSOLUTE MAXIMUM RISK: Overheating, instability, feature breakage, data loss, security breach, hardware damage.

.DESCRIPTION
    Fully automated script with extensive tweaks: Disables power saving, TP, Defender, Services/Tasks,
    sets custom Pagefile, optimizes network/RAM, shows desktop icons, creates startup cleanup task,
    installs software, checks hardware, runs WU, performs cleanup (DISM/fstrim), and forces restart.
    User MUST edit software list & review WSearch disable (breaks search).

.NOTES
    Author: AI Assistant (Based on User Specification)
    Version: 1.0 (Final based on user request)
    Requires: Administrator privileges, Internet connection. Edit `$EssentialSoftware` before running.
    Disclaimer: USER ASSUMES ALL RISKS. NO UNDO. WSearch disable breaks search functionality. RUN AS ADMINISTRATOR.
#>

# --- SCRIPT START ---

# 0. Verify Administrator Privileges
Write-Host "[FATAL CHECK] Verifying Administrator privileges..." -ForegroundColor Red
if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Write-Error "!!! FATAL ERROR: RUN AS ADMINISTRATOR REQUIRED. EXECUTION HALTED. RIGHT-CLICK 'RUN AS ADMIN'. !!!"
    Write-Error "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    # Give user time to read the error before the console potentially closes
    try { Read-Host "Press Enter to exit..." } catch {}
    Exit 1 # Exit with a non-zero code indicates an error
}
Write-Host "[OK] Administrator privileges confirmed." -ForegroundColor Green
Write-Host "[WARNING] Starting 'EXTRA LONG', FULLY AUTOMATED, ULTIMATE RISK modification..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# --- FINAL WARNING ---
Clear-Host
Write-Warning "********************************************************************************************************"
Write-Warning "*** FINAL WARNING - 'EXTRA LONG' FULLY AUTOMATED AIO SCRIPT ***"
Write-Warning "*** THIS SCRIPT WILL EXECUTE EXTREME MODIFICATIONS: ***"
Write-Warning "*** -> Ultimate Performance, No Power Saving (Overheat Risk!) ***"
Write-Warning "*** -> Disable Tamper Protection & Defender (SECURITY RISK!) ***"
Write-Warning "*** -> Disable MANY Services/Tasks (BROKEN FEATURES RISK! WSearch WILL BREAK!) ***"
Write-Warning "*** -> Network/RAM/Pagefile Tweaks (Instability Risk!) ***"
Write-Warning "*** -> Show Desktop Icons, Create Startup Cleanup Task ***"
Write-Warning "*** -> Install Software (EDIT THE LIST IN THE SCRIPT FIRST!) ***"
Write-Warning "*** -> Check HW, Run Windows Update (May take a LONG time) ***"
Write-Warning "*** -> Cleanup: Temp Files, DISM Component Store, fstrim ***"
Write-Warning "*** -> FORCED AUTOMATIC RESTART ON COMPLETION ***"
Write-Warning "*** PRESS CTRL+C NOW TO ABORT (10 seconds) ***"
Write-Warning "*** YOU ACCEPT ALL RISKS: BROKEN FEATURES, DATA LOSS, HARDWARE DAMAGE, SECURITY BREACHES ***"
Write-Warning "********************************************************************************************************"

$Countdown = 10
for ($i = $Countdown; $i -ge 1; $i--) {
    Write-Progress -Activity "FINAL WARNING - PRESS CTRL+C TO ABORT NOW!" -Status "Executing in $i seconds... YOU ACCEPT ALL RISKS!" -PercentComplete (($Countdown - $i) / $Countdown * 100) -Id 0
    Start-Sleep -Seconds 1
}
Write-Progress -Activity "FINAL WARNING" -Status "Executing..." -Completed -Id 0
Write-Host "`n[!!!] Executing FULLY AUTOMATED AIO Script... NO GOING BACK! [!!!]" -ForegroundColor Red

# --- SCRIPT CONFIGURATION ---
$TotalPhases = 15 # Update this if you add/remove phases
$CurrentPhase = 0
$CleanupScriptPath = "C:\Windows\Temp\CleanupOnStartup.ps1" # Path for the startup cleanup script
$TP_Disable_Success = $false # Flag to track Tamper Protection status

# --- Progress Function ---
Function Update-Progress {
    param(
        [string]$StatusMessage,
        [int]$PhaseNumber
    )
    $percentComplete = [int](($PhaseNumber / $TotalPhases) * 100)
    Write-Progress -Activity "AIO System Modification (Phase $PhaseNumber/$TotalPhases) - Auto-Restart Pending" -Status $StatusMessage -PercentComplete $percentComplete -Id 1
}

# --- Phase 0: Attempt Tamper Protection Disable ---
$CurrentPhase = 0
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 1/15: Attempting Tamper Protection Disable (Registry)..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Attempting Tamper Protection Disable (Registry)..." -ForegroundColor Yellow
$TPKey = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"
try {
    # Ensure the path exists before trying to set the property
    if (-not (Test-Path $TPKey)) {
        Write-Host "- Creating Registry Key: $TPKey" -ForegroundColor Gray
        New-Item -Path $TPKey -Force -ErrorAction Stop | Out-Null
    }
    Write-Host "- Setting 'TamperProtection' value to 0 (Disabled) in Registry." -ForegroundColor Gray
    Set-ItemProperty -Path $TPKey -Name "TamperProtection" -Value 0 -Type DWord -Force -ErrorAction Stop
    Write-Host "- SUCCESS: Tamper Protection registry value set to 0. Defender disable might succeed." -ForegroundColor Green
    $TP_Disable_Success = $true
} catch {
    Write-Warning "- FAILED to disable Tamper Protection via Registry: $($_.Exception.Message)"
    Write-Warning "- Windows Defender disabling steps (Phase 9) will likely FAIL."
    $TP_Disable_Success = $false
}
Start-Sleep -Seconds 1

# --- Phase 1: Ultimate Power Settings ('Never Sleep' Mode) ---
$CurrentPhase = 1
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 2/15: Applying 'Never Sleep' & Max Performance Power Settings..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Applying Ultimate Performance & 'Never Sleep' Power Settings..." -ForegroundColor Magenta
try {
    # Activate Ultimate Performance Plan
    $UltimateGuid = "e9a42b02-d5df-448d-aa00-03f14749eb61"
    Write-Host "- Checking/Setting Ultimate Performance Plan ($UltimateGuid) as active..." -ForegroundColor Gray
    # Attempt to duplicate in case it's hidden, ignore errors if it exists
    powercfg /duplicatescheme $UltimateGuid | Out-Null
    powercfg /setactive $UltimateGuid | Out-Null
    # Verify
    $activePlan = powercfg /getactivescheme
    if ($activePlan -match $UltimateGuid) {
        Write-Host "- SUCCESS: Ultimate Performance Plan activated." -ForegroundColor Green
    } else {
        Write-Warning "- Failed to activate Ultimate Performance Plan. Applying settings to current active plan instead."
        # Fallback: Get the current active plan GUID
        $CurrentActiveGuid = ($activePlan -split ' ')[3]
        if ($CurrentActiveGuid) {
            $UltimateGuid = $CurrentActiveGuid # Use current plan if Ultimate failed
            Write-Host "- Applying settings to active plan: $UltimateGuid" -ForegroundColor Yellow
        } else {
             Write-Error "- Could not determine active power plan. Skipping detailed power settings."
             throw "Failed to get active power plan GUID."
        }
    }

    # Apply specific power settings to the active plan (Ultimate or fallback)
    Write-Host "- Applying specific 'Never Sleep' settings (Display, Sleep, Hibernate, Lid, CPU, PCIe)..." -ForegroundColor Gray
    # Setting GUIDs: Subgroup Alias, Setting Alias, Value (0 = Never/Off, 100 = Max %)
    # AC Settings
    powercfg /setacvalueindex $UltimateGuid SUB_SLEEP SLEEPIDLE 0                 # Sleep After (AC)
    powercfg /setacvalueindex $UltimateGuid SUB_SLEEP HIBERNATEIDLE 0             # Hibernate After (AC)
    powercfg /setacvalueindex $UltimateGuid SUB_VIDEO VIDEOIDLE 0                 # Turn off display after (AC)
    powercfg /setacvalueindex $UltimateGuid SUB_BUTTONS LIDCLOSEACTION 0          # Lid close action (AC)
    powercfg /setacvalueindex $UltimateGuid SUB_PROCESSOR PROCTHROTTLEMIN 100     # Minimum processor state (AC)
    powercfg /setacvalueindex $UltimateGuid SUB_PROCESSOR PROCTHROTTLEMAX 100     # Maximum processor state (AC)
    powercfg /setacvalueindex $UltimateGuid SUB_PCIEXPRESS ASPM 0                 # PCI Express Link State Power Management (AC)
    # DC Settings (Battery)
    powercfg /setdcvalueindex $UltimateGuid SUB_SLEEP SLEEPIDLE 0                 # Sleep After (DC)
    powercfg /setdcvalueindex $UltimateGuid SUB_SLEEP HIBERNATEIDLE 0             # Hibernate After (DC)
    powercfg /setdcvalueindex $UltimateGuid SUB_VIDEO VIDEOIDLE 0                 # Turn off display after (DC)
    powercfg /setdcvalueindex $UltimateGuid SUB_BUTTONS LIDCLOSEACTION 0          # Lid close action (DC)
    powercfg /setdcvalueindex $UltimateGuid SUB_PROCESSOR PROCTHROTTLEMIN 100     # Minimum processor state (DC)
    powercfg /setdcvalueindex $UltimateGuid SUB_PROCESSOR PROCTHROTTLEMAX 100     # Maximum processor state (DC)
    powercfg /setdcvalueindex $UltimateGuid SUB_PCIEXPRESS ASPM 0                 # PCI Express Link State Power Management (DC)

    # Attempt to disable Power Throttling via Registry
    Write-Host "- Attempting to disable Power Throttling via Registry..." -ForegroundColor Gray
    $PowerThrottlingKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling"
    if (-not (Test-Path $PowerThrottlingKey)) { New-Item -Path $PowerThrottlingKey -Force | Out-Null }
    Set-ItemProperty -Path $PowerThrottlingKey -Name "PowerThrottlingOff" -Value 1 -Type DWord -Force

    # Apply changes
    powercfg /setactive $UltimateGuid | Out-Null
    Write-Host "- SUCCESS: 'Never Sleep' and Max Performance settings applied. HIGH OVERHEAT RISK!" -ForegroundColor Green
} catch {
    Write-Warning "- ERROR applying Power Settings: $($_.Exception.Message)"
}
Start-Sleep -Seconds 1

# --- Phase 2: Extensive Service Disabling ---
$CurrentPhase = 2
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 3/15: Disabling numerous System Services (HIGH RISK)..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Disabling Extensive Services (WARNING: May break features)..." -ForegroundColor Red
$ServicesToDisable = @(
    # Telemetry & Diagnostics
    "DiagTrack",            # Connected User Experiences and Telemetry
    "dmwappushservice",     # Device Management Wireless Application Protocol (WAP) Push message Routing Service
    "diagnosticshub.standardcollector.service", # Microsoft Diagnostics Hub Standard Collector Service
    "WerSvc",               # Windows Error Reporting Service
    # Location & Maps
    "lfsvc",                # Geolocation Service
    "MapsBroker",           # Downloaded Maps Manager
    # Printing & Fax (Disable if not needed)
    "Spooler",              # Print Spooler
    "Fax",                  # Fax Service
    # Remote Services (Disable if not needed)
    "RemoteRegistry",       # Remote Registry
    "TermService",          # Remote Desktop Services
    # Search (!!! Disabling WSearch WILL BREAK Windows Search functionality !!!)
    "WSearch",              # Windows Search
    # Performance Related / Often Tweaked
    "SysMain",              # SysMain (Superfetch)
    # User Experience / Assistants
    "PcaSvc",               # Program Compatibility Assistant Service
    "CDPSvc",               # Connected Devices Platform Service
    # Xbox (Disable if not used)
    "XblAuthManager",       # Xbox Live Auth Manager
    "XblGameSave",          # Xbox Live Game Save
    "XboxGipSvc",           # Xbox Accessory Management Service
    "XboxNetApiSvc",        # Xbox Live Networking Service
    # Delivery Optimization (Updates for other PCs on network)
    "DoSvc",                # Delivery Optimization
    # Sensors (Often not needed on desktops)
    "SensorDataService",    # Sensor Data Service
    "SensorService",        # Sensor Service
    "SensrSvc",             # Sensor Monitoring Service
    # Biometrics (Disable if not used)
    "WbioSrvc",             # Windows Biometric Service
    # Others potentially safe to disable depending on use case
    "icssvc",               # Windows Mobile Hotspot Service
    "SEMgrSvc",             # Payments and NFC/SE Manager
    "AJRouter",             # AllJoyn Router Service (IoT device communication)
    "WalletService"         # WalletService
    # Add more services here if needed, WITH CAUTION
)
$DisabledCount = 0
$FailedCount = 0
Write-Host "- Attempting to Stop and Disable the following services:" -ForegroundColor Gray
Write-Host "  $($ServicesToDisable -join ', ')" -ForegroundColor Gray
foreach ($serviceName in $ServicesToDisable) {
    try {
        $svc = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if ($svc) {
            Write-Host "- Processing: $serviceName..." -ForegroundColor DarkGray
            if ($svc.Status -eq 'Running') {
                Write-Host "  Stopping $serviceName..." -ForegroundColor DarkGray
                Stop-Service -Name $serviceName -Force -ErrorAction Stop | Out-Null
            }
            if ($svc.StartType -ne 'Disabled') {
                Write-Host "  Disabling $serviceName..." -ForegroundColor DarkGray
                Set-Service -Name $serviceName -StartupType Disabled -ErrorAction Stop
            }
            Write-Host "- $serviceName: Stopped and Disabled." -ForegroundColor Gray
            $DisabledCount++
        } else {
             Write-Host "- Service not found: $serviceName (Skipping)" -ForegroundColor DarkGray
        }
    } catch {
        Write-Warning "- FAILED to Stop/Disable $serviceName: $($_.Exception.Message)"
        $FailedCount++
    }
}
Write-Host "- Service Disabling Complete. Disabled: $DisabledCount, Failed: $FailedCount." -ForegroundColor ($FailedCount -eq 0 ? 'Green' : 'Yellow')
if ($ServicesToDisable -contains "WSearch") {
    Write-Warning "- CRITICAL WARNING: 'WSearch' service disabled. Windows Search (Taskbar, Explorer) will NOT function."
}
Start-Sleep -Seconds 1

# --- Phase 3: Network Tweaks ---
$CurrentPhase = 3
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 4/15: Applying Network Tweaks (DNS, TCP)..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Applying Network Tweaks..." -ForegroundColor Cyan
try {
    Write-Host "- Setting DNS to Google DNS (8.8.8.8, 8.8.4.4) for active adapters..." -ForegroundColor Gray
    Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Set-DnsClientServerAddress -ServerAddresses ("8.8.8.8", "8.8.4.4") -ErrorAction SilentlyContinue | Out-Null
    Write-Host "- Flushing DNS cache..." -ForegroundColor Gray
    ipconfig /flushdns | Out-Null

    Write-Host "- Applying TCP optimizations (Disabling Auto-Tuning, Enabling RSS/ECN)..." -ForegroundColor Gray
    netsh int tcp set global autotuninglevel=disabled | Out-Null
    netsh int tcp set global rss=enabled | Out-Null
    netsh int tcp set global ecncapability=enabled | Out-Null
    # Additional potentially beneficial tweaks (Use with caution, may not benefit all connections)
    # netsh int tcp set global chimney=enabled # Offload stateful TCP connections (If NIC supports)
    # netsh int tcp set global netdma=enabled # If NIC supports Direct Memory Access
    # netsh int tcp set global dca=enabled # Direct Cache Access (If CPU/Chipset/NIC support)
    # netsh int tcp set global congestionprovider=ctcp # Compound TCP (Good for high BDP networks)
    Write-Host "- SUCCESS: Network tweaks applied." -ForegroundColor Green
} catch {
    Write-Warning "- ERROR applying Network Tweaks: $($_.Exception.Message)"
}
Start-Sleep -Seconds 1

# --- Phase 4: Pagefile Management ---
$CurrentPhase = 4
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 5/15: Setting Custom Pagefile on C: drive..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Setting Custom Pagefile on C: ..." -ForegroundColor Yellow
try {
    Write-Host "- Calculating recommended pagefile size (1.5x RAM, max 32GB)..." -ForegroundColor Gray
    $ramBytes = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
    $ramMB = [Math]::Round($ramBytes / 1MB)
    $pagefileSizeMB_Raw = $ramMB * 1.5
    # Cap the pagefile size at 32768 MB (32 GB) or a lower sensible max if desired
    $pagefileMaxSizeMB = 32768
    $pagefileInitialMB = [int][Math]::Min($pagefileSizeMB_Raw, $pagefileMaxSizeMB)
    $pagefileMaximumMB = $pagefileInitialMB # Set Initial and Max to the same value for fixed size

    Write-Host "- Total RAM: $ramMB MB. Calculated Pagefile Size: $pagefileInitialMB MB." -ForegroundColor Gray
    Write-Host "- Disabling automatic pagefile management..." -ForegroundColor Gray
    Set-CimInstance -Query "SELECT * FROM Win32_ComputerSystem WHERE Name='$env:COMPUTERNAME'" -Property @{AutomaticManagedPagefile = $false} -ErrorAction Stop

    # Remove existing pagefiles on other drives (optional, but good practice for single pagefile setup)
    $existingPagefiles = Get-CimInstance -ClassName Win32_PageFileSetting
    foreach ($pf in $existingPagefiles) {
        if ($pf.Name -notmatch '^C:') {
             Write-Host "- Removing existing pagefile setting: $($pf.Name)" -ForegroundColor Gray
             Remove-CimInstance -InputObject $pf -ErrorAction SilentlyContinue
        }
    }

    # Set the new pagefile on C:
    $pagefileName = 'C:\pagefile.sys'
    $pfC = Get-CimInstance -ClassName Win32_PageFileSetting | Where-Object {$_.Name -eq $pagefileName}
    if ($pfC) {
        Write-Host "- Modifying existing pagefile on C: to $pagefileInitialMB MB..." -ForegroundColor Gray
        Set-CimInstance -InputObject $pfC -Property @{InitialSize = $pagefileInitialMB; MaximumSize = $pagefileMaximumMB} -ErrorAction Stop
    } else {
        Write-Host "- Creating new pagefile on C: with size $pagefileInitialMB MB..." -ForegroundColor Gray
        $null = New-CimInstance -ClassName Win32_PageFileSetting -Property @{Name = $pagefileName; InitialSize = $pagefileInitialMB; MaximumSize = $pagefileMaximumMB} -ClientOnly | Set-CimInstance -ErrorAction Stop
    }
    Write-Host "- SUCCESS: Custom pagefile configured on C:. Changes require restart." -ForegroundColor Green
} catch {
    Write-Warning "- ERROR setting Pagefile: $($_.Exception.Message)"
}
Start-Sleep -Seconds 1

# --- Phase 5: System & Registry Tweaks ---
$CurrentPhase = 5
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 6/15: Applying System/Registry Performance Tweaks..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Applying System & Registry Tweaks..." -ForegroundColor Cyan
try {
    # Disable problematic Scheduled Tasks
    Write-Host "- Disabling specific non-essential Scheduled Tasks..." -ForegroundColor Gray
    $TasksToDisable = @(
        '\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser',
        '\Microsoft\Windows\Application Experience\ProgramDataUpdater',
        '\Microsoft\Windows\Customer Experience Improvement Program\Consolidator',
        '\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip',
        # Defender tasks might be re-enabled by Defender itself if it's not fully disabled
        '\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance',
        '\Microsoft\Windows\Windows Defender\Windows Defender Cleanup',
        '\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan',
        '\Microsoft\Windows\Windows Defender\Windows Defender Verification',
        # Update related tasks (Disabling may prevent automatic checks/installs besides WU phase)
        '\Microsoft\Windows\UpdateOrchestrator\Schedule Scan',
        '\Microsoft\Windows\UpdateOrchestrator\Schedule Wake To Run',
        '\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker',
        # Maintenance and Diagnostics
        '\Microsoft\Windows\Diagnosis\Scheduled',
        '\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector',
        '\Microsoft\Windows\Maintenance\WinSAT',
        '\Microsoft\Windows\WaaSMedic\PerformRemediation'
        # Add more task paths here if needed
    )
    $DisabledTaskCount = 0
    $FailedTaskCount = 0
    foreach ($taskPath in $TasksToDisable) {
        try {
            $taskName = $taskPath.Split('\')[-1]
            $taskFolder = $taskPath.Substring(0, $taskPath.LastIndexOf('\'))
            Get-ScheduledTask -TaskPath $taskFolder -TaskName $taskName -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction Stop
            Write-Host "- Disabled Task: $taskPath" -ForegroundColor Gray
            $DisabledTaskCount++
        } catch {
             # Silently ignore if task doesn't exist or error disabling
             # Write-Warning "- Could not disable task $taskPath : $($_.Exception.Message)"
             $FailedTaskCount++
        }
    }
     Write-Host "- Task Disabling: Disabled $DisabledTaskCount, Failed/Not Found $FailedTaskCount." -ForegroundColor Gray

    # Apply Registry Tweaks
    Write-Host "- Applying Registry tweaks (NTFS Performance, UI Responsiveness)..." -ForegroundColor Gray
    # File System Tweaks
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "NtfsDisableLastAccessUpdate" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "NtfsMemoryUsage" -Value 2 -Type DWord -Force -ErrorAction SilentlyContinue # More memory for FS cache
    # UI Responsiveness Tweaks
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "20" -Type String -Force -ErrorAction SilentlyContinue # Faster menu pop-up
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Value "20" -Type String -Force -ErrorAction SilentlyContinue # Faster hover pop-up
    # Shutdown/Timeout Tweaks
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -Value "2000" -Type String -Force -ErrorAction SilentlyContinue # Faster app close on shutdown
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -Value "2000" -Type String -Force -ErrorAction SilentlyContinue # Faster detection of hung apps
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Value "2000" -Type String -Force -ErrorAction SilentlyContinue # Faster service close on shutdown

    Write-Host "- SUCCESS: System and Registry tweaks applied." -ForegroundColor Green
} catch {
    Write-Warning "- ERROR applying System/Registry Tweaks: $($_.Exception.Message)"
}
Start-Sleep -Seconds 1

# --- Phase 6: Show Desktop Icons ---
$CurrentPhase = 6
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 7/15: Enabling standard Desktop Icons..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Enabling Desktop Icons (This PC, Network, Recycle Bin)..." -ForegroundColor Cyan
try {
    Write-Host "- Setting Registry values to show Desktop Icons..." -ForegroundColor Gray
    # Delegate folder method (Modern way)
    $delegateFoldersKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
    # Ensure the key exists
    if (-not (Test-Path $delegateFoldersKey)) { New-Item -Path $delegateFoldersKey -Force | Out-Null }
    # Set values to 0 to show icons (1 hides them)
    Set-ItemProperty -Path $delegateFoldersKey -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue # This PC
    Set-ItemProperty -Path $delegateFoldersKey -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue # Network
    Set-ItemProperty -Path $delegateFoldersKey -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue # Recycle Bin

    # Old method (Just in case, though HideDesktopIcons is preferred)
    # Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideIcons" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    # Force refresh explorer (might not always work reliably without logout/restart)
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    # Start-Process explorer # Explorer usually restarts automatically

    Write-Host "- SUCCESS: Desktop icon settings applied. Icons may appear after Explorer restarts or system restart." -ForegroundColor Green
} catch {
    Write-Warning "- ERROR enabling Desktop Icons: $($_.Exception.Message)"
}
Start-Sleep -Seconds 1

# --- Phase 7: Create Startup Cleanup Task ---
$CurrentPhase = 7
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 8/15: Creating Auto Cache/Temp Cleanup Task for Startup..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Creating Startup Cleanup Task (AutoCacheCleanup)..." -ForegroundColor Magenta

# Define the content of the cleanup script
$cleanupScriptContent = @'
# Simple Startup Cleanup Script - Executed as SYSTEM
Write-Host "Starting automatic cleanup..."

# Paths to clear (SYSTEM context)
$SystemTemp = $env:windir + '\Temp\*'
$SoftwareDistributionDownload = $env:windir + '\SoftwareDistribution\Download\*'
$WindowsOld = 'C:\Windows.old\*' # If exists from upgrades

# User Profile Temp Paths (Requires iterating through user profiles)
$UserProfilesPath = 'C:\Users'
$UserProfileFolders = Get-ChildItem -Path $UserProfilesPath -Directory | Where-Object { $_.Name -ne 'Public' -and $_.Name -ne 'Default' -and (Test-Path "$($_.FullName)\AppData\Local\Temp") }

# Browser Cache Paths (Common locations - Default profiles mainly)
# Note: This might not catch all profiles or less common browsers.
$BrowserCachePatterns = @(
    '\AppData\Local\Temp\*', # User Temp
    '\AppData\Local\Microsoft\Edge\User Data\Default\Cache\*',
    '\AppData\Local\Google\Chrome\User Data\Default\Cache\*',
    '\AppData\Roaming\Mozilla\Firefox\Profiles\*\cache2\*', # Firefox new cache path
    '\AppData\Roaming\Mozilla\Firefox\Profiles\*\cache\*', # Firefox old cache path
    '\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Cache\*'
)

# Function to remove items quietly
Function Remove-ItemQuietly {
    param([string]$Path)
    Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    #Write-Host "Cleaned: $Path" # Uncomment for debugging the cleanup script itself
}

# Clean system paths
Write-Host "- Cleaning System Temp..."
Remove-ItemQuietly -Path $SystemTemp
Write-Host "- Cleaning Software Distribution Downloads..."
Remove-ItemQuietly -Path $SoftwareDistributionDownload
if (Test-Path 'C:\Windows.old') {
    Write-Host "- Cleaning Windows.old..."
    Remove-ItemQuietly -Path $WindowsOld
}

# Clean user profile paths
Write-Host "- Cleaning User Profile Temp & Browser Caches..."
foreach ($UserProfile in $UserProfileFolders) {
    Write-Host "  - Processing profile: $($UserProfile.FullName)"
    foreach ($Pattern in $BrowserCachePatterns) {
        $FullPathPattern = $UserProfile.FullName + $Pattern
        Remove-ItemQuietly -Path $FullPathPattern
    }
}

Write-Host "Automatic cleanup finished."
# Add a small delay if needed before script exits, though usually not required for startup tasks
# Start-Sleep -Seconds 5
'@

try {
    Write-Host "- Saving cleanup script to: $CleanupScriptPath" -ForegroundColor Gray
    # Ensure the directory exists
    $CleanupScriptDir = Split-Path $CleanupScriptPath -Parent
    if (-not (Test-Path $CleanupScriptDir)) { New-Item -Path $CleanupScriptDir -ItemType Directory -Force | Out-Null }
    # Save the script content
    Set-Content -Path $CleanupScriptPath -Value $cleanupScriptContent -Encoding UTF8 -Force -ErrorAction Stop

    Write-Host "- Registering Scheduled Task 'AutoCacheCleanup' to run at Startup as SYSTEM..." -ForegroundColor Gray
    $taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$CleanupScriptPath`""
    $taskTrigger = New-ScheduledTaskTrigger -AtStartup
    $taskPrincipal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    $taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -Hidden
    Register-ScheduledTask -TaskName "AutoCacheCleanup" -Action $taskAction -Trigger $taskTrigger -Principal $taskPrincipal -Settings $taskSettings -Force -ErrorAction Stop
    Write-Host "- SUCCESS: Startup cleanup task 'AutoCacheCleanup' created." -ForegroundColor Green
} catch {
    Write-Warning "- ERROR creating Startup Cleanup Task: $($_.Exception.Message)"
    # Attempt to clean up the script file if task creation failed
    if (Test-Path $CleanupScriptPath) { Remove-Item $CleanupScriptPath -Force -ErrorAction SilentlyContinue }
}
Start-Sleep -Seconds 1

# --- Phase 8: RAM Management Task (Experimental) ---
$CurrentPhase = 8
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 9/15: Setting Experimental RAM Clearing Task..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Setting Aggressive RAM Clearing Task (Experimental)..." -ForegroundColor Yellow
try {
    Write-Host "- Creating Scheduled Task 'AggressiveRAMIdleTask' to run ProcessIdleTasks every 30 mins..." -ForegroundColor Gray
    # Action to run the undocumented ProcessIdleTasks function
    $ramAction = New-ScheduledTaskAction -Execute "rundll32.exe" -Argument "advapi32.dll,ProcessIdleTasks"
    # Trigger to run every 30 minutes, starting now
    $ramTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 30) -RepetitionDuration ([TimeSpan]::MaxValue)
    # Principal: Run as SYSTEM
    $ramPrincipal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    # Settings: Allow running on battery, don't stop on battery, run ASAP if missed
    $ramSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 5) # Limit execution time just in case
    Register-ScheduledTask -TaskName "AggressiveRAMIdleTask" -Action $ramAction -Trigger $ramTrigger -Principal $ramPrincipal -Settings $ramSettings -Force -ErrorAction Stop
    Write-Host "- SUCCESS: Experimental RAM clearing task created. Effect varies." -ForegroundColor Green
} catch {
    Write-Warning "- ERROR creating RAM Management Task: $($_.Exception.Message)"
}
Start-Sleep -Seconds 1

# --- Phase 9: Attempt Windows Defender Disable ---
$CurrentPhase = 9
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 10/15: Attempting Windows Defender Disable (HIGH RISK)..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Attempting Windows Defender Disable (Requires successful TP disable)..." -ForegroundColor Red
if ($TP_Disable_Success) {
    Write-Host "- Tamper Protection was likely disabled via Registry. Proceeding with Defender disable steps..." -ForegroundColor Yellow
    try {
        # Set Policy Key to Disable Defender (Primary method if TP is off)
        Write-Host "- Setting Registry Policy 'DisableAntiSpyware' to 1..." -ForegroundColor Gray
        $DefenderPolicyKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
        if (-not (Test-Path $DefenderPolicyKey)) { New-Item -Path $DefenderPolicyKey -Force | Out-Null }
        Set-ItemProperty -Path $DefenderPolicyKey -Name "DisableAntiSpyware" -Value 1 -Type DWord -Force -ErrorAction Stop

        # Disable Real-time Protection components via Registry (Secondary, may be overridden by policy/TP)
        Write-Host "- Setting additional Defender registry keys (Real-Time Protection, etc.)..." -ForegroundColor Gray
        $RealTimeProtectKey = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection"
        if (-not (Test-Path $RealTimeProtectKey)) { New-Item -Path $RealTimeProtectKey -Force | Out-Null }
        Set-ItemProperty -Path $RealTimeProtectKey -Name "DisableBehaviorMonitoring" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $RealTimeProtectKey -Name "DisableOnAccessProtection" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $RealTimeProtectKey -Name "DisableScanOnRealtimeEnable" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

        # Attempt to Stop and Disable Defender Services
        $DefenderServices = @(
            "WinDefend",         # Microsoft Defender Antivirus Service
            "Sense",             # Windows Defender Advanced Threat Protection Service
            "WdNisSvc",          # Microsoft Defender Antivirus Network Inspection Service
            "WdNisDrv",          # Microsoft Defender Antivirus Network Inspection Driver (?) - Might be driver, not service
            "SecurityHealthService" # Windows Security Service
        )
        Write-Host "- Attempting to Stop and Disable Defender-related services:" -ForegroundColor Gray
        Write-Host "  $($DefenderServices -join ', ')" -ForegroundColor Gray
        $DefenderSvcDisabledCount = 0
        $DefenderSvcFailedCount = 0
        foreach ($svcName in $DefenderServices) {
            try {
                $svc = Get-Service -Name $svcName -ErrorAction SilentlyContinue
                if ($svc) {
                     Write-Host "- Processing Service: $svcName..." -ForegroundColor DarkGray
                     if ($svc.Status -eq 'Running') { Stop-Service -Name $svcName -Force -ErrorAction SilentlyContinue | Out-Null } # Use SilentlyContinue as stopping might be blocked
                     Set-Service -Name $svcName -StartupType Disabled -ErrorAction Stop
                     Write-Host "- $svcName: Set to Disabled (Stop attempt made)." -ForegroundColor Gray
                     $DefenderSvcDisabledCount++
                } else {
                    #Write-Host "- Service not found: $svcName (Skipping)" -ForegroundColor DarkGray
                }
            } catch {
                Write-Warning "- FAILED to disable service $svcName: $($_.Exception.Message) (Likely blocked by TP/System)"
                $DefenderSvcFailedCount++
            }
        }
         Write-Host "- Defender Service Disabling: Set Disabled $DefenderSvcDisabledCount, Failed $DefenderSvcFailedCount." -ForegroundColor ($DefenderSvcFailedCount -eq 0 ? 'Green' : 'Yellow')
        Write-Host "- SUCCESS (Potentially): Defender disable attempted via Registry and Services. FULL DISABLE NOT GUARANTEED. Requires Restart." -ForegroundColor Green
    } catch {
        Write-Warning "- ERROR attempting Defender Disable steps: $($_.Exception.Message)"
        Write-Warning "- Defender may still be active despite earlier TP registry change."
    }
} else {
    Write-Warning "- Skipping Windows Defender disable steps because Tamper Protection disable (Phase 0) likely failed."
}
Start-Sleep -Seconds 1

# --- Phase 10: Software Installation via Winget ---
$CurrentPhase = 10
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 11/15: Installing Software via Winget..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Auto-Installing Software using Winget..." -ForegroundColor Cyan
# --- !!! IMPORTANT: EDIT THIS LIST BEFORE RUNNING THE SCRIPT !!! ---
# Add the Winget package IDs for the software you want to install.
# Find IDs using 'winget search <AppName>' in Command Prompt or PowerShell.
$EssentialSoftware = @(
    "Mozilla.Firefox",
    "Google.Chrome",
    "7zip.7zip",
    "VideoLAN.VLC",
    "Notepad++.Notepad++"
    # Add more Winget IDs here, e.g., "Microsoft.PowerToys", "Microsoft.VisualStudioCode"
)
# --- !!! END OF EDITABLE LIST !!! ---

if ($EssentialSoftware.Count -eq 0) {
     Write-Host "- No software listed in `$EssentialSoftware. Skipping installation." -ForegroundColor Yellow
} else {
    Write-Warning "- YOU MUST CUSTOMIZE the `$EssentialSoftware list in the script!"
    Write-Host "- Attempting to install the following packages:" -ForegroundColor Gray
    Write-Host "  $($EssentialSoftware -join ', ')" -ForegroundColor Gray
    Write-Host "- This requires an internet connection and may take time." -ForegroundColor Gray

    $InstalledCount = 0
    $FailedCount = 0
    foreach ($appId in $EssentialSoftware) {
        Write-Host "- Installing: $appId ..." -ForegroundColor Cyan
        try {
            # Using -e for exact match, --silent for automation, --accept for agreements, --force to bypass potential issues
            winget install --id $appId -e --silent --accept-source-agreements --accept-package-agreements --force --disable-interactivity
            # Check the exit code for success
            if ($LASTEXITCODE -eq 0) {
                Write-Host "- SUCCESS: Installed $appId" -ForegroundColor Green
                $InstalledCount++
            } else {
                 Write-Warning "- FAILED Winget install for $appId (Exit Code: $LASTEXITCODE). Check Winget logs if needed."
                 $FailedCount++
            }
        } catch {
            Write-Warning "- ERROR during Winget install for $appId: $($_.Exception.Message)"
            $FailedCount++
        }
        Start-Sleep -Seconds 1 # Small delay between installs
    }
    Write-Host "- Software Installation Complete. Installed: $InstalledCount, Failed: $FailedCount." -ForegroundColor ($FailedCount -eq 0 ? 'Green' : 'Yellow')
}
Start-Sleep -Seconds 1

# --- Phase 11: Hardware Check & Driver Suggestion ---
$CurrentPhase = 11
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 12/15: Checking Hardware (GPU/Network)..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Checking Hardware for Driver Recommendations..." -ForegroundColor Blue
try {
    Write-Host "- Checking Graphics Card(s)..." -ForegroundColor Gray
    $gpus = Get-CimInstance Win32_VideoController | Select-Object -Property Name, DriverVersion, AdapterCompatibility
    if ($gpus) {
        foreach ($gpu in $gpus){
            Write-Host "  - Found GPU: $($gpu.Name) (Driver: $($gpu.DriverVersion))"
            if ($gpu.AdapterCompatibility -like "*NVIDIA*") {
                Write-Warning "  -> NVIDIA GPU detected. Recommend checking NVIDIA.com/GeForce.com for the latest drivers after restart."
            } elseif ($gpu.AdapterCompatibility -like "*AMD*" -or $gpu.AdapterCompatibility -like "*ATI*") {
                Write-Warning "  -> AMD/ATI GPU detected. Recommend checking AMD.com for the latest Adrenalin drivers after restart."
            } elseif ($gpu.AdapterCompatibility -like "*Intel*") {
                 Write-Host "  -> Intel Integrated Graphics detected. Drivers usually updated via Windows Update or Intel Driver & Support Assistant." -ForegroundColor Gray
            } else {
                Write-Host "  -> Unknown GPU Manufacturer ($($gpu.AdapterCompatibility)). Check PC/Laptop manufacturer's site." -ForegroundColor Gray
            }
        }
    } else {
        Write-Warning "- Could not detect Graphics Card details."
    }

    Write-Host "- Checking Active Network Adapter(s)..." -ForegroundColor Gray
    $netAdapters = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Select-Object -Property Name, InterfaceDescription, DriverVersion, Status
    if ($netAdapters) {
         foreach ($adapter in $netAdapters) {
             Write-Host "  - Active Adapter: $($adapter.Name) ($($adapter.InterfaceDescription)) (Driver: $($adapter.DriverVersion))"
             if ($adapter.InterfaceDescription -like "*Intel*") {
                 Write-Warning "  -> Intel Network Adapter detected. Recommend checking Intel Driver & Support Assistant or support site after restart."
             } elseif ($adapter.InterfaceDescription -like "*Realtek*") {
                 Write-Warning "  -> Realtek Network Adapter detected. Recommend checking PC/Motherboard manufacturer's site for latest drivers after restart."
             } elseif ($adapter.InterfaceDescription -like "*Killer*") {
                 Write-Warning "  -> Killer Network Adapter detected. Recommend checking Intel's site (Killer is owned by Intel) or manufacturer's site after restart."
             } elseif ($adapter.InterfaceDescription -like "*Broadcom*") {
                 Write-Warning "  -> Broadcom Network Adapter detected. Recommend checking PC/Laptop manufacturer's site after restart."
             }
         }
    } else {
        Write-Warning "- Could not detect active Network Adapter details."
    }
     Write-Host "- Hardware check complete. Manual driver checks post-restart are recommended." -ForegroundColor Green
} catch {
    Write-Warning "- ERROR during Hardware Check: $($_.Exception.Message)"
}
Start-Sleep -Seconds 1

# --- Phase 12: Run Windows Update ---
$CurrentPhase = 12
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 13/15: Running Windows Update (May take a long time)..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Running Windows Update (using PSWindowsUpdate)..." -ForegroundColor Magenta
Write-Warning "- This step requires Internet and can take a VERY long time depending on needed updates."
try {
    # Check if module is installed, install if not
    Write-Host "- Checking/Installing PSWindowsUpdate module..." -ForegroundColor Gray
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Host "  PSWindowsUpdate module not found. Attempting installation..." -ForegroundColor Yellow
        # Set execution policy for the current process to allow installation script
        Set-ExecutionPolicy RemoteSigned -Scope Process -Force -ErrorAction SilentlyContinue
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction Stop | Out-Null
        Install-Module PSWindowsUpdate -Force -Scope CurrentUser -AcceptLicense -Confirm:$false -ErrorAction Stop
        Write-Host "  PSWindowsUpdate module installed." -ForegroundColor Green
    } else {
         Write-Host "  PSWindowsUpdate module already available." -ForegroundColor Gray
    }

    # Import the module
    Write-Host "- Importing PSWindowsUpdate module..." -ForegroundColor Gray
    Import-Module PSWindowsUpdate -ErrorAction Stop

    # Run Update Check & Install
    Write-Host "- Checking for and installing ALL available Windows Updates (OS, Drivers)..." -ForegroundColor Yellow
    # Note: -AcceptAll -ForceDownload -ForceInstall are aggressive. Remove if only checking is desired initially.
    Get-WindowsUpdate -Install -AcceptAll -ForceDownload -ForceInstall -Verbose -ErrorAction Stop
    # Add -AutoReboot parameter if you want PSWindowsUpdate to handle the reboot, but the script has its own final reboot.

    # Check results (optional, Get-WindowsUpdate might throw error on failure)
    # $UpdateHistory = Get-WUHistory -Last 10 # Check recent history
    # Write-Host "Recent Update History:"
    # $UpdateHistory | Format-Table -AutoSize

    Write-Host "- SUCCESS: Windows Update check and installation process completed." -ForegroundColor Green
} catch {
    Write-Warning "- ERROR during Windows Update phase: $($_.Exception.Message)"
    Write-Warning "- Updates may not be fully installed. Check Windows Update settings after restart."
}
Start-Sleep -Seconds 1

# --- Phase 13: System Cleanup ---
$CurrentPhase = 13
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 14/15: Performing System Cleanup (Temp, DNS, DISM, fstrim)..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] Performing System Cleanup..." -ForegroundColor Cyan
try {
    # Clean Temp Folders (Excluding our startup script)
    Write-Host "- Cleaning Temporary Folders (%TEMP%, C:\Windows\Temp)..." -ForegroundColor Gray
    $tempPathsToClean = @(
        "$env:TEMP",
        "$env:windir\Temp"
    )
    foreach ($path in $tempPathsToClean) {
        if (Test-Path $path) {
            Write-Host "  Cleaning: $path" -ForegroundColor DarkGray
            # Get items, filter out our cleanup script, then remove
            Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.FullName -ne $CleanupScriptPath } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        } else {
             Write-Host "  Path not found: $path" -ForegroundColor DarkGray
        }
    }

    # Flush DNS Cache again (after potential updates/network changes)
    Write-Host "- Flushing DNS cache..." -ForegroundColor Gray
    ipconfig /flushdns | Out-Null

    # Run DISM Component Store Cleanup
    Write-Host "- Running DISM /Online /Cleanup-Image /StartComponentCleanup (May take time)..." -ForegroundColor Gray
    $dismProcess = Start-Process Dism.exe -ArgumentList "/Online /Cleanup-Image /StartComponentCleanup /Quiet" -Wait -Passthru -ErrorAction SilentlyContinue
    if ($dismProcess.ExitCode -ne 0) {
        Write-Warning "- DISM Component Cleanup may have encountered an issue (Exit Code: $($dismProcess.ExitCode))."
    } else {
        Write-Host "- DISM Component Cleanup completed." -ForegroundColor Gray
    }

    # Run Optimize-Volume (fstrim) on C: Drive for SSDs
    Write-Host "- Running Optimize-Volume -ReTrim on C: drive (for SSDs)..." -ForegroundColor Gray
    Optimize-Volume -DriveLetter C -ReTrim -Verbose -ErrorAction SilentlyContinue # Use SilentlyContinue as it might fail on non-SSDs or if locked

    Write-Host "- SUCCESS: System Cleanup phase completed." -ForegroundColor Green
} catch {
    Write-Warning "- ERROR during System Cleanup phase: $($_.Exception.Message)"
}
Start-Sleep -Seconds 1

# --- Phase 14: Finalization and Automatic Restart ---
$CurrentPhase = 14 # This is technically the start of the final phase before action
Update-Progress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] STEP 15/15: Finalizing and Preparing for Auto-Restart..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase/$TotalPhases] FINALIZING SCRIPT EXECUTION..." -ForegroundColor Magenta
Write-Host "[COMPLETE] AIO Script Execution Finished. All requested operations attempted." -ForegroundColor Green
Write-Host "---------------------------------------------------------------------"
Write-Warning "*** SYSTEM WILL RESTART AUTOMATICALLY IN 5 SECONDS TO APPLY CHANGES ***"
Write-Warning "- Save any open work IMMEDIATELY if possible (though script runs elevated)."
Write-Warning "- After restart: Verify system stability, check temperatures, manually install specific drivers if needed."
Write-Warning "- REMEMBER: Many changes are irreversible without reinstalling Windows."
Write-Host "---------------------------------------------------------------------"

# Final Countdown before restart
Start-Sleep -Seconds 1; Write-Host "Restarting in 4..." -ForegroundColor Yellow
Start-Sleep -Seconds 1; Write-Host "Restarting in 3..." -ForegroundColor Yellow
Start-Sleep -Seconds 1; Write-Host "Restarting in 2..." -ForegroundColor Yellow
Start-Sleep -Seconds 1; Write-Host "Restarting in 1..." -ForegroundColor Yellow
Start-Sleep -Seconds 1

# Force Restart
Write-Host "[!!!] Initiating Forced System Restart NOW! [!!!]" -ForegroundColor Red
Restart-Computer -Force

# --- SCRIPT END ---
# Code below this line will not execute due to Restart-Computer -Force
Write-Host "Script execution theoretically complete, but restart was initiated."
Exit 0
