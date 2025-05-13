$ErrorActionPreference = 'Stop'

function Get-DevelopmentModule {
    [CmdletBinding()]
    param ()

    $options = Get-DevelopmentOptions
    $rootPath = $options.RootPath
    $moduleNamePrefix = $options.ModuleNamePrefix
    $srcPath = Join-Path $rootPath 'src'

    Get-ChildItem $srcPath -Directory -Filter "$moduleNamePrefix.*" |
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
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $ShortName,

        [Parameter()]
        [string]
        $Version,

        [switch]
        $Optimize
    )

    begin {
        $options = Get-DevelopmentOptions
        $srcPath = Join-Path $options.RootPath "src"
        $namePrefix = $options.ModuleNamePrefix
    }

    process {
        foreach($name in $ShortName) {
            $fullName = "$namePrefix.$name"
            $modulePath = Join-Path $srcPath $fullName
            $manifestPath = Join-Path $modulePath "$fullName.psd1"
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
                $updateManifestArgs.NestedModules =
                    Get-ChildItem $nestedModulesPath -File -Filter "*.psm1" |
                        ForEach-Object {
                            $modulesToScan += $_.FullName
                            "NestedModules/$($_.Name)"
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
            Update-ModuleManifest @updateManifestArgs

            # Clean up the module manifest
            if($Optimize) {
                Optimize-DevelopmentModuleManifest -Path $manifestPath
            }
        }
    }
}

[System.FlagsAttribute()]
Enum OptimizeDevelopmentModuleOptions {
    None = 0
    Comments = 1
    EmptyLines = 2
    All = 3
}

function Optimize-DevelopmentModuleManifest {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName,
            ParameterSetName = "ByShortName")]
        [string[]]
        $ShortName,

        [Parameter(Mandatory, ParameterSetName = "ByPath")]
        [string[]]
        $Path
    )

    begin {
        if($Path) {
            $Path | ForEach-Object {
                $tmpManifest = New-TemporaryFile

                Get-Content $_ | ForEach-Object {
                    if(($_ -notmatch '^\s*$') -and ($_ -notmatch '^\s*#')) { $_ }
                } | Out-File $tmpManifest

                Move-Item $tmpManifest $_ -Force
            }
        }

        $manifests = @{}
    }

    process {
        $ShortName | ForEach-Object {
            Get-DevelopmentModule $_
        } | ForEach-Object {
            $manifests[$_.ShortName] = $manifests.ManifestPath
        }
    }

    end {
        $manifests.Values | ForEach-Object {
            Optimize-DevelopmentModuleManifest -Path $_
        }
    }
}
