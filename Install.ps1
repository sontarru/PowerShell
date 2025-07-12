<#
.SYNOPSIS
Installs modules (PSResources) from the PSGallery and GitHub repositories depending on
the current platform (Windows or Linux) and environment (other application installed).
#>

[CmdletBinding()]
param (
    [switch]
    $Reinstall
)

$ErrorActionPreference = 'Stop'

#
# Install optional Posh-Git
#

$git = $IsWindows ?
    "$env:ProgramFiles\Git\bin\git.exe" :
    (which git)

if(Get-Command $git -ErrorAction SilentlyContinue) {
    Write-Host "Installing Posh-Git"
    Install-PSResource -Name Posh-Git -Repository PSGallery -Reinstall:$Reinstall
}

#
# Install optional DockerCompletion
#

$docker = $IsWindows ?
    "$env:ProgramFiles\Docker\Docker\resources\bin\docker.exe" :
    (which docker)

if(Get-Command $docker -ErrorAction SilentlyContinue) {
    Write-Host "Installing DockerCompletion"
    Install-PSResource -Name DockerCompletion -Repository PSGallery -Reinstall:$Reinstall
}

#
# Install own modules
#

# First of all bring module directories to lowercase.  On Linix if there's a directory e.g.
# Sontar.PowerShell.Foo and the Sontar.PowerShell.Foo module is being installed it will go
# to the 'sontar.powershell.foo' directory and the're will be conflict.

$moduleRoot = $IsWindows ?
    "$env:USERPROFILE\Documents\PowerShell\Modules" :
    "$env:HOME/.local/share/powershell/Modules"

foreach($moduleDir in (Get-ChildItem $moduleRoot -Filter "Sontar.PowerShell.*")) {
    Rename-Item $moduleDir $moduleDir.Name.ToLowerInvariant() -ErrorAction SilentlyContinue
}

Install-PSResource -Name "Sontar.PowerShell.Profile" -Repository GitHub -Reinstall:$Reinstall
Install-PSResource -Name "Sontar.PowerShell.Utility" -Repository GitHub -Reinstall:$Reinstall

#
# Capitalize modules
#

foreach($moduleDir in (Get-ChildItem $moduleRoot -Filter "Sontar.PowerShell.*")) {
    foreach($moduleVersionDir in (Get-ChildItem $moduleDir)) {
        $modulePsdFile = Get-ChildItem $moduleVersionDir -Filter "$($moduleDir.Name).psd1" |
            Select-Object -First 1

        if(-not $modulePsdFile) {
            continue
        }

        $moduleXmlFile = Get-Item (Join-Path $moduleVersionDir.FullName "PSGetModuleInfo.xml") `
            -ErrorAction SilentlyContinue

        if(-not $moduleXmlFile) {
            continue
        }

        $moduleName = $modulePsdFile.BaseName

        $moduleXml = [xml](Get-Content $moduleXmlFile)

        foreach($node in $moduleXml.Objs.Obj.MS.S) {
            if($node.N -eq 'Name') {
                $node.InnerText = $moduleName
                break
            }
        }

        $moduleXml.Save($moduleXmlFile.FullName)
    }

    Rename-Item $moduleDir -NewName $moduleName -ErrorAction SilentlyContinue
}

#
# Create or update $PROFILE
#

Set-Content $PROFILE '$ErrorActionPreference = "Stop"'
Add-Content $PROFILE 'Import-Module Sontar.PowerShell.Profile'
