param(
    [string]$FileName
)

# Function to ensure Chocolatey is installed and up to date
function Ensure-ChocolateyInstalled {
    if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
    
    # Update Chocolatey
    choco upgrade chocolatey -y
}

# Read the file and get desired package list
function Get-DesiredPackages {
    param(
        [string]$FilePath
    )

    if (-Not (Test-Path $FilePath)) {
        Write-Error "File not found: $FilePath"
        return @()
    }

    $desiredPackages = @()
    $lines = Get-Content -Path $FilePath

    foreach ($line in $lines) {
        if ($line -match '^\s*#|^\s*$') {
            continue # Ignore comments or empty lines
        }
        $desiredPackages += $line.Trim()
    }
    return $desiredPackages
}

# Synchronize Chocolatey packages
function Synchronize-Packages {
    param(
        [string[]]$DesiredPackages
    )

    $installedPackages = choco list --local-only | Select-String '^\S+' -AllMatches | ForEach-Object {
        $_.Matches.Groups[0].Value
    }

    # Find packages that need to be installed or updated
    foreach ($package in $DesiredPackages) {
        if ($installedPackages -contains $package) {
            Write-Host "Updating $package..."
            choco upgrade $package -y
        }
        else {
            Write-Host "Installing $package..."
            choco install $package -y
        }
    }

    # Find packages that need to be uninstalled
    foreach ($package in $installedPackages) {
        if ($DesiredPackages -notcontains $package) {
            Write-Host "Uninstalling $package..."
            choco uninstall $package -y
        }
    }
}

# Main script execution
Ensure-ChocolateyInstalled
$desiredPackages = Get-DesiredPackages -FilePath $FileName
Synchronize-Packages -DesiredPackages $desiredPackages