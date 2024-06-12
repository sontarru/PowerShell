<#
.SYNOPSIS
Publish to the GitHub repository modules from the 'src' folder.
#>
[CmdletBinding()]
param (
    [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [SupportsWildcards()]
    [ArgumentCompleter({
        $prefix = "Sontar.PowerShell"
        Join-Path $PSScriptRoot 'src' |
            Get-ChildItem -Directory -Filter "$prefix.$($args[2])*" |
            ForEach-Object { $_.Name.Substring($prefix.Length + 1) }

    })]
    [string[]]
    # The short name of the module.
    $Name = "*",

    [Parameter()]
    [string]
    # PSResource repository name.
    $Repository = 'GitHub',

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

            if(-not $SecretVault) {
                Write-Error 'Default secret vault is not found.'
            }
    }

    $secret = Get-Secret 'GitHub' -Vault $SecretVault
    $ApiKey = ConvertFrom-SecureString $secret.Password -AsPlainText
}

$prefix = "Sontar.PowerShell"
$moduleRoot = Join-Path $PSScriptRoot 'src'

foreach($modName in $Name) {
    $psd = Join-Path $moduleRoot "$prefix.$modName" "$prefix.$modName.psd1"
    $ver = (Get-Content $psd -Raw | Invoke-Expression).ModuleVersion

    if(-not (Find-PSResource "$prefix.$modName" -Version $ver -Repository GitHub -ErrorAction SilentlyContinue)) {
        Write-Host "Publishing $modName."
        Publish-PSResource $psd -Repository GitHub -ApiKey $ApiKey -ErrorAction Continue
    }
    else {
        Write-Host "Skipping $modName."
    }
}
