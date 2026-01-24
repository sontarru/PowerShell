$ErrorActionPreference = "Stop"

<#
Starts Visual Studio and open the specified solution file(s).
#>
function Start-VisualStudio {
    [CmdletBinding()]
    param (
        # Path to look for solution files.
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Path = '.',

        # Lookup subdirectories recursively.
        [switch]
        $Recurse,

        # Open Visual Studio without any solution even if no one was found.
        [switch]
        $Force
    )

    begin {
        $paths = @{}
    }

    process {
        $Path | Get-Item -ErrorAction SilentlyContinue |
            ForEach-Object {
                if($_ -is [System.IO.FileInfo] -and $_.Extension -in '.sln','.slnx') {
                    $_
                }
                if($_ -is [System.IO.DirectoryInfo]) {
                    Get-ChildItem $_ -File -Filter '*.sln' -Recurse:$Recurse
                    Get-ChildItem $_ -File -Filter '*.slnx' -Recurse:$Recurse
                }
            } |
            ForEach-Object {
                $paths[$_.FullName] = $true
            }
    }

    end {
        $StartProcessArgs = @{
            FilePath = "devenv.exe"
            Environment  = @{ PATH = "$env:ProgramFiles\dotnet" }
        }

        if($paths.Keys.Count) {
            $paths.Keys | ForEach-Object {
                $StartProcessArgs.ArgumentList = @($_)
                Start-Process @StartProcessArgs
            }
        }
        elseif ($Force) {
            Start-Process @StartProcessArgs
        }
    }
}

Set-Alias savs Start-VisualStudio
