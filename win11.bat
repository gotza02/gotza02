# Sample PowerShell script to optimize Windows 11 PC performance and update drivers

# 1. Optimize hard drives
Write-Host "Optimizing hard drives..." -ForegroundColor Yellow
Get-Volume | ForEach-Object { Optimize-Volume -DriveLetter $_.DriveLetter -ReTrim -Verbose }

# 2. Set power plan to High Performance
Write-Host "Setting power plan to High Performance..." -ForegroundColor Yellow
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# 3. Clean up temporary files and folders
Write-Host "Cleaning up temporary files and folders..." -ForegroundColor Yellow
Remove-Item -Path "C:\Windows\Temp\*","C:\Users\*\AppData\Local\Temp\*" -Recurse -Force -ErrorAction Ignore

# 4. Disable visual effects
Write-Host "Disabling visual effects..." -ForegroundColor Yellow
$VisualEffectsKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
$VisualEffectsKey = Get-ItemProperty -Path $VisualEffectsKeyPath -ErrorAction SilentlyContinue

if ($VisualEffectsKey -eq $null) {
    New-Item -Path $VisualEffectsKeyPath -Force | Out-Null
}

Set-ItemProperty -Path $VisualEffectsKeyPath -Name "VisualFXSetting" -Value 2

# 5. Install and import the DriverUpdate module
Write-Host "Installing and importing the DriverUpdate module..." -ForegroundColor Yellow
Install-Module -Name DriverUpdate -Scope CurrentUser -Force
Import-Module DriverUpdate

# 6. Update all drivers
Write-Host "Updating all drivers..." -ForegroundColor Yellow
Find-DriverUpdate | Install-DriverUpdate

# 7. Restart the computer (optional)
$Restart = Read-Host "Do you want to restart your computer now? (y/n)"
if ($Restart -eq "y") {
    Restart-Computer
}
