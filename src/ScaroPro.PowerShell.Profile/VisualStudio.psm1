$ErrorActionPreference = 'Stop'

if(-not $IsWindows) {
    return
}

$vs = "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"

if(-not (Test-Path $vs)) {
    return
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

Set-Alias savs Start-VisualStudio
