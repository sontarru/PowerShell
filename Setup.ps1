[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $ApiKey
)

Install-PSResource `
    'Posh-Git',
    'DockerCompletion' `
    # -Reinstall

Set-PSResourceRepository GitHub `
    -Uri "https://nuget.pkg.github.com/fkthat/index.json" `
    -Trusted

$password = ConvertTo-SecureString $ApiKey -AsPlainText -Force
$credential = [pscredential]::new("fkthat", $password)

Install-PSResource `
    'FkThat.PowerShell.PSReadLine',
    'FkThat.PowerShell.Prompt' `
    -Repository GitHub `
    -Credential $credential `
    -Reinstall `
    -WarningAction SilentlyContinue

Copy-Item (Join-Path $PSScriptRoot "Profile.ps1") $PROFILE
