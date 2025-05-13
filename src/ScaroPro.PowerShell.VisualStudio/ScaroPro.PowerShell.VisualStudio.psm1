$ErrorActionPreference = "Stop"

if(-not $IsWindows) {
    Write-Error "The current platform '$($PSVersionTable.Platform)' is not supported."
}

$vs = "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"

if(-not (Get-Command $vs -ErrorAction SilentlyContinue)) {
    Write-Error "The executables '$vs' is not found."
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
        $sln = [System.Collections.Generic.HashSet[string]]::new()
    }

    process {
        $Path | Get-Item -ErrorAction SilentlyContinue | ForEach-Object {
            if($_ -is [System.IO.FileInfo] -and $_.Extension -eq '.sln') {
                $_
            }
            if($_ -is [System.IO.DirectoryInfo]) {
                Get-ChildItem $_ -File -Filter '*.sln' -Recurse:$Recurse
            }
        } | ForEach-Object { $null = $sln.Add($_.FullName) }
    }

    end {
        $sln.GetEnumerator() | ForEach-Object {
            & $vs $_
        }
    }
}

Set-Alias devenv $vs
Set-Alias savs Start-VisualStudio
