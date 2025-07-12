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
            Where-Object Name -ne 'Sontar.PowerShell.Develop'
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

begin {
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

    $srcdir = Join-Path $PSScriptRoot 'src'

    $moddir = @{}
}

process {
    $Name | ForEach-Object {
        Get-ChildItem $srcdir -Directory -Filter "Sontar.PowerShell.$_" |
        Where-Object Name -NE 'Sontar.PowerShell.Develop'
    } | ForEach-Object {
        $moddir[$_.Name] = $_
    }
}

end {
    $moddir.Values | ForEach-Object {
        Write-Host "Publishing $($_.Name)"
        $psd = Join-Path $_.FullName "$($_.Name).psd1"
        Publish-PSResource $psd -Repository GitHub -ApiKey $ApiKey -ErrorAction SilentlyContinue
        if(-not $?) { Write-Warning "$($Error[0])" }
    }
}
