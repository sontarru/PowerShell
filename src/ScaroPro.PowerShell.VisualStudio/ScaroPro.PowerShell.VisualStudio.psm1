$ErrorActionPreference = "Stop"

if(-not $IsWindows) {
    Write-Error "The '$($PSVersionTable.Platform)' platform is not supported."
}

$vs = "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"

if(-not (Get-Command $vs -ErrorAction SilentlyContinue)) {
    Write-Error "The '$vs' executable is not found."
}

function Start-VisualStudio {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Path = '.',

        [switch]
        $Recurse
    )

    begin {
        $paths = @{}
    }

    process {
        $Path | Get-Item -ErrorAction SilentlyContinue |
            ForEach-Object {
                if($_ -is [System.IO.FileInfo] -and $_.Extension -eq '.sln') {
                    $_
                }
                if($_ -is [System.IO.DirectoryInfo]) {
                    Get-ChildItem $_ -File -Filter '*.sln' -Recurse:$Recurse
                }
            } |
            ForEach-Object {
                $paths[$_.FullName] = $true
            }
    }

    end {
        $paths.Keys | ForEach-Object {
            & $vs $_
        }
    }
}

Set-Alias devenv $vs
Set-Alias vs $vs
Set-Alias savs Start-VisualStudio
