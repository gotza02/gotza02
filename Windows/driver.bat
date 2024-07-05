# Requires -RunAsAdministrator
# Requires -Modules PSWindowsUpdate

# Script for comprehensive driver analysis, update, and installation on Windows 11
# Version 4.0

# Check if PSWindowsUpdate module is installed, if not, install it
if (!(Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Host "PSWindowsUpdate module not found. Installing..."
    Install-Module -Name PSWindowsUpdate -Force -AllowClobber
}

Import-Module PSWindowsUpdate

# Function to write formatted log messages
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Tee-Object -Append -FilePath $logFile
}

# Set up logging and temporary directory
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$tempDir = Join-Path $env:TEMP "DriverUpdate_$timestamp"
$logFile = Join-Path $tempDir "DriverUpdate.log"
$csvFile = Join-Path $tempDir "DriverInfo.csv"
$null = New-Item -ItemType Directory -Path $tempDir -Force

Write-Log "Driver Update Process Started"
Write-Log "Temporary directory: $tempDir"
Write-Log "Log file: $logFile"
Write-Log "CSV file: $csvFile"

# Function to create a restore point
function Create-RestorePoint {
    Write-Log "Creating system restore point..."
    try {
        Checkpoint-Computer -Description "Before Driver Update $timestamp" -RestorePointType "MODIFY_SETTINGS"
        Write-Log "Restore point created successfully"
    }
    catch {
        Write-Log "Failed to create restore point: $_"
    }
}

# Create restore point
Create-RestorePoint

# Analyze current drivers
Write-Log "Analyzing current drivers..."
$drivers = Get-WmiObject Win32_PnPSignedDriver | Select-Object DeviceName, Manufacturer, DriverVersion, DriverDate, DeviceID

# Export driver info to CSV
$drivers | Export-Csv -Path $csvFile -NoTypeInformation
Write-Log "Driver information exported to $csvFile"

# Function to check for driver updates using Windows Update
function Get-DriverUpdates {
    Write-Log "Checking for driver updates via Windows Update..."
    try {
        $updates = Get-WindowsUpdate -Driver -AcceptAll
        return $updates
    }
    catch {
        Write-Log "Error checking for driver updates: $_"
        return $null
    }
}

# Function to install driver updates
function Install-DriverUpdates {
    param($Updates)
    
    if ($null -eq $Updates -or $Updates.Count -eq 0) {
        Write-Log "No driver updates available."
        return $false
    }

    Write-Log "Installing driver updates..."
    try {
        Install-WindowsUpdate -AcceptAll -IgnoreReboot -Install -Driver
        Write-Log "Driver updates installed successfully."
        return $true
    }
    catch {
        Write-Log "Error installing driver updates: $_"
        return $false
    }
}

# Main update process
$driverUpdates = Get-DriverUpdates
$updateInstalled = Install-DriverUpdates -Updates $driverUpdates

# Final steps
if ($updateInstalled) {
    Write-Log "Driver updates were installed. A system restart is recommended."
    $restartChoice = Read-Host "Do you want to restart the system now? (Y/N)"
    if ($restartChoice -eq "Y") {
        Write-Log "Initiating system restart..."
        Restart-Computer -Force
    }
    else {
        Write-Log "Restart postponed. Please restart your system at your earliest convenience."
    }
}
else {
    Write-Log "No driver updates were required or installation failed."
}

Write-Log "Driver update process completed."
Write-Host "Process completed. Log file: $logFile"
