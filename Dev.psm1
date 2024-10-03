$ErrorActionPreference = 'Stop'

function New-DevModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Name
    )

    $dir = Join-Path $PSScriptRoot 'src' $Name
    New-Item -Path (Join-Path $dir "$($Name).psm1")

    $null = New-ModuleManifest `
        -Path (Join-Path $dir "$($Name).psd1")
        -RootModule "$Name.psm1" `
        -ModuleVersion "1.0.0" `
        -Description "The $Name module." `
        -Author "fkthat" `
        -Company "fkthat.net" `
        -Copyright "(c) fkthat.net, $(Get-Date -Format 'yyyy')" `
        -VariablesToExport @() `
        -CmdletsToExport @() `
        -FunctionsToExport @() `
        -AliasesToExport @() `
        -RequiredModules @() `
        -NestedModules @()
}

function Register-GitHubResourceRepository {
    Register-PSResourceRepository GitHub `
        -Uri "https://nuget.pkg.github.com/$env:GITHUB_REPOSITORY_OWNER/index.json"
}

function Get-DevModule {
    Join-Path $PSScriptRoot "src" |
        Get-ChildItem -Directory |
        Select-Object -ExpandProperty Name
}

function Get-PublishCredential {
    $password = ConvertTo-SecureString $env:GITHUB_TOKEN -AsPlainText -Force
    $credential = [pscredential]::new($env:GITHUB_REPOSITORY_OWNER, $password)
    return $credential
}

function Publish-DevModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Name,

        [Parameter(Mandatory)]
        [pscredential]
        $Credential
    )

    $modulePath = Join-Path $PSScriptRoot 'src' $Name
    Publish-PSResource -Path $modulePath -Repository GitHub -Credential $Credential
}
