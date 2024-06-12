$ErrorActionPreference = 'Stop'

<#
.SYNOPSIS
Removes comments and emty lines from the manifest file.
#>
function Optimize-Manifest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string[]]
        $Path
    )

    begin {
        $paths = @{}
    }

    process {
        $Path | Get-Item -Filter '*.psd1' -ErrorAction SilentlyContinue |
            Where-Object { $_ -is [System.IO.FileInfo] } |
            Select-Object -ExpandProperty FullName |
            ForEach-Object { $paths.Add($_, $true) }
    }

    end {
        $paths.Keys | ForEach-Object {
            $tmp = New-TemporaryFile

            Get-Content $_ | Where-Object {
                ($_ -notmatch '^\s*$') -and ($_ -notmatch '^\s*#')
            } | Out-File $tmp

            Move-Item $tmp $_ -Force
        }
    }
}

<#
.SYNOPSIS
1. Sets RootModule if required.
2. Adds all NestedModules.
3. Scans all modules for functions and aliases and sets coresponding Exports.
#>
function Update-Manifest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string[]]
        $Path,

        [Parameter()]
        [string]
        $Version,

        [switch]
        $Optimize
    )

    begin {
        $paths = @{}
    }

    process {
        $Path | Get-Item -Filter '*.psd1' -ErrorAction SilentlyContinue |
            Where-Object { $_ -is [System.IO.FileInfo] } |
            Select-Object -ExpandProperty FullName |
            ForEach-Object { $paths.Add($_, $true) }
    }

    end {
        $paths.Keys | ForEach-Object {
            $psd = $_

            $rootModule = [System.IO.Path]::ChangeExtension($psd, '.psm1')

            if(-not (Test-Path $rootModule -PathType Leaf)) {
                $rootModule = $null
            }

            $nestedModules = Join-Path (Split-Path $psd -Parent) 'NestedModules' |
                Get-ChildItem -File -Filter '*.psm1' -ErrorAction SilentlyContinue |
                Select-Object -ExpandProperty FullName

            if(-not $nestedModules) {
                $nestedModules = @()
            }

            $allModules = @()

            if($rootModule) {
                $allModules += $rootModule
            }

            if($nestedModules) {
                $allModules += $nestedModules
            }

            $functionsToExport = @()
            $aliasesToExport = @()

            $allModules | ForEach-Object {
                pwsh { Import-Module $args[0] -PassThru -ErrorAction SilentlyContinue } -args $_ |
                    ForEach-Object {
                        $functionsToExport += $_.ExportedFunctions.Keys
                        $aliasesToExport += $_.ExportedAliases.Keys
                    }
            }

            $umm = @{
                Path = $psd
                NestedModules = @()
                FunctionsToExport = $functionsToExport
                AliasesToExport = $aliasesToExport
            }

            if($rootModule) {
                $umm.RootModule = Split-Path $rootModule -Leaf
            }

            if($nestedModules) {
                $umm.NestedModules = Split-Path $nestedModules -Leaf |
                    ForEach-Object { "NestedModules\$_" }
            }

            if($Version) {
                $umm.ModuleVersion = $Version
            }

            Update-PSModuleManifest @umm

            if($Optimize) {
                Optimize-Manifest $psd
            }
        }
    }
}
