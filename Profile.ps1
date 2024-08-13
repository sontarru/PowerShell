$ErrorActionPreference = 'Stop'

if(Get-Command git -ErrorAction SilentlyContinue) {
    Import-Module Posh-Git -ErrorAction Continue
}

Import-Module FkThat.PowerShell.Profile
