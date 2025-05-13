$ErrorActionPreference = 'Stop'

$DevelopmentOptions =  @{
    RootPath = Join-Path ($IsWindows ? $env:USERPROFILE : $env:HOME) `
        'Projects' 'ScaroPro' 'PowerShell'

    ModuleNamePrefix = 'ScaroPro.PowerShell'

    Author = "Scaro.Pro"
    CompanyName = "Scaro.Pro"
    Copyright = "(c) Scaro.Pro, 2025"
}

function Get-DevelopmentOptions {
    [CmdletBinding()]
    param ()
    [pscustomobject]$DevelopmentOptions
}

Export-ModuleMember -Function Get-DevelopmentOptions
