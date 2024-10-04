$ErrorActionPreference = 'Stop'

$ModulePrefix = 'fkthat.powershell'

function New-DevModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Name
    )

    $dir = Join-Path $PSScriptRoot 'src' $Name
    $null = New-Item -Path (Join-Path $dir "$($Name).psm1") -Force

    $null = New-ModuleManifest `
        -Path (Join-Path $dir "$($Name).psd1") `
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

function Set-GitHubResourceRepository {
    Set-PSResourceRepository GitHub `
        -Uri "https://nuget.pkg.github.com/$env:GITHUB_REPOSITORY_OWNER/index.json" `
        -Trusted
}

function _Get_DevModuleNames {
    Join-Path $PSScriptRoot 'src' |
        Get-ChildItem -Directory -Filter "$ModulePrefix.*" |
        Where { Join-Path $_ "$($_.Name).psd1" | Test-Path -PathType Leaf } |
        Select-Object -ExpandProperty Name |
        ForEach-Object { $_.Substring($ModulePrefix.Length +1) }
}

function Publish-DevModule {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string[]]
        $Name = '*'
    )

    begin {
        $names = _Get_DevModuleNames
    }

    process {
        $Name | ForEach-Object {
            $n = $_
            $names = $names | Where-Object { $_ -Like $n }
        }
    }

    end {
        Set-GitHubResourceRepository

        $password = ConvertTo-SecureString $env:GITHUB_TOKEN -AsPlainText -Force
        $credential = [pscredential]::new($env:GITHUB_REPOSITORY_OWNER, $password)

        $names | ForEach-Object {
            $p = Join-Path $PSScriptRoot 'src' "$ModulePrefix.$_"
            Publish-PSResource -Path $p -Repository GitHub -Credential $credential
        }
    }
}
