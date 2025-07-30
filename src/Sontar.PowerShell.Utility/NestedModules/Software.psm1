$ErrorActionPreference = 'Stop'

function Get-Gsudo {
    Assert-Windows
    $gsudo  = "$env:ProgramFiles\gsudo\Current\gsudo.exe"
    Assert-Command $gsudo
    return $gsudo
}

function Get-Winget {
    Assert-Windows
    $winget =  "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"
    Assert-Command $winget
    return $winget
}

function Update-Software {
    [CmdletBinding()]
    param (
        [switch]
        $ShowOnly
    )

    Assert-Windows

    $winget = Get-Winget

    if($ShowOnly) {
        & $winget upgrade
        return
    }

    $gsudo = Get-Gsudo

    & $gsudo $winget upgrade --all --silent `
        --accept-source-agreements `
        --accept-package-agreements
}
