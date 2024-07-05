# Requires -RunAsAdministrator

# Script for comprehensive driver analysis, update, and installation on Windows 11
# Version 3.0

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

# Function to check for driver updates
function Check-DriverUpdate {
    param([string]$DeviceName, [string]$Manufacturer, [string]$CurrentVersion)
    
    # This is a placeholder for actual driver update check logic
    # You would need to implement a proper method to check for updates
    # This could involve querying Windows Update, manufacturer websites, or a driver database
    
    $updateAvailable = $false
    $newVersion = $null
    $downloadUrl = $null

    # Simulating an update check (replace with actual check)
    try {
        $response = Invoke-RestMethod -Uri "https://example.com/api/drivercheck?name=$DeviceName&manufacturer=$Manufacturer&version=$CurrentVersion" -ErrorAction Stop
        $updateAvailable = $response.updateAvailable
        $newVersion = $response.newVersion
        $downloadUrl = $response.downloadUrl
    }
    catch {
        Write-Log "Driver check failed for $DeviceName: $_"
    }

    return @{
        UpdateAvailable = $updateAvailable
        NewVersion = $newVersion
        DownloadUrl = $downloadUrl
    }
}

# Function to download and install driver
function Update-Driver {
    param(
        [string]$DeviceName,
        [string]$DownloadUrl,
        [string]$DeviceID
    )

    $downloadPath = Join-Path $tempDir "$DeviceName.zip"
    $extractPath = Join-Path $tempDir $DeviceName

    try {
        # Download driver
        Write-Log "Downloading driver for $DeviceName"
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $downloadPath

        # Extract driver
        Write-Log "Extracting driver package"
        Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force

        # Install driver
        Write-Log "Installing driver for $DeviceName"
        $result = pnputil /add-driver "$extractPath\*.inf" /install /subdirs
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Driver installed successfully: $DeviceName"
            
            # Attempt to update the specific device
            $updateAttempt = Update-PnpDevice -InstanceId $DeviceID -Confirm:$false
            if ($updateAttempt) {
                Write-Log "Device updated: $DeviceName"
            }
            else {
                Write-Log "Device update may require a restart: $DeviceName"
            }
        }
        else {
            Write-Log "Failed to install driver: $DeviceName. Error: $result"
        }
    }
    catch {
        Write-Log "Error updating driver for $DeviceName: $_"
    }
    finally {
        # Clean up
        Remove-Item -Path $downloadPath -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Main update process
$updateRequired = $false
foreach ($driver in $drivers) {
    $updateCheck = Check-DriverUpdate -DeviceName $driver.DeviceName -Manufacturer $driver.Manufacturer -CurrentVersion $driver.DriverVersion
    
    if ($updateCheck.UpdateAvailable) {
        $updateRequired = $true
        Write-Log "Update available for $($driver.DeviceName): Current version $($driver.DriverVersion), New version $($updateCheck.NewVersion)"
        Update-Driver -DeviceName $driver.DeviceName -DownloadUrl $updateCheck.DownloadUrl -DeviceID $driver.DeviceID
    }
    else {
        Write-Log "No update available for $($driver.DeviceName)"
    }
}

# Final steps
if ($updateRequired) {
    Write-Log "Some drivers were updated. A system restart is recommended."
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
    Write-Log "No driver updates were required."
}

Write-Log "Driver update process completed."
Write-Host "Process completed. Log file: $logFile"
