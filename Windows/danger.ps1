function Write-SectionHeader { param($Title) Write-Host "`n==================================================" -ForegroundColor Cyan; Write-Host " $Title" -ForegroundColor Cyan; Write-Host "==================================================" }
function Write-SubSection { param($Title) Write-Host "`n--- $Title ---" -ForegroundColor Yellow }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Gray }
function Write-Success { param($Message) Write-Host "[SUCCESS] $Message" -ForegroundColor Green }
function Write-WarningMsg { param($Message) Write-Host "[WARNING] $Message" -ForegroundColor Yellow }
function Write-ErrorMsg { param($Message) Write-Host "[ERROR] $Message" -ForegroundColor Red }
function Write-Action { param($Message) Write-Host "[ACTION] $Message" -ForegroundColor White }
function Write-RevertTip { param($Message) Write-Host "[REVERT TIP] $Message" -ForegroundColor Magenta }
function Write-BackupInfo { param($Message) Write-Host "[BACKUP] $Message" -ForegroundColor Blue }
function Write-CriticalWarning { param($Message) Write-Host "[CRITICAL WARNING] $Message" -ForegroundColor Red -BackgroundColor White }

$scriptBackupFolder = Join-Path -Path $PSScriptRoot -ChildPath "ScriptBackups"
if (-not (Test-Path $scriptBackupFolder)) {
    Write-Info "Creating backup directory: $scriptBackupFolder"
    New-Item -ItemType Directory -Path $scriptBackupFolder -Force | Out-Null
}
$timeStamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFilePath = Join-Path -Path $scriptBackupFolder -ChildPath "OptimizationLog_$($timeStamp).log"

function Confirm-Action {
    param(
        [Parameter(Mandatory=$true)]
        [string]$PromptMessage,
        [string]$Default = 'N'
    )
    $validResponses = @('y', 'n')
    $prompt = "$PromptMessage (Y/N, Default is '$($Default.ToUpper())')"
    while ($true) {
        $response = Read-Host $prompt
        if ([string]::IsNullOrWhiteSpace($response)) { $response = $Default }
        if ($validResponses -contains $response.ToLower()) {
            return ($response.ToLower() -eq 'y')
        }
        Write-WarningMsg "Please enter 'Y' or 'N'."
    }
}

function Backup-RegistryKey {
    param(
        [Parameter(Mandatory=$true)][string]$RegistryPath
    )
    $regPath = $RegistryPath -replace 'HKLM:\\', 'HKEY_LOCAL_MACHINE\' -replace 'HKCU:\\', 'HKEY_CURRENT_USER\' -replace 'HKCR:\\', 'HKEY_CLASSES_ROOT\' -replace 'HKU:\\', 'HKEY_USERS\'
    $keyName = ($RegistryPath -split '\\')[-1]
    if ([string]::IsNullOrWhiteSpace($keyName) -and $RegistryPath.Contains('\')) {
        $keyName = ($RegistryPath.TrimEnd('\') -split '\\')[-1] + "_Root"
    } elseif (-not $RegistryPath.Contains('\')) {
         $keyName = $RegistryPath.Replace(':','_')
    }
    $backupFileName = Join-Path -Path $scriptBackupFolder -ChildPath "RegBackup_$($keyName)_$($timeStamp).reg"

    if (Test-Path $RegistryPath) {
        Write-BackupInfo "Backing up Registry key '$RegistryPath' to '$backupFileName'"
        try {
             if (-not (Test-Path (Split-Path $backupFileName -Parent))) { New-Item -ItemType Directory -Path (Split-Path $backupFileName -Parent) -Force | Out-Null }
             $regExePath = Join-Path $env:SystemRoot "System32\reg.exe"
             Start-Process $regExePath -ArgumentList "EXPORT `"$regPath`" `"$backupFileName`" /y" -Wait -NoNewWindow -ErrorAction Stop
             Write-BackupInfo "Registry backup successful."
        } catch {
            Write-WarningMsg "Failed to back up registry key '$RegistryPath'. Error: $($_.Exception.Message)"
        }
    } else {
        Write-BackupInfo "Registry key '$RegistryPath' does not exist. No backup needed before potential creation."
    }
}

function Set-RegistryValue {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)]$Value,
        [Parameter(Mandatory=$true)][ValidateSet('String', 'ExpandString', 'Binary', 'DWord', 'MultiString', 'QWord')][string]$Type,
        [switch]$CheckIfExists,
        [switch]$ForceCreatePath
    )
    $fullRegPath = $Path
    $valueExists = $false
    $currentValue = $null

    try {
        if (Test-Path $fullRegPath) {
           $currentValueProp = Get-ItemProperty -Path $fullRegPath -Name $Name -ErrorAction SilentlyContinue
           if ($currentValueProp -ne $null -and $currentValueProp.PSObject.Properties.Name -contains $Name) {
               $currentValue = $currentValueProp.$Name
               $valueExists = $true
           }
        }

        if ($CheckIfExists -and $valueExists -and $currentValue -eq $Value) {
            Write-Info "Registry value '$Name' at '$fullRegPath' already set to the desired value ($Value). Skipping."
            return $true
        }

        Backup-RegistryKey -RegistryPath $fullRegPath

        if ($ForceCreatePath -and -not (Test-Path $fullRegPath)) {
            Write-Info "Creating Registry Path: $fullRegPath"
            New-Item -Path $fullRegPath -Force -ErrorAction Stop | Out-Null
        }

        Write-Info "Setting Registry '$Name' at '$fullRegPath' to '$Value' (Type: $Type)"
        Set-ItemProperty -Path $fullRegPath -Name $Name -Value $Value -Type $Type -Force -ErrorAction Stop
        Write-Success "Successfully set Registry '$Name' at '$fullRegPath'."
        Write-RevertTip "To revert '$Name', check the backup '.reg' file in '$scriptBackupFolder' or apply previous value manually if known."
        return $true
    } catch {
        Write-ErrorMsg "Failed to set Registry '$Name' at '$fullRegPath': $($_.Exception.Message)"
        Write-ErrorMsg "Registry Path: $fullRegPath"
        Write-ErrorMsg "Name: $Name, Value: $Value, Type: $Type"
        return $false
    }
}

$originalServiceStates = @{}
function Backup-ServiceState {
     param(
        [Parameter(Mandatory=$true)][string]$ServiceName
    )
    if ($originalServiceStates.ContainsKey($ServiceName)) { return }

    try {
        $service = Get-Service -Name $ServiceName -ErrorAction Stop
        $originalServiceStates[$ServiceName] = @{
            Name = $service.Name
            OriginalStartupType = $service.StartType
            OriginalStatus = $service.Status
        }
        Write-BackupInfo "Recorded original state for service '$ServiceName' (Startup: $($service.StartType))"
    } catch {
        if ($_.Exception.InnerException.GetType().Name -ne 'ServiceCommandException' -or $_.Exception.Message -notmatch 'Cannot find any service') {
             Write-WarningMsg "Could not get original state for service '$ServiceName': $($_.Exception.Message)"
        }
    }
}

function Save-ServiceBackups {
    if ($originalServiceStates.Count -gt 0) {
        $backupFilePath = Join-Path -Path $scriptBackupFolder -ChildPath "ServiceBackup_$($timeStamp).csv"
        Write-BackupInfo "Saving original service states to '$backupFilePath'"
        try {
             $originalServiceStates.Values | Export-Csv -Path $backupFilePath -NoTypeInformation -Encoding UTF8 -Force
        } catch {
            Write-ErrorMsg "Failed to save service backup CSV: $($_.Exception.Message)"
        }
    }
}

function Manage-Service {
    param(
        [Parameter(Mandatory=$true)][string]$ServiceName,
        [Parameter(Mandatory=$true)][ValidateSet('Disabled', 'Manual', 'Automatic', 'AutomaticDelayedStart')][string]$TargetStartupType,
        [switch]$StopServiceIfRunning
    )
    Write-Info "Managing Service: $ServiceName (Target State: $TargetStartupType)"
    $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    if (!$service) {
        Write-Info "Service '$ServiceName' not found. Skipping."
        return $false
    }

    Backup-ServiceState -ServiceName $ServiceName
    $originalStartupType = if($originalServiceStates.ContainsKey($ServiceName)) {$originalServiceStates[$ServiceName].OriginalStartupType} else {$service.StartType}
    $currentStartupType = $service.StartType
    $currentStatus = $service.Status

    if ($StopServiceIfRunning -and $currentStatus -ne 'Stopped') {
        Write-Info "Attempting to stop Service '$ServiceName'..."
        try {
            Stop-Service -Name $ServiceName -Force -ErrorAction Stop
            Start-Sleep -Seconds 2
            $service.Refresh()
            if ($service.Status -ne 'Stopped') {
                Write-WarningMsg "Service '$ServiceName' did not stop cleanly."
            } else {
                Write-Success "Successfully stopped Service '$ServiceName'."
            }
        } catch {
             Write-WarningMsg "Could not stop Service '$ServiceName': $($_.Exception.Message)"
        }
    }

    $setServiceStartupType = $TargetStartupType
     if($TargetStartupType -eq 'AutomaticDelayedStart'){
         Write-WarningMsg "Setting 'AutomaticDelayedStart' via Set-Service is complex. Setting to 'Automatic' instead for service '$ServiceName'."
         $setServiceStartupType = 'Automatic'
    }

    if ($currentStartupType -ne $TargetStartupType) {
        Write-Info "Changing Startup Type of '$ServiceName' from '$currentStartupType' to '$TargetStartupType'..."
        try {
            Set-Service -Name $ServiceName -StartupType $setServiceStartupType -ErrorAction Stop
            Write-Success "Successfully set Startup Type of '$ServiceName' to '$setServiceStartupType'."
            Write-RevertTip "To revert '$ServiceName': Set-Service -Name '$ServiceName' -StartupType '$originalStartupType'. Check backup CSV for original state."
            return $true
        } catch {
            Write-ErrorMsg "Failed to set Startup Type for '$ServiceName': $($_.Exception.Message)"
            return $false
        }
    } else {
        Write-Info "Startup Type of '$ServiceName' is already '$TargetStartupType'. No change needed."
        return $true
    }
}

try {
    Start-Transcript -Path $logFilePath -Append -Force
} catch {
    Write-WarningMsg "Could not start transcript logging to '$logFilePath'. Check permissions. Script will continue without file logging."
}

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-CriticalWarning "This script MUST be run as Administrator!"
    Write-WarningMsg "Please close this window, right-click the script file, and select 'Run as administrator'."
    Read-Host "Press Enter to exit..."
    Stop-Transcript
    Exit
}


Write-Host "==============================================================" -ForegroundColor Yellow
Write-Host "   EXTREME Performance Optimization Script (v2.3 - HIGH RISK)" -ForegroundColor Yellow
Write-Host "          Focus: Max Speed (Security Compromised)           " -ForegroundColor Yellow
Write-Host "==============================================================" -ForegroundColor Yellow
Write-Host "By: AI Assistant (Implementing High-Risk Requests)"
Write-Host "Log file for this session: $logFilePath"
Write-Host ""
Write-CriticalWarning "!!!!!!!!!!!!!!!!!!!!!!!!!!!! DISCLAIMER !!!!!!!!!!!!!!!!!!!!!!!!!!!!"
Write-CriticalWarning "This script includes options to PERMANENTLY DISABLE Windows Defender"
Write-CriticalWarning "and Windows Update. This creates SEVERE SECURITY RISKS, leaving"
Write-CriticalWarning "your system EXTREMELY VULNERABLE to malware, ransomware, and attacks."
Write-CriticalWarning "USE AT YOUR OWN ABSOLUTE RISK. NO LIABILITY IS ASSUMED."
Write-CriticalWarning "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
Write-WarningMsg "A System Restore Point and FULL BACKUP are essential before proceeding."
Write-Host ""

Write-Info "Administrator privileges confirmed."
Start-Sleep -Seconds 1

Write-SectionHeader "Mandatory Step: System Restore Point"
$restorePointCreated = $false
Write-Info "Attempting to create an automatic System Restore Point..."
try {
    $restorePoint = Checkpoint-Computer -Description "Before EXTREME Optimization Script ($timeStamp)" -ErrorAction Stop
    Write-Success "Successfully created System Restore Point: $($restorePoint.Description)"
    $restorePointCreated = $true
} catch {
    Write-WarningMsg "Automatic System Restore Point creation failed: $($_.Exception.Message)"
    Write-WarningMsg "This might be disabled by policy or the service might not be running."
    if (Confirm-Action "Do you want to open System Properties MANUALLY to create a Restore Point?" -Default 'Y') {
        Write-Info "Opening System Properties... Go to 'System Protection' tab and click 'Create...'"
        try {
            Start-Process SystemPropertiesProtection.exe
            Read-Host ">>> IMPORTANT: After creating the Restore Point manually, press Enter here to continue <<<"
            $restorePointCreated = $true
        } catch {
            Write-ErrorMsg "Could not open SystemPropertiesProtection.exe. Please open it manually via Control Panel."
            Read-Host "Press Enter to continue OR Ctrl+C to abort..."
        }
    }
}

if (-not $restorePointCreated) {
    Write-CriticalWarning "You chose not to create or could not create a Restore Point."
    if (-not (Confirm-Action "ARE YOU ABSOLUTELY SURE you want to proceed without a Restore Point? (EXTREMELY DANGEROUS)" -Default 'N')) {
        Write-Info "Script execution aborted by user request. No changes were made."
        Stop-Transcript
        Exit
    }
    Write-CriticalWarning "Proceeding without a Restore Point. MAXIMUM CAUTION ADVISED!"
} else {
     Write-Info "Restore Point confirmed. Proceeding with caution."
}
Start-Sleep -Seconds 1

Write-SectionHeader "Select Optimization Sections"
Write-Host "Choose which areas you want to optimize."
$options = [ordered]@{
    '0' = 'Force Windows Update (Run Before Other Sections)'
    '1' = 'Power Plan & Resource Management (Recommended)'
    '2' = 'Disk Optimization & System Health (Recommended)'
    '3' = 'Network Optimization (Advanced - Use Cautiously)'
    '4' = 'Service Tuning & Disable Defender (EXTREME RISK)'
    '5' = 'Visual Effects & UI Tweaks (Performance vs Appearance)'
    '6' = 'Telemetry & Privacy Adjustments (Minor Impact)'
    '7' = 'Disable Windows Update PERMANENTLY (EXTREME RISK - RUN LAST)'
    'A' = 'Apply ALL Sections (Includes HIGH RISK Options)'
    'S' = 'Apply SAFER Sections Only (1, 2, 5, 6)'
    'Q' = 'Quit without applying changes'
}
$options.Keys | ForEach-Object { Write-Host " [$($_.ToUpper())] $($options[$_])" }

$selectedSections = @{}
while($true) {
    $choice = Read-Host "`nEnter your choice(s) (e.g., 0,1,2,5,7 or A, S, Q)"
    $choice = $choice.ToUpper() -replace '\s',''

    if ($choice -eq 'Q') { Write-Info "Exiting as requested."; Stop-Transcript; Exit }
    if ($choice -eq 'A') {
        $selectedSections = @{ '0'=$true; '1'=$true; '2'=$true; '3'=$true; '4'=$true; '5'=$true; '6'=$true; '7'=$true }
        Write-Info "Selected: ALL Sections (Including EXTREME RISK options)"
        break
    }
     if ($choice -eq 'S') {
        $selectedSections = @{ '1'=$true; '2'=$true; '5'=$true; '6'=$true }
        Write-Info "Selected: SAFER Sections Only (1, 2, 5, 6)"
        break
    }

    $validChoice = $true
    $tempSelection = @{}
    if ($choice -match '^[0-7,]+$') {
        foreach ($c in $choice.Split(',')) {
            if ($options.ContainsKey($c)) {
                $tempSelection[$c] = $true
            } else {
                Write-WarningMsg "Invalid selection '$c'."
                $validChoice = $false
                break
            }
        }
    } else {
         Write-WarningMsg "Invalid input format. Use numbers (0-7) separated by commas, or A, S, Q."
         $validChoice = $false
    }

    if ($validChoice -and $tempSelection.Count -gt 0) {
        $selectedSections = $tempSelection
        $selectedNames = ($selectedSections.Keys | Sort-Object | ForEach-Object {$options[$_]}) -join ', '
        Write-Info "Selected Sections: $selectedNames"
        if (($selectedSections.ContainsKey('4') -or $selectedSections.ContainsKey('7')) -and $choice -ne 'A') {
             Write-CriticalWarning "You have selected HIGH RISK sections (4 or 7). Ensure you understand the consequences."
        }
        if ($selectedSections.ContainsKey('0') -and $selectedSections.ContainsKey('7')) {
            Write-WarningMsg "You selected to Force Update (0) and Disable Update Permanently (7)."
            Write-WarningMsg "Section 0 will run first, then Section 7 will attempt to disable future updates."
        }
        break
    } elseif ($validChoice -and $tempSelection.Count -eq 0) {
         Write-WarningMsg "No valid sections selected from input '$choice'."
    }
}

if ($selectedSections.Count -eq 0) {
    Write-Info "No optimization sections selected. Exiting."
    Stop-Transcript
    Exit
}

$executionOrder = $selectedSections.Keys | Sort-Object | Where-Object { $_ -ne '0' -and $_ -ne '7'}
if ($selectedSections.ContainsKey('0')) { $executionOrder = @('0') + $executionOrder }
if ($selectedSections.ContainsKey('7')) { $executionOrder = $executionOrder + @('7') }

Write-Host ""
Write-CriticalWarning "FINAL CONFIRMATION: You are about to apply potentially irreversible and high-risk changes."
if (-not (Confirm-Action "Proceed with optimizations for selected sections? [Selected: $($executionOrder -join ',')]" -Default 'N')) {
     Write-Info "Script execution cancelled by user request before applying changes."
     Stop-Transcript
     Exit
}
Write-Success "Starting optimization process..."
Start-Sleep -Seconds 1

foreach ($sectionKey in $executionOrder) {

    if ($sectionKey -eq '0') {
        Write-SectionHeader "Section 0: Force Windows Update"
        Write-WarningMsg "This requires the 'PSWindowsUpdate' module and an internet connection."
        Write-WarningMsg "The update process can take a VERY long time and may require multiple restarts."

        if (Confirm-Action "Attempt to install/update necessary module and run Windows Update now?" -Default 'Y') {
            Write-Info "Checking for PSWindowsUpdate module..."
            try {
                Import-Module PSWindowsUpdate -ErrorAction SilentlyContinue
            } catch {} # Suppress initial import error if not found

            $module = Get-Module -Name PSWindowsUpdate -ListAvailable
            if (-not $module) {
                Write-Info "PSWindowsUpdate module not found. Attempting to install from PSGallery..."
                try {
                    # Ensure PowerShellGet is available and updated if possible
                    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction SilentlyContinue
                    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction SilentlyContinue
                    Install-Module PSWindowsUpdate -Confirm:$false -Force -SkipPublisherCheck -ErrorAction Stop
                    Write-Success "PSWindowsUpdate module installed successfully."
                    Import-Module PSWindowsUpdate -Force
                } catch {
                    Write-ErrorMsg "Failed to install PSWindowsUpdate module: $($_.Exception.Message)"
                    Write-WarningMsg "Cannot proceed with forced update. Skipping Section 0."
                    Write-WarningMsg "You may need to run 'Install-Module PSWindowsUpdate' manually in an Admin PowerShell."
                    continue
                }
            } else {
                Write-Info "PSWindowsUpdate module found."
                 Import-Module PSWindowsUpdate -Force
            }

            Write-Action "Starting Windows Update check and installation..."
            Write-WarningMsg "This may take a long time. Please be patient. Requires Internet."
            Write-WarningMsg "Accept any prompts for installation or restarts that appear."
            try {
                 Get-WUInstall -MicrosoftUpdate -AcceptAll -IgnoreReboot
                 Write-Success "Windows Update process initiated. Monitor Windows Update for progress and necessary restarts."
                 Write-WarningMsg "You might need to manually restart if prompted by Windows Update."
                 Read-Host ">>> Press Enter after Windows Update completes (including any required restarts) to continue the script <<<"
            } catch {
                 Write-ErrorMsg "An error occurred during Windows Update: $($_.Exception.Message)"
                 Write-WarningMsg "Windows Update may not have completed successfully."
            }
        } else {
            Write-Info "Skipped Section 0: Force Windows Update."
        }
    }

    if ($sectionKey -eq '1') {
        Write-SectionHeader "Section 1: Power Plan & Resource Management"

        Write-SubSection "Optimize Power Plan"
        Write-Info "Setting High Performance or Ultimate Performance power plan."
        $HighPerfGuid = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
        $UltimatePerfGuid = "e9a42b02-d5df-448d-aa00-03f14749eb61"
        $CurrentPlanGuid = try { (powercfg /GETACTIVESCHEME).Split(' ')[3] } catch { $null }

        $UltimateExists = $false
        try {
            $UltimateExists = (powercfg /LIST | Select-String -Pattern $UltimatePerfGuid -Quiet)
            if (-not $UltimateExists) {
                Write-Info "Attempting to uncover the Ultimate Performance plan..."
                powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
                Start-Sleep -Seconds 1
                $UltimateExists = (powercfg /LIST | Select-String -Pattern $UltimatePerfGuid -Quiet)
            }
        } catch { Write-WarningMsg "Could not check for or enable Ultimate Performance plan." }

        $TargetPlanGuid = if ($UltimateExists) { $UltimatePerfGuid } else { $HighPerfGuid }
        $TargetPlanName = if ($UltimateExists) { "Ultimate Performance" } else { "High Performance" }

        if ($CurrentPlanGuid -ne $TargetPlanGuid) {
            if (Confirm-Action "Set Power Plan to '$TargetPlanName'?" -Default 'Y') {
                Write-Info "Setting active power scheme to $TargetPlanName ($TargetPlanGuid)"
                try {
                    powercfg /SETACTIVE $TargetPlanGuid
                    Write-Success "Successfully activated '$TargetPlanName' power plan."
                    Write-RevertTip "To revert, use 'Choose a power plan' in Control Panel or `powercfg /setactive <GUID>` with the original GUID if known."
                } catch { Write-ErrorMsg "Failed to set Power Plan: $($_.Exception.Message)"}
            } else { Write-Info "Skipped setting Power Plan." }
        } else {
            Write-Info "Power Plan is already set to '$TargetPlanName'."
        }
        Write-Info "Current active power plan: $(try {(powercfg /GETACTIVESCHEME)} catch {'(Could not read)'})"

        Write-SubSection "Enable Game Mode"
        Write-Info "Ensuring Game Mode features are enabled via registry."
        $gameModePath = "HKCU:\Software\Microsoft\GameBar"
        if (Confirm-Action "Ensure Game Mode is enabled (AllowAutoGameMode=1)?" -Default 'Y') {
            Set-RegistryValue -Path $gameModePath -Name "AllowAutoGameMode" -Value 1 -Type DWord -ForceCreatePath -CheckIfExists
            Set-RegistryValue -Path $gameModePath -Name "GamePanelStartupTipIndex" -Value 0 -Type DWord -ForceCreatePath -CheckIfExists
            Write-RevertTip "Game Mode can be toggled in Settings > Gaming > Game Mode. Registry revert: AllowAutoGameMode=0."
        } else { Write-Info "Skipped Game Mode registry check."}

        Write-SubSection "Hardware-Accelerated GPU Scheduling (HAGS)"
        Write-Info "HAGS can potentially reduce latency (Requires supported Hardware/Drivers/OS & Restart)."
        $gpuSchedulingPath = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
        $currentHwSchMode = (Get-ItemProperty -Path $gpuSchedulingPath -Name "HwSchMode" -ErrorAction SilentlyContinue).HwSchMode

        if ($currentHwSchMode -ne 2) {
            if (Confirm-Action "Enable Hardware-Accelerated GPU Scheduling? (Requires Restart)" -Default 'Y') {
                if (Set-RegistryValue -Path $gpuSchedulingPath -Name "HwSchMode" -Value 2 -Type DWord) {
                    Write-Success "HAGS enabled in registry. REQUIRES RESTART."
                    Write-RevertTip "To disable HAGS: Set HwSchMode back to 1 in the registry and RESTART."
                }
            } else { Write-Info "Skipped enabling Hardware-Accelerated GPU Scheduling." }
        } else {
            Write-Info "Hardware-Accelerated GPU Scheduling is already enabled in the registry (Requires restart if recently changed)."
        }

        Write-SubSection "System Responsiveness Profile for Games"
        Write-Info "Optimizing Multimedia System Profile for games (CPU/GPU/Network Priority)."
        $gamesProfilePath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
        if (Confirm-Action "Apply optimized settings to the 'Games' System Profile Task?" -Default 'Y') {
            Set-RegistryValue -Path $gamesProfilePath -Name "GPU Priority" -Value 8 -Type DWord -CheckIfExists -ForceCreatePath
            Set-RegistryValue -Path $gamesProfilePath -Name "Priority" -Value 6 -Type DWord -CheckIfExists -ForceCreatePath
            Set-RegistryValue -Path $gamesProfilePath -Name "Scheduling Category" -Value "High" -Type String -CheckIfExists -ForceCreatePath
            Set-RegistryValue -Path $gamesProfilePath -Name "SFIO Priority" -Value "High" -Type String -CheckIfExists -ForceCreatePath
            Write-RevertTip "Reverting these specific game profile tweaks requires manual registry edits or using the backup .reg file."
        } else { Write-Info "Skipped optimizing Games system profile."}
    }

    if ($sectionKey -eq '2') {
        Write-SectionHeader "Section 2: Disk Optimization & System Health"

        Write-SubSection "Clean Temporary Files"
        if (Confirm-Action "Clean standard Windows and User temporary folders?" -Default 'Y') {
            $tempPaths = @(
                "$env:TEMP",
                "$env:windir\Temp"
            )
            foreach ($path in $tempPaths) {
                if (Test-Path $path) {
                    Write-Info "Cleaning items in '$path'..."
                    try {
                        Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }
                        Write-Success "Cleaned items in '$path' (Errors ignored for files in use or access denied)."
                    } catch {
                        Write-WarningMsg "An error occurred during the cleaning process for '$path': $($_.Exception.Message)"
                    }
                } else {
                    Write-Info "Path '$path' not found. Skipping."
                }
            }
        } else { Write-Info "Skipped cleaning temporary files." }

        Write-SubSection "Run Disk Cleanup Utility"
        Write-Info "Disk Cleanup helps remove system-level temporary files, logs, etc."
        if (Confirm-Action "Run Windows Disk Cleanup utility (cleanmgr.exe)? (Requires manual selections in GUI)" -Default 'Y') {
            try {
                Write-Info "Stage 1: Opening Disk Cleanup settings (sageset)..."
                Write-Action ">>> In the window that opens, CHECK the items you want to clean (e.g., Temp files, Thumbnails), then click OK. <<<"
                Start-Process cleanmgr.exe -ArgumentList "/sageset:99" -Wait
                Write-Info "Stage 2: Running Disk Cleanup with selected settings (sagerun)..."
                Start-Process cleanmgr.exe -ArgumentList "/sagerun:99" -Wait
                Write-Success "Disk Cleanup process finished."
            } catch { Write-ErrorMsg "Failed to run Disk Cleanup: $($_.Exception.Message)" }
        } else { Write-Info "Skipped running Disk Cleanup utility." }

        Write-SubSection "Optimize Drives (TRIM/Defrag)"
        Write-Info "Optimizing SSDs (TRIM) and HDDs (Defragmentation)."
        if (Confirm-Action "Run Optimize Drives for all fixed local disks? (Can take time)" -Default 'Y') {
            try {
                Write-Info "Starting drive optimization..."
                Get-Volume | Where-Object { $_.DriveType -eq 'Fixed' -and $_.DriveLetter } | ForEach-Object {
                    Write-Info "Optimizing Volume $($_.DriveLetter): ($($_.FileSystemLabel))"
                    Optimize-Volume -DriveLetter $_.DriveLetter -Verbose
                }
                Write-Success "Optimize Drives completed."
            } catch { Write-ErrorMsg "An error occurred during Optimize Drives: $($_.Exception.Message)" }
        } else { Write-Info "Skipped running Optimize Drives." }

        Write-SubSection "System File Checker (SFC)"
        Write-Info "Checks for and attempts to repair corrupted Windows system files."
        if (Confirm-Action "Run System File Checker (sfc /scannow)? (Takes significant time)" -Default 'Y') {
            Write-Info "Running sfc /scannow ... This will take a while."
            try {
                $sfcResult = Start-Process sfc.exe -ArgumentList "/scannow" -Wait -PassThru -NoNewWindow
                Write-Info "SFC process exited with code $($sfcResult.ExitCode)."
                Write-Success "SFC scan finished. Review the output above for results."
            } catch { Write-ErrorMsg "An error occurred running SFC: $($_.Exception.Message)" }
        } else { Write-Info "Skipped System File Checker." }

        Write-SubSection "Deployment Image Servicing and Management (DISM)"
        Write-Info "Checks the component store health and attempts repairs using Windows Update."
        if (Confirm-Action "Run DISM RestoreHealth? (Takes significant time, requires internet)" -Default 'N') {
            Write-Info "Running DISM /Online /Cleanup-Image /RestoreHealth ... This will take a while."
            try {
                $dismResult = Start-Process DISM.exe -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -Wait -PassThru -NoNewWindow
                Write-Info "DISM process exited with code $($dismResult.ExitCode)."
                Write-Success "DISM RestoreHealth finished. Review the output above for results."
            } catch { Write-ErrorMsg "An error occurred running DISM: $($_.Exception.Message)" }
        } else { Write-Info "Skipped DISM RestoreHealth." }
    }

    if ($sectionKey -eq '3') {
        Write-SectionHeader "Section 3: Network Optimization (Advanced)"
        Write-WarningMsg "These settings modify TCP/IP behavior. While aiming for lower latency,"
        Write-WarningMsg "they might negatively impact throughput or compatibility on some networks."
        Write-WarningMsg "Revert Tip: Use `netsh int tcp reset` (requires restart) or specific revert commands."
        if (Confirm-Action "Proceed with ADVANCED Network Optimizations?" -Default 'N') {

            Write-SubSection "Flush DNS Cache"
            if (Confirm-Action "Flush the DNS Resolver Cache? (Good for connection issues)" -Default 'Y') {
                try {
                    ipconfig /flushdns | Out-Null
                    Write-Success "DNS Cache flushed."
                } catch { Write-ErrorMsg "Failed to flush DNS Cache: $($_.Exception.Message)"}
            }

            Write-SubSection "TCP/IP Parameter Tuning (Netsh)"
            try {
                if (Confirm-Action "Enable ECN Capability (Explicit Congestion Notification)? (Generally Recommended)" -Default 'Y') {
                    netsh int tcp set global ecncapability=enabled
                    Write-Success "Set global ecncapability=enabled."
                    Write-RevertTip "Revert: netsh int tcp set global ecncapability=disabled"
                }

                if (Confirm-Action "Set TCP Congestion Control Provider to CUBIC? (Modern algorithm, often good for gaming)" -Default 'Y') {
                    netsh int tcp set supplemental template=internet congestionprovider=cubic
                    Write-Success "Set supplemental congestionprovider=cubic for template=internet."
                    Write-RevertTip "Revert: netsh int tcp set supplemental template=internet congestionprovider=default"
                }

                if (Confirm-Action "Adjust TCP Auto-Tuning Level? (Default 'normal' is usually best. Changing can hurt throughput!)" -Default 'N') {
                    $tuningChoice = Read-Host "Enter level: 'disabled', 'highlyrestricted', 'restricted', 'normal', 'experimental' (Default: normal)"
                    if ($tuningChoice -in @('disabled', 'highlyrestricted', 'restricted', 'normal', 'experimental')) {
                        netsh int tcp set global autotuninglevel=$tuningChoice
                        Write-Success "Set global autotuninglevel=$tuningChoice."
                        Write-RevertTip "Revert: netsh int tcp set global autotuninglevel=normal"
                    } else { Write-WarningMsg "Invalid choice '$tuningChoice'. Skipped Auto-Tuning." }
                }

                if (Confirm-Action "Adjust TCP Receive Segment Coalescing (RSC) state? (Default 'enabled' offloads CPU. Disabling might slightly lower latency on some NICs but increases CPU load.)" -Default 'N') {
                    $rscChoice = Read-Host "Enter state: 'enabled' or 'disabled' (Default: enabled)"
                    if ($rscChoice -in @('enabled', 'disabled')) {
                        netsh int tcp set global rsc=$rscChoice
                        Write-Success "Set global rsc=$rscChoice."
                        Write-RevertTip "Revert: netsh int tcp set global rsc=enabled"
                    } else { Write-WarningMsg "Invalid choice '$rscChoice'. Skipped RSC setting." }
                }

            } catch { Write-ErrorMsg "An error occurred during Netsh tuning: $($_.Exception.Message)" }

            Write-SubSection "Network Throttling Index"
            Write-Info "Disabling network throttling for non-multimedia applications."
            $mmProfilePath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"

            if (Confirm-Action "Disable Network Throttling (Set NetworkThrottlingIndex = 0xFFFFFFFF)? (Recommended)" -Default 'Y') {
                Set-RegistryValue -Path $mmProfilePath -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord -CheckIfExists
                Write-RevertTip "To revert Network Throttling: Set NetworkThrottlingIndex back to 10 (Decimal) or use backup."
            } else { Write-Info "Skipped disabling network throttling." }

            Write-SubSection "NDU Service (Network Diagnostic Usage - Very Advanced/Risky)"
            Write-WarningMsg "NDU monitors network data usage. Disabling it *might* fix rare memory leaks or reduce minor overhead,"
            Write-WarningMsg "BUT it can hinder network troubleshooting significantly. Consider carefully."
            $nduPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Ndu"
            $currentNduStart = (Get-ItemProperty -Path $nduPath -Name "Start" -ErrorAction SilentlyContinue).Start

            if ($currentNduStart -ne 4) {
                if (Confirm-Action "Disable the NDU service (Set Start = 4)? (Use caution, affects diagnostics, requires restart)" -Default 'N') {
                    if (Set-RegistryValue -Path $nduPath -Name "Start" -Value 4 -Type DWord) {
                        Write-Success "NDU service set to Disabled in registry. REQUIRES RESTART."
                        Write-RevertTip "To re-enable NDU: Set Start back to 2 (Automatic) in registry and RESTART."
                    }
                } else { Write-Info "Skipped disabling NDU service."}
            } else { Write-Info "NDU service is already disabled in the registry." }

        } else { Write-Info "Skipped Advanced Network Optimizations section." }
    }

    if ($sectionKey -eq '4') {
        Write-SectionHeader "Section 4: Service Tuning & Disable Defender (EXTREME RISK)"
        Write-WarningMsg "Disabling services can free up resources but MAY BREAK FUNCTIONALITY!"
        Write-WarningMsg "Only disable services you are CERTAIN you do not need. Research if unsure."
        Write-WarningMsg "Original service states are being backed up to '$($scriptBackupFolder)\ServiceBackup_$($timeStamp).csv'."

        Write-SubSection "Review and Disable Optional Services"
        Write-Info "The following services are sometimes disabled for performance."
        Write-Action "Answer Y/N for each service you want to disable."

        $servicesToConsider = @(
            @{ Name = "Fax";                         Reason = "Provides Fax capabilities (Rarely used)"; Default = 'Y' }
            @{ Name = "PrintSpooler";                Reason = "Manages printers. **DO NOT DISABLE if you print!**"; Default = 'N'; Aliases = @("Spooler") }
            @{ Name = "RemoteRegistry";              Reason = "Allows remote registry modification (Security risk if not needed)"; Default = 'Y' }
            @{ Name = "TabletInputService";          Reason = "Enables Pen and Touch features (Touch Keyboard, Handwriting)"; Default = 'Y'; Aliases = @("TouchKeyboardAndHandwritingPanelService") }
            @{ Name = "WalletService";               Reason = "Microsoft Wallet payments"; Default = 'Y' }
            @{ Name = "AllJoynRouterService";        Reason = "Communication framework for IoT devices"; Default = 'Y' }
            @{ Name = "DiagTrack";                   Reason = "Connected User Experiences and Telemetry (Data collection)"; Default = 'Y' }
            @{ Name = "dmwappushservice";            Reason = "Device Management Wireless Application Protocol (WAP) Push message routing"; Default = 'Y' }
            @{ Name = "RemoteDesktopServices";       Reason = "Allows Remote Desktop Connections **to** this PC"; Default = 'N'; Aliases = @("TermService") }
            @{ Name = "MapsBroker";                  Reason = "Broker for Windows Maps application access"; Default = 'Y' }
            @{ Name = "PhoneSvc";                    Reason = "Connects to phones via Phone Link app"; Default = 'Y' }
            @{ Name = "XboxGipSvc";                  Reason = "Xbox Accessory Management Service (Controllers via adapter)"; Default = 'N' }
            @{ Name = "XboxNetApiSvc";               Reason = "Xbox Live Networking Service (Online features)"; Default = 'N' }
            @{ Name = "XblAuthManager";              Reason = "Xbox Live Authentication Manager (Login)"; Default = 'N' }
            @{ Name = "XblGameSave";                 Reason = "Xbox Live Game Save Service (Cloud saves)"; Default = 'N' }
        )

        $processedServiceNames = [System.Collections.Generic.List[string]]::new()

        foreach ($item in $servicesToConsider) {
            $serviceName = $item.Name
            $reason = $item.Reason
            $defaultChoice = $item.Default
            $aliases = $item.Aliases

            $actualServiceName = $null
            $serviceObject = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
            if ($serviceObject) {
                $actualServiceName = $serviceName
            } elseif ($aliases) {
                foreach ($alias in $aliases) {
                    $serviceObject = Get-Service -Name $alias -ErrorAction SilentlyContinue
                    if ($serviceObject) {
                        $actualServiceName = $alias
                        Write-Info "Service '$serviceName' found using alias '$alias'."
                        break
                    }
                }
            }

            if ($actualServiceName -eq $null) {
                Write-Info "Service '$serviceName' (and aliases) not found. Skipping."
                continue
            }
            if ($processedServiceNames.Contains($actualServiceName)) {
                Write-Info "Service '$actualServiceName' already considered (possibly via alias). Skipping."
                continue
            }
            $processedServiceNames.Add($actualServiceName)

            if ($serviceObject.StartType -ne 'Disabled') {
                if (Confirm-Action "Disable Service '$actualServiceName'? ($reason)" -Default $defaultChoice) {
                    Manage-Service -ServiceName $actualServiceName -TargetStartupType Disabled -StopServiceIfRunning
                } else {
                    Write-Info "Skipped disabling Service '$actualServiceName'."
                }
            } else {
                Write-Info "Service '$actualServiceName' is already Disabled."
            }
            Start-Sleep -Milliseconds 100
        }

        Write-SubSection "Attempt to Disable Windows Defender (EXTREME RISK!)"
        Write-CriticalWarning "!!!!!!!!!!!!!!!!!!!!!!!!!!!! WARNING !!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        Write-CriticalWarning "Disabling Microsoft Defender leaves your system DEFENSELESS against"
        Write-CriticalWarning "viruses, malware, and ransomware. This is HIGHLY NOT RECOMMENDED."
        Write-CriticalWarning "For this to have ANY CHANCE of working, you MUST disable"
        Write-CriticalWarning "'Tamper Protection' in Windows Security MANUALLY BEFORE running this."
        Write-CriticalWarning "Even then, Windows may attempt to re-enable Defender later."
        Write-CriticalWarning "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

        if (Confirm-Action "Are you ABSOLUTELY SURE you want to attempt disabling Windows Defender? (Default: N)" -Default 'N') {

            Write-Info "Attempting to disable Defender via Registry (Requires Tamper Protection OFF)..."
            $defenderRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
            Set-RegistryValue -Path $defenderRegPath -Name "DisableAntiSpyware" -Value 1 -Type DWord -ForceCreatePath

             $realTimeProtectPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"
             Set-RegistryValue -Path $realTimeProtectPath -Name "DisableRealtimeMonitoring" -Value 1 -Type DWord -ForceCreatePath
             Set-RegistryValue -Path $realTimeProtectPath -Name "DisableBehaviorMonitoring" -Value 1 -Type DWord -ForceCreatePath
             Set-RegistryValue -Path $realTimeProtectPath -Name "DisableOnAccessProtection" -Value 1 -Type DWord -ForceCreatePath
             Set-RegistryValue -Path $realTimeProtectPath -Name "DisableScanOnRealtimeEnable" -Value 1 -Type DWord -ForceCreatePath

             $spynetPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet"
             Set-RegistryValue -Path $spynetPath -Name "SpynetReporting" -Value 0 -Type DWord -ForceCreatePath
             Set-RegistryValue -Path $spynetPath -Name "SubmitSamplesConsent" -Value 2 -Type DWord -ForceCreatePath

            Write-Info "Attempting to disable Defender-related services..."
            $defenderServices = @(
                "WinDefend",
                "Sense",
                "WdNisSvc",
                "WdBoot",
                "WdFilter",
                "SecurityHealthService"
            )
            foreach ($svcName in $defenderServices) {
                 Manage-Service -ServiceName $svcName -TargetStartupType Disabled -StopServiceIfRunning
            }

            Write-Success "Attempted to disable Windows Defender via Registry and Services."
            Write-WarningMsg "Effectiveness depends heavily on Tamper Protection being OFF and Windows version."
            Write-WarningMsg "A RESTART is required."
            Write-RevertTip "Reverting Defender disable: Enable services ('WinDefend', 'WdNisSvc', 'SecurityHealthService', possibly 'Sense'), delete registry values under HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender, RESTART, and turn Tamper Protection back ON."

        } else {
            Write-Info "Skipped attempting to disable Windows Defender."
        }

        Write-SubSection "Manage Startup Applications (Manual Task)"
        Write-Info "Disabling unnecessary startup programs significantly improves boot time and frees resources."
        Write-Action "This script recommends managing startup apps MANUALLY via Task Manager for safety."
        Write-Action "1. Open Task Manager (Ctrl+Shift+Esc)."
        Write-Action "2. Go to the 'Startup apps' tab (Click 'More details' if needed)."
        Write-Action "3. Review each app, its publisher, and its Startup Impact."
        Write-Action "4. Right-click apps you DON'T need running immediately at login -> Select 'Disable'."
        Write-WarningMsg "**Be Careful!** Do not disable essential drivers (audio, graphics), security software (if you didn't disable Defender!), or critical system components."
        if (Confirm-Action "Open Task Manager now to manage startup applications?" -Default 'Y') {
            try {
                Start-Process taskmgr.exe
                Read-Host ">>> After managing startup apps in Task Manager, press Enter here to continue the script <<<"
            } catch {
                Write-ErrorMsg "Could not open Task Manager automatically. Please open it manually (Ctrl+Shift+Esc)."
                Read-Host "Press Enter to continue..."
            }
        } else { Write-Info "Skipped opening Task Manager for startup apps." }
    }

    if ($sectionKey -eq '5') {
        Write-SectionHeader "Section 5: Visual Effects & UI Tweaks"
        Write-Info "Reducing visual effects can improve UI responsiveness, especially on lower-end hardware."

        Write-SubSection "Adjust Visual Effects Settings"
        Write-Info "Setting for 'Best Performance' disables most animations, shadows, etc."
        $visualFxRegPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects'
        $currentVisualFxSetting = (Get-ItemProperty -Path $visualFxRegPath -Name 'VisualFXSetting' -ErrorAction SilentlyContinue).VisualFXSetting

        if ($currentVisualFxSetting -ne 3) {
            if (Confirm-Action "Set Visual Effects to 'Adjust for best performance'? (Less eye candy)" -Default 'Y') {
                if (Set-RegistryValue -Path $visualFxRegPath -Name 'VisualFXSetting' -Value 3 -Type DWord -ForceCreatePath) {
                    Set-RegistryValue -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'EnableTransparency' -Value 0 -Type DWord -ForceCreatePath -CheckIfExists
                    $desktopRegPath = 'HKCU:\Control Panel\Desktop'
                    $currentMask = (Get-ItemProperty -Path $desktopRegPath -Name 'UserPreferencesMask' -ErrorAction SilentlyContinue).UserPreferencesMask
                    if($currentMask){ Backup-RegistryKey -RegistryPath $desktopRegPath }
                    Set-RegistryValue -Path $desktopRegPath -Name 'UserPreferencesMask' -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Type Binary
                    Set-RegistryValue -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value '0' -Type String -CheckIfExists -ForceCreatePath

                    Write-Success "Visual Effects set for best performance. Some changes may require Log off/Restart."
                    Write-RevertTip "Revert: System Properties > Advanced > Performance Settings > 'Adjust for best appearance' or 'Let Windows choose'. Restore 'UserPreferencesMask' from backup if needed."
                }
            } else { Write-Info "Skipped adjusting visual effects." }
        } else { Write-Info "Visual Effects setting appears to be already configured for performance." }

        Write-SubSection "Disable Transparency Effects Explicitly"
        Write-Info "Ensuring transparency is off for Start, Taskbar, etc."
        $personalizePath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
        if (Confirm-Action "Ensure Transparency effects are disabled?" -Default 'Y') {
            Set-RegistryValue -Path $personalizePath -Name 'EnableTransparency' -Value 0 -Type DWord -ForceCreatePath -CheckIfExists
            Write-RevertTip "Revert Transparency: Settings > Personalization > Colors > Transparency effects (On)."
        } else { Write-Info "Skipped explicit check for transparency effects."}
    }

    if ($sectionKey -eq '6') {
        Write-SectionHeader "Section 6: Telemetry & Privacy Adjustments"
        Write-Info "Reducing background data collection. May have minor performance/privacy benefits."

        Write-SubSection "Limit Diagnostic Data (Telemetry)"
        Write-Info "Setting diagnostic data level to 'Required' (Basic) via Policy."
        $telemetryRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        if (Confirm-Action "Set Diagnostic Data level to 'Required' (AllowTelemetry=1 via Policy)? (Recommended for Privacy)" -Default 'Y') {
            Set-RegistryValue -Path $telemetryRegPath -Name "AllowTelemetry" -Value 1 -Type DWord -ForceCreatePath -CheckIfExists
            Write-RevertTip "Revert Telemetry: Delete the AllowTelemetry value or use Settings > Privacy & security > Diagnostics & feedback (if not policy-locked)."
        } else { Write-Info "Skipped setting telemetry level."}

        Write-SubSection "Disable Advertising ID"
        Write-Info "Prevents apps using Advertising ID for personalized ads (per user)."
        $adIdRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
        if (Confirm-Action "Disable Advertising ID for this user (Enabled=0)?" -Default 'Y') {
            Set-RegistryValue -Path $adIdRegPath -Name "Enabled" -Value 0 -Type DWord -ForceCreatePath -CheckIfExists
            Write-RevertTip "Revert Advertising ID: Settings > Privacy & security > General > Let apps show me personalized ads... (On)."
        } else { Write-Info "Skipped disabling Advertising ID."}

        Write-SubSection "Disable CEIP Scheduled Tasks"
        Write-Info "Disabling Customer Experience Improvement Program tasks."
        if (Confirm-Action "Disable CEIP scheduled tasks in Task Scheduler?" -Default 'Y') {
            $ceipTaskPath = "\Microsoft\Windows\Customer Experience Improvement Program\"
            try {
                Get-ScheduledTask -TaskPath $ceipTaskPath -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue
                Write-Success "Attempted to disable tasks in '$ceipTaskPath' (if they existed)."
                Write-RevertTip "Revert CEIP Tasks: Open Task Scheduler, navigate to the path, and Enable the tasks."
            } catch { Write-ErrorMsg "Error disabling CEIP scheduled tasks: $($_.Exception.Message)" }
        } else { Write-Info "Skipped disabling CEIP scheduled tasks." }
    }

    if ($sectionKey -eq '7') {
        Write-SectionHeader "Section 7: Disable Windows Update PERMANENTLY (EXTREME RISK)"
        Write-CriticalWarning "!!!!!!!!!!!!!!!!!!!!!!!!!!!! WARNING !!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        Write-CriticalWarning "Disabling Windows Update PERMANENTLY means NO MORE SECURITY PATCHES,"
        Write-CriticalWarning "NO bug fixes, NO driver updates via WU. Your system WILL become"
        Write-CriticalWarning "increasingly vulnerable over time. This is EXTREMELY DANGEROUS."
        Write-CriticalWarning "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

        if (Confirm-Action "Are you ABSOLUTELY SURE you want to attempt disabling Windows Update permanently? (Default: N)" -Default 'N') {

             Write-Info "Attempting to disable Automatic Updates via Registry Policy..."
             $wuPolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
             Set-RegistryValue -Path $wuPolicyPath -Name "NoAutoUpdate" -Value 1 -Type DWord -ForceCreatePath
             Set-RegistryValue -Path $wuPolicyPath -Name "AUOptions" -Value 1 -Type DWord -ForceCreatePath

             Write-Info "Attempting to disable Windows Update services..."
             $updateServices = @(
                "wuauserv",
                "UsoSvc",
                "DoSvc"
             )
             foreach ($svcName in $updateServices) {
                 Manage-Service -ServiceName $svcName -TargetStartupType Disabled -StopServiceIfRunning
             }

             Write-Success "Attempted to disable Windows Update via Registry and Services."
             Write-WarningMsg "Windows may still find ways to re-enable updates. This is not guaranteed to be permanent."
             Write-WarningMsg "A RESTART is required."
             Write-RevertTip "Reverting WU disable: Enable services ('wuauserv', 'UsoSvc', 'DoSvc'), delete registry values under HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU, RESTART."

        } else {
             Write-Info "Skipped disabling Windows Update permanently."
        }
    }

}

Write-SectionHeader "Optimization Run Complete!"
Write-Info "The script has finished applying changes for the executed sections:"
$executionOrder | ForEach-Object { Write-Host " - $($options[$_])" }
Write-Host ""
Write-BackupInfo "Registry backups (.reg) and Service states (.csv) were saved to: $scriptBackupFolder"
if($selectedSections.ContainsKey('4') -or $selectedSections.ContainsKey('7')){
    Write-CriticalWarning "REMINDER: Critical security features (Defender and/or Update) may have"
    Write-CriticalWarning "been disabled based on your choices. This poses a SEVERE SECURITY RISK."
}
Write-WarningMsg "**A RESTART IS STRONGLY RECOMMENDED** for many changes to take full effect,"
Write-WarningMsg "especially for Service, Registry, HAGS, and potential Defender/Update disables."
Write-Host ""

Save-ServiceBackups

if (Confirm-Action "Do you want to RESTART your computer now to apply changes?" -Default 'Y') {
    Write-WarningMsg "RESTARTING in 15 seconds. Save your work!"
    Start-Sleep -Seconds 10
    Write-WarningMsg "Restarting in 5..."
    Start-Sleep -Seconds 1
    Write-WarningMsg "Restarting in 4..."
    Start-Sleep -Seconds 1
    Write-WarningMsg "Restarting in 3..."
    Start-Sleep -Seconds 1
    Write-WarningMsg "Restarting in 2..."
    Start-Sleep -Seconds 1
    Write-WarningMsg "Restarting in 1..."
    Start-Sleep -Seconds 1
    Write-Action "Issuing restart command..."
    Stop-Transcript
    Restart-Computer -Force
} else {
    Write-Info "Okay, please remember to restart your computer manually soon to apply all changes."
    Read-Host "Press Enter to close this script window..."
    Stop-Transcript
}
