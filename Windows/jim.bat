# ต้องรันด้วยสิทธิ์ผู้ดูแลระบบ
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" + $myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}

# ตรวจสอบว่าเป็น Windows 11 หรือไม่
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.Caption -notlike "*Windows 11*") {
    Write-Host "This script is intended for Windows 11. Your current OS is: $($osInfo.Caption)"
    Exit
}

# อัปเดต PSWindowsUpdate module
Install-Module -Name PSWindowsUpdate -Force -AllowClobber

# นำเข้า module
Import-Module PSWindowsUpdate

# ตรวจสอบการอัปเดตที่มี
Write-Host "Checking for updates..."
$updates = Get-WindowsUpdate

if ($updates.Count -eq 0) {
    Write-Host "No updates available. Your system is up to date."
} else {
    Write-Host "Found $($updates.Count) update(s). Installing..."
    
    # ติดตั้งการอัปเดตทั้งหมดและรีบูตถ้าจำเป็น
    Install-WindowsUpdate -AcceptAll -AutoReboot
}
