$ErrorActionPreference = 'Stop'

function Get-DevelopmentModule {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [ArgumentCompleter({
            Get-DevelopmentModule "$($args[2])*" |
                Select-Object -ExpandProperty ShortName
        })]
        [string[]]
        $ShortName
    )

    begin {
        $options = Get-DevelopmentOptions
        $rootPath = $options.RootPath
        $moduleNamePrefix = $options.ModuleNamePrefix
        $srcPath = Join-Path $rootPath 'src'

        $all = Get-ChildItem $srcPath -Directory -Filter "$moduleNamePrefix.*" |
            Where-Object { Join-Path $_.FullName "$($_.Name).psd1" | Test-Path -PathType Leaf } |
            ForEach-Object {
                [PSCustomObject]@{
                    Name = $_.Name
                    ShortName = $_.Name.Substring($moduleNamePrefix.Length + 1)
                    Path = $_.FullName
                    ManifestPath = (Join-Path $_.FullName "$($_.Name).psd1")
                }
            }
    }

    process {
        $ShortName | ForEach-Object {
            $all = $all | Where-Object ShortName -Like $_
        }
    }

    end {
        $all
    }
}

function New-DevelopmentModule {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $ShortName,

        [switch]
        $AddRootModule,

        [switch]
        $Optimize,

        [switch]
        $Force
    )

    begin {
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = 'None'
        }

        $options = Get-DevelopmentOptions
        $rootPath = $options.RootPath
        $srcPath = Join-Path $rootPath "src"
        $namePrefix = $options.ModuleNamePrefix
    }

    process {
        foreach($name in $ShortName) {
            $fullName = "$namePrefix.$name"
            $moduleRootPath = Join-Path $srcPath $fullName
            $manifestPath = Join-Path $moduleRootPath "$fullName.psd1"
            $rootModuleName = "$fullName.psm1"
            $rootModulePath = Join-Path $moduleRootPath $rootModuleName

            # If a file exists at the $moduleRootPath then remove it.
            if (Test-Path $moduleRootPath -PathType Leaf) {
                Remove-Item $moduleRootPath
            }

            # Create the directory for the module if required.
            if(-not (Test-Path $moduleRootPath -PathType Any)) {
                New-Item $moduleRootPath -ItemType Directory -Force
            }

            # Clean the space for the module manifest.
            if (Test-Path $manifestPath -PathType Any) {
                Remove-Item $manifestPath -Recurse
            }

            # Handle the root module
            if($AddRootModule) {
                # If the directory exists at $rootModulePath then remove it.
                if(Test-Path $rootModulePath -PathType Container) {
                    Remove-Item $rootModulePath -Recurse
                }
                # If no existing *.psm1 file then create it.
                if(-not (Test-Path $rootModulePath)) {
                    Set-Content $rootModulePath '$ErrorActionPreference = "Stop"'
                }
            }

            $newNoduleManifestArgs = @{
                Path = $manifestPath
                ModuleVersion = "1.0.0"
                Author = $options.Author
                CompanyName = $options.CompanyName
                Copyright = $options.Copyright
                Description = "The $name module."
                FunctionsToExport = @()
                CmdletsToExport = @()
                VariablesToExport = @()
                AliasesToExport = @()
            }

            if($AddRootModule) {
                $newNoduleManifestArgs.RootModule = $rootModuleName
            }

            New-ModuleManifest @newNoduleManifestArgs

            # Clean up the module manifest
            if($Optimize) {
                Optimize-DevelopmentModuleManifest -Path $manifestPath
            }
        }
    }
}

function Update-DevelopmentModuleManifest {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [ArgumentCompleter({
            Get-DevelopmentModule "$($args[2])*" |
                Select-Object -ExpandProperty ShortName
        })]
        [string[]]
        $ShortName,

        [Parameter()]
        [string]
        $Version,

        [switch]
        $Optimize,

        [switch]
        $Force
    )

    begin {
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = 'None'
        }

        $modules = @{}
    }

    process {
        Get-DevelopmentModule $ShortName |
            ForEach-Object { $modules[$_.ShortName] = $_ }
    }

    end {
        foreach($module in $modules.Values) {
            $fullName = $module.Name
            $modulePath = $module.Path
            $manifestPath = $module.ManifestPath
            $rootModuleName = "$fullName.psm1"
            $rootModulePath = Join-Path $modulePath $rootModuleName
            $nestedModulesPath = Join-Path $modulePath "NestedModules"

            if(-not (Test-Path $modulePath -PathType Container) -or `
               -not (Test-Path $manifestPath -PathType Leaf)) {
                continue
            }

            $updateManifestArgs = @{
                Path = $manifestPath
                NestedModules = @()
                FunctionsToExport = @()
                AliasesToExport = @()
                VariablesToExport = @()
                CmdletsToExport = @()
            }

            # Add version
            if($Version) {
                $updateManifestArgs.ModuleVersion = $Version
            }

            # *.psm1 files to scan for functions and aliases.
            $modulesToScan = @()

            # Fill root module value.
            if(Test-Path $rootModulePath -PathType Leaf) {
                $modulesToScan += $rootModulePath
                $updateManifestArgs.RootModule = $rootModuleName
            }

            # Fill nested modules.
            if(Test-Path $nestedModulesPath -PathType Container) {
                Get-ChildItem $nestedModulesPath -File -Filter "*.psm1" |
                    ForEach-Object {
                        $modulesToScan += $_.FullName
                        $updateManifestArgs.NestedModules += "NestedModules/$($_.Name)"
                    }
            }

            # Fill functions and aliases to export
            $modulesToScan | ForEach-Object {
                pwsh { Import-Module $args[0] -PassThru -ErrorAction SilentlyContinue } -args $_ |
                    ForEach-Object {
                        $updateManifestArgs.FunctionsToExport += $_.ExportedFunctions.Keys
                        $updateManifestArgs.AliasesToExport += $_.ExportedAliases.Keys
                    }
            }

            # Do update
            Update-PSModuleManifest @updateManifestArgs

            # Clean up the module manifest
            if($Optimize) {
                Optimize-DevelopmentModuleManifest -Path $manifestPath -Force:$Force
            }
        }
    }
}

<#
.SYNOPSIS
Removes empty lines and comments from the module manifest file.
#>
function Optimize-DevelopmentModuleManifest {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName,
            ParameterSetName = "ByShortName")]
        [SupportsWildcards()]
        [ArgumentCompleter({
            Get-DevelopmentModule "$($args[2])*" |
                Select-Object -ExpandProperty ShortName
        })]
        [string[]]
        $ShortName,

        [Parameter(Mandatory, ParameterSetName = "ByPath")]
        [string[]]
        $Path,

        [switch]
        $Force
    )

    begin {
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = 'None'
        }

        $manifestPaths = @{}

        if($Path) {
            $Path | Get-Item -Filter "*.psd1" -ErrorAction SilentlyContinue |
                ForEach-Object { $manifestPaths[$_.FullName] = $true }
        }
    }

    process {
        $ShortName | ForEach-Object { Get-DevelopmentModule $_ } |
            ForEach-Object { $manifestPahts[$_.ManifestPath] = $true }
    }

    end {
        $manifestPaths.Keys | ForEach-Object {
            (Get-Content $_ | ForEach-Object {
                if(($_ -notmatch '^\s*$') -and ($_ -notmatch '^\s*#')) {
                    $_ -replace '#.*$',''
                }
            }) | Set-Content -Path $_
        }
    }
}
