# Ensure TLS 1.2 is used for secure downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Install the NuGet provider silently
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false

# Import the NuGet provider (optional, but ensures it's loaded)
Import-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install the PSWindowsUpdate module silently
Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
# Set the execution policy to allow the script to run
# This is a temporary change and will not affect the system-wide policy
# Note: This will only affect the current PowerShell session
# If you want to set it permanently, you can use -Scope CurrentUser or -Scope LocalMachine 
Set-ExecutionPolicy Bypass -Scope Process -Force
# Import the PSWindowsUpdate module
Import-Module PSWindowsUpdate
# Check for available updates
$updates = Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot
# Install all available updates
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
