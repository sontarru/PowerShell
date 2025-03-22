<#
.SYNOPSIS
Publish to the GitHub repository all modules in the 'Modules' folder with a version greater than
currently published.
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory, ParameterSetName = 'PlainApiKey')]
    [string]
    # Plain API key (Primary Access Token).
    $ApiKey,

    [Parameter(ParameterSetName = 'Secret')]
    [string]
    # Secret key name.
    $SecretName = 'GitHub',

    [Parameter(ParameterSetName = 'Secret')]
    [string]
    # Secret vault name.
    $SecretVault
)

$ErrorActionPreference = 'Stop'

if(-not $ApiKey) {
    if(-not $SecretVault) {
        $SecretVault = Get-SecretVault |
            Where-Object IsDefault |
            Select-Object -ExpandProperty Name
    }

    $secret = Get-Secret 'GitHub' -Vault $SecretVault
    $ApiKey = ConvertFrom-SecureString $secret.Password -AsPlainText
}

$moduleRoot = Join-Path $PSScriptRoot '..' 'Modules'

foreach($mod in (Get-ChildItem $moduleRoot)) {
    $psd = Join-Path $mod "$($mod.Name).psd1"
    $ver = (Get-Content $psd -Raw | Invoke-Expression).ModuleVersion

    if(-not (Find-PSResource $mod.Name -Version $ver -Repository GitHub -ErrorAction SilentlyContinue)) {
        Write-Host "Publish $($mod.Name)."
        Publish-PSResource $mod -Repository GitHub -ApiKey $ApiKey -ErrorAction Continue
    }
    else {
        Write-Host "Skip $($mod.Name)."
    }
}
