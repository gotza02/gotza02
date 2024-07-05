# Requires -RunAsAdministrator
# Requires -Modules PSWindowsUpdate

# Script for comprehensive driver analysis, update, and installation on Windows 11
# Version 6.0

# Region - Functions

# Function to write formatted log messages
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$timestamp - $Message" | Tee-Object -Append -FilePath $logFile -Encoding utf8
}

# Function to create a system restore point
function Create-RestorePoint {
    Write-Log "Creating system restore point..."
    try {
        Checkpoint-Computer -Description "Before Driver Update $timestamp" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Write-Log "Restore point created successfully."
    }
    catch {
        Write-Log "Failed to create restore point: $($_.Exception.Message)"
        if (-not $criticalError) {
            if ((Read-Host -Prompt "Do you want to continue without a restore point? (Y/N)") -ne "Y") {
                Write-Log "Exiting script."
                Exit 1
            } else {
                Write-Log "Continuing with driver update process."
            }
        } else {
            Write-Log "Exiting script."
            Exit 1
        }
    }
}

# Function to get detailed driver information
function Get-DriverInfo {
    Write-Log "Analyzing current drivers..."
    Get-PnpDevice -Class 'Display' -PresentOnly | ForEach-Object {
        [PSCustomObject]@{
            DeviceName    = $_.Name
            Manufacturer  = $_.Manufacturer
            DriverVersion = $_.DriverVersion -replace '"',''
            DriverDate    = $_.DriverDate
            DeviceID      = $_.InstanceId
            Status        = $_.Status
            Class         = $_.Class
        }
    }
}

# Function to check for driver updates using Windows Update
function Get-DriverUpdates {
    Write-Log "Checking for driver updates via Windows Update..."
    try {
        $updates = Get-WindowsUpdate -MicrosoftUpdate -ThirdPartyUpdate -AcceptAll -HideReportSuccess -ErrorAction SilentlyContinue
        if ($updates.Count -gt 0) {
            Write-Log "Found $($updates.Count) driver updates."
            return $updates
        } else {
            Write-Log "No driver updates found."
            return $null
        }
    }
    catch {
        Write-Log "Error checking for driver updates: $($_.Exception.Message)"
        return $null
    }
}

# Function to install driver updates
function Install-DriverUpdates {
    param($Updates)

    if ($null -eq $Updates -or $Updates.Count -eq 0) {
        Write-Log "No driver updates to install."
        return $false
    }

    Write-Log "Installing driver updates..."
    try {
        $installationJob = Install-WindowsUpdate -MicrosoftUpdate -ThirdPartyUpdate -AcceptAll -IgnoreReboot -Install -Driver -ErrorAction Stop
        Write-Log "Waiting for driver update installation to complete..."

        while ($installationJob.State -eq "Running") {
            Start-Sleep -Seconds 5
            $installationJob | Get-WUJob | Select-Object JobState, Progress, TimeRemaining
        }

        if ($installationJob.State -eq "Completed") {
            Write-Log "Driver updates installed successfully."
            return $true
        } else {
            Write-Log "Driver update installation failed. Check the Windows Update history for details."
            return $false
        }
    }
    catch {
        Write-Log "Error installing driver updates: $($_.Exception.Message)"
        return $false
    }
}

# Function to clean up temporary files
function Clean-Up {
    if ($tempDir -ne $null -and (Test-Path -Path $tempDir)) {
        Write-Log "Cleaning up temporary directory: $tempDir"
        try {
            Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
            Write-Log "Temporary directory deleted."
        }
        catch {
            Write-Log "Error deleting temporary directory: $($_.Exception.Message)"
        }
    }
}

# End Region - Functions

# Region - Main Script

# Set up logging and temporary directory
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$tempDir = Join-Path $env:TEMP "DriverUpdate_$timestamp"
$logFile = Join-Path $tempDir "DriverUpdate.log"
$csvFile = Join-Path $tempDir "DriverInfo.csv"
$criticalError = $false

# Create temporary directory
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# Write initial log messages
Write-Log "Driver Update Process Started"
Write-Log "Temporary directory: $tempDir"
Write-Log "Log file: $logFile"
Write-Log "CSV file: $csvFile"

# Create system restore point
Create-RestorePoint

# Get detailed driver information and export to CSV
$drivers = Get-DriverInfo | Export-Csv -Path $csvFile -NoTypeInformation
Write-Log "Driver information exported to $csvFile"

# Check for and install driver updates
$updateInstalled = Get-DriverUpdates | Install-DriverUpdates

# Final steps
if ($updateInstalled) {
    Write-Log "Driver updates were installed. A system restart is recommended."
    if ((Get-WmiObject -Class Win32_OperatingSystem).RebootRequired) {
        Write-Log "System restart is pending. Restarting in 5 seconds..."
        Start-Sleep -Seconds 5
        Restart-Computer -Force
    } else {
        if ((Read-Host -Prompt "Do you want to restart the system now? (Y/N)") -eq "Y") {
            Write-Log "Initiating system restart..."
            Restart-Computer -Force
        } else {
            Write-Log "Restart postponed. Please restart your system at your earliest convenience."
        }
    }
} else {
    Write-Log "No driver updates were installed."
}

# Clean up temporary files
Clean-Up

Write-Log "Driver update process completed."
Write-Host "Process completed. Log file: $logFile"

# End Region - Main Script
