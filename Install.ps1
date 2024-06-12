<#
.SYNOPSIS
Installs modules (PSResources) from the PSGallery and GitHub repositories depending on
the current platform (Windows or Linux) and environment (other application installed).
#>
function InstallFromPSGallery($Name) {
    Write-Host "Installing $Name"
    Install-PSResource $Name -Repository PSGallery -Reinstall
}

function InstallFromGitHub([string[]] $Name) {
    foreach($n in $Name) {
        Write-Host "Installing $n"
        Install-PSResource $n -Repository GitHub `
            -Reinstall -WarningAction SilentlyContinue
    }
}

$moduleRoot = $IsWindows ?
    "$env:USERPROFILE\Documents\PowerShell\Modules" :
    "$env:HOME/.local/share/powershell/Modules"

foreach($moduleDir in (Get-ChildItem $moduleRoot -Filter "Sontar.PowerShell.*")) {
    Rename-Item $moduleDir $moduleDir.Name.ToLowerInvariant() -ErrorAction SilentlyContinue
}

InstallFromGitHub "Sontar.PowerShell.Profile",
    "Sontar.PowerShell.Utility"

if(Get-Command git -ErrorAction SilentlyContinue) {
    InstallFromPSGallery "Posh-Git"
}

$docker = $IsWindows ?
    "$env:ProgramFiles\Docker\Docker\resources\bin\docker.exe" :
    (which docker)

if(Test-Path $docker -ErrorAction SilentlyContinue) {
    InstallFromPSGallery "DockerCompletion"
}

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

# Create or update $PROFILE
Set-Content $PROFILE '$ErrorActionPreference = "Stop"'
Add-Content $PROFILE 'Import-Module Sontar.PowerShell.Profile'
