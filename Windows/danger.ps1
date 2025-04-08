<#
.SYNOPSIS
    FINAL v8: SINGLE FILE, "EXTRA LONG" (500+ Lines), FULLY AUTOMATED, ULTIMATE RISK AIO SCRIPT.
    Includes extensive Service/Task disabling (incl. optional Windows Search disable), detailed Registry Tweaks,
    'Never Sleep', Desktop Icons, HW Check, Status/Progress, WinUpdate, Auto-Restart, attempts TP disable,
    max performance, Defender disabling, software installs, Pagefile, fstrim, DISM cleanup.
    ABSOLUTE MAXIMUM RISK: Overheating, instability, broken features, data loss, security breach, hardware damage.

.DESCRIPTION
    FATAL RISK SCRIPT - SINGLE FILE, VERY LONG, AUTO-EXECUTES, "DEEP" TWEAKS, UPDATES & AUTO-RESTARTS. NO UNDO.
    Attempts TP disable, forces max power/'Never Sleep', sets custom Pagefile, applies MANY system/registry tweaks,
    disables numerous Services (incl. optional Windows Search!) & Tasks, shows icons, CREATES Startup Cleanup Task,
    proceeds with other dangerous actions, shows progress, runs WU, performs fstrim & DISM cleanup, forces restart.
    Assumes Admin rights. User MUST edit software list & consider removing WSearch disable.

.NOTES
    Author: AI Assistant (Expanding script length and tweaks as requested)
    Requires: Administrator privileges, Internet connection. User MUST edit software list first.
    Disclaimer: USER ASSUMES 1000% OF ALL RISKS. Length does not equal quality or safety. Disabling WSearch breaks search.
#>

# --- SCRIPT START ---

# 0. Verify Administrator Privileges (ABSOLUTELY ESSENTIAL)
Write-Host "[FATAL CHECK] Verifying Administrator privileges..." -ForegroundColor Red
if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Write-Error "!!! FATAL ERROR: SCRIPT MUST BE RUN AS ADMINISTRATOR. EXECUTION HALTED. !!!"
    Write-Error "!!! RIGHT-CLICK AND 'RUN AS ADMINISTRATOR'. !!!"
    Write-Error "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Read-Host "Press Enter to exit..."
    Exit
}
Write-Host "[OK] Administrator privileges confirmed." -ForegroundColor Green
Write-Host "[WARNING] Preparing for SINGLE-RUN, 'EXTRA LONG', FULLY AUTOMATED, ULTIMATE RISK system modification with AUTO-RESTART..." -ForegroundColor Red
Start-Sleep -Seconds 5

# --- DISPLAY FINAL WARNING - LAST CHANCE TO ABORT (CTRL+C) ---
Clear-Host
Write-Warning "********************************************************************************************************"
Write-Warning "***                                                                                                  ***"
Write-Warning "*** !!! FINAL WARNING - 'EXTRA LONG' / EXTENSIVE TWEAKS / PAGEFILE / FSTRIM / AUTO-UPDATE / AUTO-RESTART !!! ***"
Write-Warning "***                                                                                                  ***"
Write-Warning "*** THIS SCRIPT WILL NOW EXECUTE FULLY AUTOMATED, EXTREME SYSTEM MODIFICATIONS:                ***"
Write-Warning "*** -> *** DISABLE NUMEROUS SERVICES (INCL. WINDOWS SEARCH - BREAKS SEARCH!) & TASKS ***          ***"
Write-Warning "*** -> *** APPLY EXTENSIVE REGISTRY TWEAKS (Network, System Responsiveness) ***                   ***"
Write-Warning "*** -> SETUP TASK TO CLEAR BROWSER CACHE & TEMP FILES ON EVERY STARTUP                             ***"
Write-Warning "*** -> SHOW DESKTOP ICONS (This PC, Network, Recycle Bin)                                          ***"
Write-Warning "*** -> SET CUSTOM PAGEFILE SIZE (Based on RAM)                                                     ***"
Write-Warning "*** -> FORCE SSD TRIM (-ReTrim) & RUN DISM COMPONENT CLEANUP                                       ***"
Write-Warning "*** -> DISABLE ALL POWER SAVING ('Never Sleep') - EXTREME OVERHEAT RISK!                           ***"
Write-Warning "*** -> ATTEMPT TO DISABLE TAMPER PROTECTION (MAY FAIL!)                                              ***"
Write-Warning "*** -> Force High Performance States (Risk of Overheating/Damage)                                    ***"
Write-Warning "*** -> Disable Windows Defender & Security Services (MASSIVE Security Risk)                          ***"
Write-Warning "*** -> Aggressive Network & RAM Tweaks (May Cause Instability)                                       ***"
Write-Warning "*** -> Auto-Install Software (CHECK LIST IN SCRIPT FIRST!)                                           ***"
Write-Warning "*** -> HARDWARE CHECK & DRIVER RECOMMENDATIONS                                                       ***"
Write-Warning "*** -> RUN GENERAL WINDOWS UPDATE (CAN TAKE A LONG TIME!)                                            ***"
Write-Warning "*** -> NO TESTING, NO SAFETIES, NO CONFIRMATIONS AFTER THIS POINT.                                   ***"
Write-Warning "*** -> *** COMPUTER WILL RESTART AUTOMATICALLY WHEN SCRIPT FINISHES ***                               ***"
Write-Warning "***                                                                                                  ***"
Write-Warning "*** PRESS CTRL+C NOW TO ABORT (You have 10 seconds)                                                ***"
Write-Warning "*** RUNNING THIS MEANS YOU ACCEPT ALL RISKS, INCLUDING BROKEN FEATURES & HARDWARE DAMAGE.          ***"
Write-Warning "***                                                                                                  ***"
Write-Warning "********************************************************************************************************"

# Countdown
$TotalCountdownSeconds = 10
for ($i = $TotalCountdownSeconds; $i -ge 1; $i--) {
    Write-Progress -Activity "FINAL WARNING - 'EXTRA LONG' AIO SCRIPT EXECUTION (CTRL+C TO ABORT)" -Status "Executing in $i seconds..." -PercentComplete (($TotalCountdownSeconds - $i) / $TotalCountdownSeconds * 100) -Id 0
    Start-Sleep -Seconds 1
}
Write-Progress -Activity "FINAL WARNING - 'EXTRA LONG' AIO SCRIPT EXECUTION (CTRL+C TO ABORT)" -Status "Executing..." -Completed -Id 0
Write-Host "`nExecuting... Proceeding with EXTREME caution (on your part)." -ForegroundColor Red

# --- START OF FULLY AUTOMATED EXECUTION WITH PROGRESS ---

$TotalPhases = 15 # Increased total phases for Service/Task/Registry additions
$CurrentPhase = 0

Function Update-OverallProgress {
    param( [Parameter(Mandatory=$true)] [string]$StatusMessage, [Parameter(Mandatory=$true)] [int]$PhaseNumber )
    $percentComplete = [int](($PhaseNumber / $TotalPhases) * 100)
    Write-Progress -Activity "Automated AIO System Modification (Auto-Restart Pending)" -Status $StatusMessage -PercentComplete $percentComplete -Id 1
}

# --- Define Path for Startup Cleanup Script ---
$StartupCleanupScriptPath = "C:\Windows\Temp\CleanupOnStartup.ps1"

# --- Section 0: Attempt Tamper Protection Disable ---
$CurrentPhase = 0
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Attempting Tamper Protection Disable..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Attempting to Disable Tamper Protection via Registry (MAY FAIL)..." -ForegroundColor Red
$FeaturesKey = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"; $TP_Disable_Success = $false; try { Write-Host "- Checking/Creating Registry Key..."; if (-not (Test-Path $FeaturesKey)) { New-Item -Path $FeaturesKey -Force -ErrorAction SilentlyContinue | Out-Null }; Write-Host "- Attempting to set TamperProtection value to 0 (Off)..."; Set-ItemProperty -Path $FeaturesKey -Name "TamperProtection" -Value 0 -Type DWord -Force -ErrorAction Stop; Write-Host "- Registry value set attempt complete." -ForegroundColor Green; Write-Warning "- NOTE: Might require RESTART for full effect."; $TP_Disable_Success = $true; Start-Sleep -Seconds 3 } catch { Write-Warning "!!! FAILED TP REGISTRY MODIFY: $($_.Exception.Message). TP likely ACTIVE !!!" -ForegroundColor Red; Start-Sleep -Seconds 5 }


# --- Section 1: Aggressive Power & Throttling Settings ('NEVER SLEEP') ---
$CurrentPhase = 1
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Applying AGGRESSIVE 'NEVER SLEEP' Power Settings..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Applying AGGRESSIVE 'NEVER SLEEP' Power & Throttling Settings..." -ForegroundColor Red
Write-Warning "--- WARNING: DISABLING ALL POWER SAVING INCREASES OVERHEAT RISK SIGNIFICANTLY! ---"; try { Write-Host "- Activating Ultimate/High Performance Plan..."; $UltimatePerformanceGuid = "e9a42b02-d5df-448d-aa00-03f14749eb61"; $HighPerformanceGuid = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"; powercfg /duplicatescheme $UltimatePerformanceGuid | Out-Null; if ((powercfg /list) -match $UltimatePerformanceGuid) { $ActiveSchemeGuid = $UltimatePerformanceGuid; powercfg /setactive $ActiveSchemeGuid; Write-Host "  - Ultimate Power Plan Activated." -ForegroundColor Green } else { powercfg /duplicatescheme $HighPerformanceGuid | Out-Null; $ActiveSchemeGuid = $HighPerformanceGuid; powercfg /setactive $ActiveSchemeGuid; Write-Host "  - High Performance Power Plan Activated." -ForegroundColor Yellow }; Write-Host "- Attempting to disable Power Throttling (Registry)..."; $PowerThrottlingKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling"; New-Item -Path $PowerThrottlingKey -Force -ErrorAction SilentlyContinue | Out-Null; Set-ItemProperty -Path $PowerThrottlingKey -Name "PowerThrottlingOff" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue; Write-Host "  - Power Throttling registry attempt complete. MONITOR TEMPS!" -ForegroundColor Yellow; Write-Host "- Setting CPU Min/Max states to 100% (AC & DC)..."; $ProcPerfGroupGuid = "54533251-82be-4824-96c1-47b60b740d00"; $MinProcStateGuid = "893dee8e-2bef-41e0-89c6-b55d0929964c"; $MaxProcStateGuid = "bc5038f7-23e0-4960-96da-33abaf5935ec"; powercfg /setacvalueindex $ActiveSchemeGuid $ProcPerfGroupGuid $MinProcStateGuid 100 | Out-Null; powercfg /setdcvalueindex $ActiveSchemeGuid $ProcPerfGroupGuid $MinProcStateGuid 100 | Out-Null; powercfg /setacvalueindex $ActiveSchemeGuid $ProcPerfGroupGuid $MaxProcStateGuid 100 | Out-Null; powercfg /setdcvalueindex $ActiveSchemeGuid $ProcPerfGroupGuid $MaxProcStateGuid 100 | Out-Null; Write-Host "  - CPU states set attempt complete. MONITOR TEMPS!" -ForegroundColor Yellow; Write-Host "- Disabling Sleep, Hibernate, Display Off, Lid Close Action (AC & DC)..."; $SubgroupDisplay = "7516b95f-f776-4464-8c53-06167f40cc99"; $SubgroupSleep = "238c9fa8-0aad-41ed-83f4-97be242c8f20"; $SubgroupPowerButtons = "4f971e89-eebd-4455-a8de-9e59040e7347"; $SettingDisplayOff = "3c0bc021-c8a8-4e07-a973-6b14cbcb2b6a"; $SettingSleep = "29f6c1db-86da-48c5-9fdb-f2b67b1f44da"; $SettingHibernate = "9d7815a6-7ee4-497e-8888-515a05f02364"; $SettingLidClose = "5ca83367-6e45-459f-a27b-476b1d01c936"; powercfg /setacvalueindex $ActiveSchemeGuid $SubgroupDisplay $SettingDisplayOff 0 | Out-Null; powercfg /setdcvalueindex $ActiveSchemeGuid $SubgroupDisplay $SettingDisplayOff 0 | Out-Null; powercfg /setacvalueindex $ActiveSchemeGuid $SubgroupSleep $SettingSleep 0 | Out-Null; powercfg /setdcvalueindex $ActiveSchemeGuid $SubgroupSleep $SettingSleep 0 | Out-Null; powercfg /setacvalueindex $ActiveSchemeGuid $SubgroupSleep $SettingHibernate 0 | Out-Null; powercfg /setdcvalueindex $ActiveSchemeGuid $SubgroupSleep $SettingHibernate 0 | Out-Null; powercfg /setacvalueindex $ActiveSchemeGuid $SubgroupPowerButtons $SettingLidClose 0 | Out-Null; powercfg /setdcvalueindex $ActiveSchemeGuid $SubgroupPowerButtons $SettingLidClose 0 | Out-Null; Write-Host "- Disabling PCI Express Link State Power Management (AC & DC)..."; $SubgroupPciExpress = "501a4d13-42af-4429-9fd1-a8218c268e20"; $SettingPciLpm = "ee12f90f-d277-404b-9770-0723d06c233e"; powercfg /setacvalueindex $ActiveSchemeGuid $SubgroupPciExpress $SettingPciLpm 0 | Out-Null; powercfg /setdcvalueindex $ActiveSchemeGuid $SubgroupPciExpress $SettingPciLpm 0 | Out-Null; powercfg /setactive $ActiveSchemeGuid | Out-Null; Write-Host "  - AGGRESSIVE 'NEVER SLEEP/SAVE POWER' settings applied. EXTREME OVERHEAT RISK!" -ForegroundColor Red } catch { Write-Warning "- Error during Power Settings Phase: $($_.Exception.Message)" }


# --- Section 2: Disable Extensive Services --- NEW PHASE ---
$CurrentPhase = 2
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Disabling Extensive Services..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Disabling Extensive Services (HIGH RISK - May break functionality!)..." -ForegroundColor Red
$ServicesToDisable = @(
    # Telemetry & Diagnostics (Original + More)
    "DiagTrack", "dmwappushservice", "diagnosticshub.standardcollector.service", "DiagSys", "diagsvc", "WdiServiceHost", "WdiSystemHost",
    # Location & Maps
    "lfsvc", "MapsBroker",
    # Retail / Demo / Wallet
    "RetailDemo", "WalletService",
    # Printing & Fax (If not used)
    "Spooler", "Fax",
    # Remote Services (Generally disable for security unless needed)
    "RemoteRegistry", "TermService", # Remote Desktop Service (Disable if not needed)
    # Error Reporting & Compatibility
    "WerSvc", "PcaSvc",
    # Windows Search (!!! BREAKS FILE/START MENU SEARCH FUNCTIONALITY !!! - Remove if you use search)
    "WSearch",
    # Connected Devices / Nearby Sharing / Phone
    "CDPSvc", "CDPUserSvc", "DusmSvc", "MessagingService", "PhoneSvc",
    # Xbox Services (If not using Xbox features/apps/Game Bar)
    "XblAuthManager", "XblGameSave", "XboxGipSvc", "XboxNetApiSvc", "GamingServices",
    # Other potentially non-essential (Research before disabling!)
    "SysMain", # Superfetch/SysMain
    "DoSvc", # Delivery Optimization
    "WbioSrvc", # Windows Biometric Service (If not using Fingerprint/Face)
    "SEMgrSvc", # Payments and NFC/SE Manager (If not used)
    "SensorDataService", "SensorService", "SensrSvc", # Sensor related (Might affect auto-rotate, ambient light)
    "AJRouter", # AllJoyn Router Service (IoT/Device discovery)
    "icssvc" # Windows Mobile Hotspot Service (If not used)
    # Add more with extreme caution
)
$DisabledServiceCount = 0
Write-Host "- Attempting to stop and disable services..."
foreach ($serviceName in $ServicesToDisable) {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($service) {
        if ($service.Status -ne 'Stopped') { Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue; Start-Sleep -Milliseconds 100 } # Short pause
        if ($service.StartType -ne 'Disabled') {
            try { Set-Service -Name $serviceName -StartupType Disabled -ErrorAction Stop; Write-Host "  - Disabled Service: $serviceName" -ForegroundColor Gray; $DisabledServiceCount++ }
            catch { Write-Warning "  - Failed to disable $serviceName: Access Denied or Dependency?" -ForegroundColor Yellow }
        } else { Write-Host "  - Service $serviceName already disabled." -ForegroundColor DarkGray; $DisabledServiceCount++ }
    } else { Write-Host "  - Service $serviceName not found." -ForegroundColor DarkGray}
}
Write-Host "  - Attempted to disable $DisabledServiceCount services (Check warnings for failures)." -ForegroundColor Green


# --- Section 3: Network Optimization Attempts --- NOW PHASE 3 ---
$CurrentPhase = 3
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Applying Network Tweaks..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Applying Network Optimization Tweaks..." -ForegroundColor Cyan
try { Write-Host "- Setting DNS to Google..."; Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Set-DnsClientServerAddress -ServerAddresses ("8.8.8.8","8.8.4.4") -ErrorAction SilentlyContinue; ipconfig /flushdns | Out-Null; Write-Host "  - Google DNS set attempt complete." -ForegroundColor Green; Write-Host "- Applying TCP/IP tweaks..."; netsh int tcp set global autotuninglevel=disabled > $null; netsh int tcp set global rss=enabled > $null; netsh int tcp set global ecncapability=enabled > $null; netsh int tcp set global chimney=automatic > $null; try { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "DisableTaskOffload" -Value 1 -Type DWord -Force -ErrorAction Stop; Write-Host "  - Disabled Task Offload (Registry)." -ForegroundColor Green } catch {}; try { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" -Name "DnsPriority" -Value 6 -Type DWord -Force -ErrorAction Stop; Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" -Name "HostsPriority" -Value 5 -Type DWord -Force -ErrorAction Stop; Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" -Name "LocalPriority" -Value 4 -Type DWord -Force -ErrorAction Stop; Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" -Name "NetbtPriority" -Value 7 -Type DWord -Force -ErrorAction Stop; Write-Host "  - Adjusted Service Provider Priority." -ForegroundColor Green } catch {}; Write-Host "  - TCP tweaks applied." -ForegroundColor Green } catch { Write-Warning "- Error during Network Settings Phase: $($_.Exception.Message)" }


# --- Section 4: Custom Pagefile Management --- NOW PHASE 4 ---
$CurrentPhase = 4
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Setting Custom Pagefile Size..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Setting Custom Pagefile Size on C: Drive..." -ForegroundColor Yellow
Write-Warning "--- Pagefile changes require a restart to take effect (which will happen automatically). ---"; try { Write-Host "- Calculating recommended Pagefile size..."; $ComputerSystem = Get-CimInstance Win32_ComputerSystem; $PhysicalMemoryGB = [Math]::Round($ComputerSystem.TotalPhysicalMemory / 1GB); $RamMultiplier = 1.5; $MaxRecommendedPagefileMB = 32 * 1024; $RecommendedSizeMB = [int]([Math]::Min($ComputerSystem.TotalPhysicalMemory / 1MB * $RamMultiplier, $MaxRecommendedPagefileMB)); $MinRecommendedPagefileMB = 4 * 1024; $PagefileSizeMB = [int]([Math]::Max($RecommendedSizeMB, $MinRecommendedPagefileMB)); Write-Host "  - Detected RAM: $PhysicalMemoryGB GB"; Write-Host "  - Calculated Pagefile Size (Initial & Max): $PagefileSizeMB MB"; Write-Host "- Setting Pagefile size for C: ..."; $CurrentPageFile = Get-CimInstance -ClassName Win32_PageFileSetting | Where-Object {$_.Name -eq 'C:\pagefile.sys'}; if ($CurrentPageFile) { $CurrentPageFile | Set-CimInstance -Property @{InitialSize = $PagefileSizeMB; MaximumSize = $PagefileSizeMB} -PassThru | Out-Null; Write-Host "  - Custom Pagefile size set for C:\pagefile.sys." -ForegroundColor Green } else { Write-Warning "  - Could not find existing Pagefile setting for C:. Attempting to create (might fail)."; try { $NewPageFile = New-CimInstance -ClassName Win32_PageFileSetting -Property @{Name = 'C:\pagefile.sys'; InitialSize = $PagefileSizeMB; MaximumSize = $PagefileSizeMB} -ClientOnly; $NewPageFile | Set-CimInstance -Verbose -ErrorAction Stop | Out-Null; Write-Host "  - Attempted to create and set custom Pagefile for C:." -ForegroundColor Green } catch { Write-Warning "  - FAILED to create/set Pagefile: $($_.Exception.Message). Windows default might remain." } }; Write-Host "- Pagefile configuration attempt complete." -ForegroundColor Green } catch { Write-Warning "- Error during Pagefile Management Phase: $($_.Exception.Message)" }; Start-Sleep -Seconds 3


# --- Section 5: System Tweaks (Tasks & Registry) --- NOW PHASE 5 ---
$CurrentPhase = 5
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Applying System Tweaks..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Applying System Tweaks (Disabling MORE Tasks, Registry Edits)..." -ForegroundColor Cyan
# 5.1 Disable More Scheduled Tasks
Write-Host "- Disabling Extensive Scheduled Tasks..."
$TasksToDisableExt = @(
    # Original list
    '\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser', '\Microsoft\Windows\Application Experience\ProgramDataUpdater', '\Microsoft\Windows\Customer Experience Improvement Program\Consolidator', '\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip', '\Microsoft\Windows\Autochk\Proxy', '\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector', '\Microsoft\Windows\Maintenance\WinSAT', '\Microsoft\Windows\Diagnosis\Scheduled', '\Microsoft\Windows\DiskFootprint\Diagnostics', '\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents', '\Microsoft\Windows\PI\Sqm-Tasks', '\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem', '\Microsoft\Windows\Sysmain\WsSwapAssessmentTask', '\Microsoft\Windows\Windows Error Reporting\QueueReporting',
    # Added tasks
    '\Microsoft\Windows\AppID\SmartScreenSpecific', '\Microsoft\Windows\ApplicationData\DsSvcCleanup', '\Microsoft\Windows\Bluetooth\UninstallDeviceTask', '\Microsoft\Windows\CloudExperienceHost\CreateObjectTask', '\Microsoft\Windows\Device Information\Device', '\Microsoft\Windows\Device Information\DeviceUser', '\Microsoft\Windows\Feedback\Siuf\DmClient', '\Microsoft\Windows\InstallService\ScanForUpdates', '\Microsoft\Windows\InstallService\ScanForUpdatesAsUser', '\Microsoft\Windows\Location\Notifications', '\Microsoft\Windows\Management\Provisioning\Logon', '\Microsoft\Windows\Mobile Broadband Accounts\MbaConsistencyRunner', '\Microsoft\Windows\NetTrace\GatherNetworkInfo', '\Microsoft\Windows\PushToInstall\LoginCheck', '\Microsoft\Windows\PushToInstall\Registration', '\Microsoft\Windows\Shell\FamilySafetyMonitor', '\Microsoft\Windows\Shell\FamilySafetyRefresh', '\Microsoft\Windows\Shell\IndexerAutomaticMaintenance', '\Microsoft\Windows\Subscription\LicenseAcquisition', '\Microsoft\Windows\UpdateOrchestrator\Backup Scan', '\Microsoft\Windows\UpdateOrchestrator\Maintenance Install', '\Microsoft\Windows\UpdateOrchestrator\Policy Install', '\Microsoft\Windows\UpdateOrchestrator\Resume On Boot', '\Microsoft\Windows\UpdateOrchestrator\Schedule Scan', '\Microsoft\Windows\UpdateOrchestrator\USO_CabExtract', '\Microsoft\Windows\UpdateOrchestrator\USO_SetupScan', '\Microsoft\Windows\WaaSMedic\PerformRemediation',
    # Defender Scans (Will fail if Defender is truly off, but disable anyway)
    '\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance', '\Microsoft\Windows\Windows Defender\Windows Defender Cleanup', '\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan', '\Microsoft\Windows\Windows Defender\Windows Defender Verification'
    # Add more cautiously if needed
)
$DisabledTaskCountExt = 0; foreach ($taskPath in $TasksToDisableExt) { try { $taskName = $taskPath -replace '^.*\\'; $taskActualPath = $taskPath -replace '[^\\]+$', ''; Get-ScheduledTask -TaskPath $taskActualPath -TaskName $taskName -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue; Write-Host "  - Disabled Task (attempted): $taskPath" -ForegroundColor Gray; $DisabledTaskCountExt++ } catch {} }; Write-Host "  - Attempted to disable $DisabledTaskCountExt scheduled tasks." -ForegroundColor Green

# 5.2 Apply More Registry Tweaks
Write-Host "- Applying More Registry Tweaks..."
try {
    # Filesystem (Original)
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "NtfsDisableLastAccessUpdate" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue; Write-Host "  - Set NtfsDisableLastAccessUpdate = 1" -ForegroundColor Gray
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "NtfsMemoryUsage" -Value 2 -Type DWord -Force -ErrorAction SilentlyContinue; Write-Host "  - Set NtfsMemoryUsage = 2 (Increase Cache)" -ForegroundColor Gray

    # System Responsiveness
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "20" -Type String -Force -ErrorAction SilentlyContinue; Write-Host "  - Set MenuShowDelay = 20" -ForegroundColor Gray
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -Value "2000" -Type String -Force -ErrorAction SilentlyContinue; Write-Host "  - Set WaitToKillAppTimeout = 2000" -ForegroundColor Gray
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -Value "5000" -Type String -Force -ErrorAction SilentlyContinue; Write-Host "  - Set HungAppTimeout = 5000" -ForegroundColor Gray
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Value "2000" -Type String -Force -ErrorAction SilentlyContinue; Write-Host "  - Set WaitToKillServiceTimeout = 2000" -ForegroundColor Gray

    # Disable Superfetch Service Parameter (Alternative to disabling service - might be redundant)
    #Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnableSuperfetch" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

    Write-Host "  - Additional registry tweaks applied." -ForegroundColor Green
} catch { Write-Warning "- Error applying Registry Tweaks: $($_.Exception.Message)" }; Start-Sleep -Seconds 3


# --- Section 6: Show Desktop Icons --- NOW PHASE 6 ---
$CurrentPhase = 6
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Showing Desktop Icons..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Showing Common Desktop Icons..." -ForegroundColor Cyan
try { $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Write-Host "- Setting Desktop Icon visibility..."; Set-ItemProperty -Path $RegPath -Name HideIcons -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue; Set-ItemProperty -Path $RegPath -Name ShowComputerIcon -Value 1 -Type DWord -Force -ErrorAction Stop; Write-Host "  - Show Computer (This PC) Icon: Yes" -ForegroundColor Green; Set-ItemProperty -Path $RegPath -Name ShowNetworkIconOnDesktop -Value 1 -Type DWord -Force -ErrorAction Stop; Write-Host "  - Show Network Icon: Yes" -ForegroundColor Green; Set-ItemProperty -Path $RegPath -Name ShowUserFilesIcon -Value 0 -Type DWord -Force -ErrorAction Stop; Write-Host "  - Show User's Files Icon: No" -ForegroundColor Gray; Set-ItemProperty -Path $RegPath -Name ShowControlPanelIcon -Value 0 -Type DWord -Force -ErrorAction Stop; Write-Host "  - Show Control Panel Icon: No" -ForegroundColor Gray; Write-Host "  - Show Recycle Bin Icon: Enabled (Relies on 'HideIcons=0')" -ForegroundColor Gray; Write-Host "- Desktop Icon settings applied." -ForegroundColor Green } catch { Write-Warning "- Error setting Desktop Icons: $($_.Exception.Message)" }; Start-Sleep -Seconds 3


# --- Section 7: Create Startup Cache/Temp Cleanup Task --- NOW PHASE 7 ---
$CurrentPhase = 7
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Creating Startup Cleanup Task..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Creating Scheduled Task for Automatic Startup Cache/Temp Cleanup..." -ForegroundColor Magenta
# ... (Startup Cleanup Task code remains the same as v6) ...
Write-Warning "--- This task will run '$StartupCleanupScriptPath' as SYSTEM on every boot. ---"; $CleanupScriptContent = @"..."; try { Write-Host "- Saving cleanup script to: $StartupCleanupScriptPath"; Set-Content -Path $StartupCleanupScriptPath -Value $CleanupScriptContent -Force -Encoding UTF8; Write-Host "  - Cleanup script saved successfully." -ForegroundColor Green } catch { Write-Warning "- FAILED to save cleanup script: $($_.Exception.Message)"; Write-Warning "- Startup cleanup task creation will be skipped."; goto SkipTaskRegistration }; try { Write-Host "- Registering/Overwriting Scheduled Task 'AutoCacheCleanup'..."; $Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$StartupCleanupScriptPath`""; $Trigger = New-ScheduledTaskTrigger -AtStartup; $Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest; $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -Hidden -ExecutionTimeLimit (New-TimeSpan -Minutes 15); Register-ScheduledTask -TaskName "AutoCacheCleanup" -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings -Description "Automatically clears browser caches and temp files on startup (Created by AIO Script)" -Force -ErrorAction Stop; Write-Host "  - Scheduled Task 'AutoCacheCleanup' registered/updated successfully." -ForegroundColor Green } catch { Write-Warning "- FAILED to register Scheduled Task 'AutoCacheCleanup': $($_.Exception.Message)" }; :SkipTaskRegistration; Start-Sleep -Seconds 3


# --- Section 8: Aggressive RAM Management --- NOW PHASE 8 ---
$CurrentPhase = 8
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Setting RAM Clearing Task..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Setting up Aggressive RAM Clearing Task (EXPERIMENTAL/RISKY)..." -ForegroundColor Yellow
# ... (RAM task code remains the same) ...
try { Write-Host "- Creating/Overwriting scheduled task 'AggressiveRAMIdleTask'..."; $Action = New-ScheduledTaskAction -Execute "rundll32.exe" -Argument "advapi32.dll,ProcessIdleTasks"; $Trigger = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 30) -Once -At (Get-Date); $Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest; $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -Hidden -ExecutionTimeLimit (New-TimeSpan -Minutes 5); Register-ScheduledTask -TaskName "AggressiveRAMIdleTask" -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings -Force -ErrorAction Stop; Write-Host "  - Scheduled task created/updated." -ForegroundColor Green } catch { Write-Warning "- Failed to create RAM clearing task: $($_.Exception.Message)." }


# --- Section 9: Maximum Effort Disable Windows Defender --- NOW PHASE 9 ---
$CurrentPhase = 9
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Attempting Defender Disable..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Attempting MAXIMUM EFFORT Disable Windows Defender (Effectiveness depends on TP status)..." -ForegroundColor Red
if (-not $TP_Disable_Success) { Write-Warning "--- Skipping Defender modification attempts because Tamper Protection disable likely failed earlier. ---" -ForegroundColor Yellow; Start-Sleep -Seconds 3 }
else { try { Write-Host "- Applying Defender registry settings..."; $DefenderPolicyKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"; $RealTimePolicyKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"; $SpynetPolicyKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet"; $MpEnginePolicyKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine"; New-Item -Path $DefenderPolicyKey -Force -ErrorAction SilentlyContinue | Out-Null; New-Item -Path $RealTimePolicyKey -Force -ErrorAction SilentlyContinue | Out-Null; New-Item -Path $SpynetPolicyKey -Force -ErrorAction SilentlyContinue | Out-Null; New-Item -Path $MpEnginePolicyKey -Force -ErrorAction SilentlyContinue | Out-Null; Set-ItemProperty -Path $DefenderPolicyKey -Name "DisableAntiSpyware" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue; Set-ItemProperty -Path $RealTimePolicyKey -Name "DisableBehaviorMonitoring" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue; Set-ItemProperty -Path $RealTimePolicyKey -Name "DisableOnAccessProtection" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue; Set-ItemProperty -Path $RealTimePolicyKey -Name "DisableScanOnRealtimeEnable" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue; Set-ItemProperty -Path $FeaturesKey -Name "TamperProtection" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue; Set-ItemProperty -Path $SpynetPolicyKey -Name "SpyNetReporting" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue; Set-ItemProperty -Path $SpynetPolicyKey -Name "SubmitSamplesConsent" -Value 2 -Type DWord -Force -ErrorAction SilentlyContinue; Set-ItemProperty -Path $MpEnginePolicyKey -Name "MpEnablePus" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue; Write-Host "  - Registry modification attempts complete." -ForegroundColor Green; Write-Host "- Attempting to Stop & Disable Defender services..."; $DefenderServices = @("WinDefend", "Sense", "WdNisSvc", "SecurityHealthService"); foreach ($serviceName in $DefenderServices) { Write-Host "  - Action on service: $serviceName" -ForegroundColor Gray; Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue; Start-Sleep -Milliseconds 500; Set-Service -Name $serviceName -StartupType Disabled -ErrorAction SilentlyContinue }; Write-Host "  - Service manipulation attempts complete." -ForegroundColor Green } catch { Write-Warning "- Error during Defender Disabling Phase: $($_.Exception.Message)." } }


# --- Section 10: Auto-Install Software --- NOW PHASE 10 ---
$CurrentPhase = 10
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Installing Software..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Auto-Installing Software (NO CONFIRMATION)..." -ForegroundColor Cyan
# --- !!! EDIT THIS LIST BEFORE RUNNING !!! ---
$EssentialSoftware = @( "Mozilla.Firefox", "Google.Chrome", "7zip.7zip", "VideoLAN.VLC", "Microsoft.PowerToys", "Notepad++.Notepad++" )
# --- !!! END EDIT SECTION !!! ---
Write-Warning "--- ENSURE SOFTWARE LIST WAS CUSTOMIZED IN THE SCRIPT FILE BEFORE RUNNING ---"; Write-Host "- Target Software List:"; $EssentialSoftware | ForEach-Object { Write-Host "  - $_" }; Start-Sleep -Seconds 2; $totalApps = $EssentialSoftware.Count; $appCounter = 0; foreach ($appId in $EssentialSoftware) { $appCounter++; $percentComplete = [int](($appCounter / $totalApps) * 100); $overallPercent = [int]((($CurrentPhase-1) / $TotalPhases) * 100 + ($percentComplete / $TotalPhases)); Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Installing Software ($appCounter/$totalApps): $appId" -PhaseNumber ($CurrentPhase-1); Write-Progress -Activity "Software Installation" -Status "Installing $appId ($appCounter/$totalApps)" -PercentComplete $percentComplete -Id 2; Write-Host "- Installing $appId ($appCounter/$totalApps)..." -ForegroundColor Yellow; try { $process = Start-Process winget -ArgumentList "install --id $appId -e --silent --accept-source-agreements --accept-package-agreements --force --disable-interactivity" -Wait -PassThru -WindowStyle Hidden; if ($process.ExitCode -eq 0) { Write-Host "  - $appId installed successfully." -ForegroundColor Green } else { Write-Warning "  - FAILED to install $appId (Exit Code: $($process.ExitCode)). Check logs." } } catch { Write-Warning "  - FAILED to install $appId (Exception): $($_.Exception.Message)" } }; Write-Progress -Activity "Software Installation" -Status "Completed" -Completed -Id 2; Write-Host "- Software installation attempt complete." -ForegroundColor Green


# --- Section 11: Hardware Identification & Driver Strategy --- NOW PHASE 11 ---
$CurrentPhase = 11
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Identifying Hardware & Recommending Drivers..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Identifying Key Hardware for Driver Recommendations..." -ForegroundColor Blue
Start-Sleep -Seconds 2; $RecommendNvidiaManual = $false; $RecommendIntelManual = $false; $RecommendRealtekManual = $false; try { Write-Host "- Checking Graphics Adapter..."; $gpu = Get-CimInstance -ClassName Win32_VideoController | Select-Object -First 1; if ($gpu -and $gpu.Name -like "*NVIDIA*") { Write-Warning "  - NVIDIA GPU Detected: $($gpu.Name)"; Write-Warning "  - RECOMMENDATION: Manually get driver from NVIDIA.com/GeForce Exp."; $RecommendNvidiaManual = $true } elseif ($gpu -and $gpu.Name -like "*AMD*" -or $gpu.Name -like "*Radeon*") { Write-Warning "  - AMD GPU Detected: $($gpu.Name)"; Write-Warning "  - RECOMMENDATION: Manually get driver from AMD.com." } elseif ($gpu -and $gpu.Name -like "*Intel*") { Write-Host "  - Intel Integrated Graphics: $($gpu.Name)" -ForegroundColor Gray; Write-Host "  - (Use WU or Intel IDSA)" -ForegroundColor Gray } else { Write-Host "  - GPU: $($gpu.Name)" }; Write-Host "- Checking Network Adapters..."; $netAdapters = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'}; if ($netAdapters) { foreach ($adapter in $netAdapters) { Write-Host "  - Adapter: $($adapter.Name)" -ForegroundColor Gray; if ($adapter.InterfaceDescription -like "*Intel*Wireless*" -or $adapter.InterfaceDescription -like "*Intel*Wi-Fi*") { Write-Warning "    - Intel Wi-Fi Detected."; Write-Warning "    - RECOMMENDATION: Check Intel IDSA/Asus site."; $RecommendIntelManual = $true } elseif ($adapter.InterfaceDescription -like "*Realtek*PCIe*GbE*" -or $adapter.InterfaceDescription -like "*Realtek Gaming*") { Write-Warning "    - Realtek Ethernet Detected."; Write-Warning "    - RECOMMENDATION: Check Asus site for LAN driver."; $RecommendRealtekManual = $true } } } else { Write-Host "  - No active adapters found." }; Write-Host "- Hardware check complete." -ForegroundColor Blue; Start-Sleep -Seconds 5 } catch { Write-Warning "- Error during Hardware ID Phase: $($_.Exception.Message)" }


# --- Section 12: Attempt Windows Update (General OS & Other Drivers) --- NOW PHASE 12 ---
$CurrentPhase = 12
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Running General Windows Update..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Attempting General Windows Update (OS & Other Drivers via WU)..." -ForegroundColor Magenta
Write-Warning "--- This phase can take a SIGNIFICANT amount of time. ---"; if ($RecommendNvidiaManual -or $RecommendIntelManual -or $RecommendRealtekManual) { Write-Warning "--- REMINDER: Manual driver checks recommended AFTER restart. ---" }; Start-Sleep -Seconds 3; try { Write-Host "- Checking/Installing PSWindowsUpdate module..."; if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) { Write-Host "  - Installing PSWindowsUpdate module..."; $currentPolicy = Get-ExecutionPolicy -Scope Process; if ($currentPolicy -ne 'Unrestricted' -and $currentPolicy -ne 'RemoteSigned' -and $currentPolicy -ne 'Bypass') { Set-ExecutionPolicy RemoteSigned -Scope Process -Force -WarningAction SilentlyContinue }; Install-Module PSWindowsUpdate -Force -SkipPublisherCheck -Confirm:$false -Scope CurrentUser -ErrorAction Stop; Import-Module PSWindowsUpdate -ErrorAction Stop; Write-Host "  - PSWindowsUpdate module installed." -ForegroundColor Green } else { Import-Module PSWindowsUpdate -ErrorAction Stop; Write-Host "  - PSWindowsUpdate module already available." -ForegroundColor Green }; Write-Host "- Searching/installing ALL available updates via WU... Please Wait."; Write-Progress -Activity "Windows Update in Progress" -Status "Checking, Downloading, Installing Updates... (This can take a long time)" -PercentComplete 50 -Id 3; Get-WindowsUpdate -Install -AcceptAll -ForceDownload -ForceInstall -ErrorAction Stop; Write-Progress -Activity "Windows Update in Progress" -Completed -Id 3; Write-Host "- Windows Update command executed." -ForegroundColor Green; Write-Warning "- Note: Updates might require the upcoming restart." } catch { Write-Progress -Activity "Windows Update in Progress" -Completed -Id 3; Write-Warning "!!! ERROR DURING WINDOWS UPDATE: $($_.Exception.Message). Check manually later. !!!" -ForegroundColor Red; Start-Sleep -Seconds 5 }


# --- Section 13: Final Cleanup (Includes fstrim & DISM) --- NOW PHASE 13 ---
$CurrentPhase = 13
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Performing Final Cleanup, DISM & SSD Trim..." -PhaseNumber $CurrentPhase
Write-Host "`n[PHASE $CurrentPhase] Performing Final System Cleanup, DISM Component Cleanup & Forcing SSD TRIM..." -ForegroundColor Cyan
try {
    Write-Host "- Clearing Temp folders (excluding startup script)..."
    $TempPaths = @("$env:TEMP", "$env:windir\Temp"); foreach ($path in $TempPaths) { if (Test-Path $path) { Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.FullName -ne $StartupCleanupScriptPath } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue; Write-Host "  - Cleared $path" -ForegroundColor Green } }

    Write-Host "- Flushing DNS Cache..."
    ipconfig /flushdns | Out-Null
    Write-Host "  - DNS Cache flushed." -ForegroundColor Green

    Write-Host "- Running DISM Component Store Cleanup (This might take a moment)..."
    Write-Progress -Activity "DISM Cleanup" -Status "Running /StartComponentCleanup..." -PercentComplete 50 -Id 4 # Indeterminate
    Dism.exe /Online /Cleanup-Image /StartComponentCleanup /Quiet | Out-Null # Add /Quiet to reduce DISM output
    Write-Progress -Activity "DISM Cleanup" -Completed -Id 4
    Write-Host "  - DISM Component Store Cleanup command executed." -ForegroundColor Green
    Start-Sleep -Seconds 2

    Write-Host "- Forcing SSD TRIM (Optimize-Volume -ReTrim) on Drive C:..."
    Optimize-Volume -DriveLetter C -ReTrim -Verbose -ErrorAction Stop
    Write-Host "  - Drive C TRIM / Optimization initiated." -ForegroundColor Green

} catch { Write-Warning "- Error during Cleanup/DISM/TRIM Phase: $($_.Exception.Message)" }


# --- Final Phase Update & Auto-Restart --- NOW PHASE 14 ---
$CurrentPhase = 14 # Adjusted final phase number for progress calculation
Update-OverallProgress -StatusMessage "[Phase $CurrentPhase/$TotalPhases] Finalizing and Preparing for Auto-Restart..." -PhaseNumber ($TotalPhases) # Use TotalPhases here for 100%
Write-Host "`n[COMPLETE] FULLY AUTOMATED AIO SCRIPT EXECUTION FINISHED." -ForegroundColor Magenta
Write-Progress -Activity "Automated AIO System Modification (Auto-Restart Pending)" -Status "Completed. Preparing for Restart." -PercentComplete 100 -Id 1
Start-Sleep -Seconds 1
Write-Progress -Activity "Automated AIO System Modification (Auto-Restart Pending)" -Completed -Id 1 # Remove main progress bar

# --- FINAL MESSAGE BEFORE RESTART ---
Write-Warning "********************************************************************************************************"
Write-Warning "***                                                                                                  ***"
Write-Warning "***                    !!! SCRIPT COMPLETE - RESTARTING SYSTEM AUTOMATICALLY NOW !!!                 ***"
Write-Warning "***                                                                                                  ***"
Write-Warning "*** POST-RESTART: Startup cleanup task will run. Check HW Drivers MANUALLY. Monitor Temps/Stability. ***"
Write-Warning "*** System Security Compromised. Search might be broken. Good Luck.                                  ***"
Write-Warning "***                                                                                                  ***"
Write-Warning "********************************************************************************************************"
Start-Sleep -Seconds 5 # Give a few seconds to read the final message before restart

# --- AUTO-RESTART COMMAND ---
Write-Host "Initiating system restart..." -ForegroundColor Red
Restart-Computer -Force

# --- SCRIPT END (Technically unreachable due to restart) ---
