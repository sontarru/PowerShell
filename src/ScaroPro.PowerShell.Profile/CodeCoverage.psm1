$ErrorActionPreference = "Stop"

$rgen = $IsWindows ? "$env:USERPROFILE\.dotnet\tools\reportgenerator.exe" : (which reportgenerator)

if(-not $rgen -or -not (Test-Path $rgen -ErrorAction SilentlyContinue)) {
    return
}

function New-CodeCoverageReport {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]
        $OutDir,

        [switch]
        $Show
    )

    if(-not $OutDir) {
        $p = [System.IO.Path]
        $OutDir = Join-Path $p::GetTempPath() $p::GetRandomFileName()
    }

    $stderr = (& $rgen -reports:**/coverage.* -targetdir:$OutDir -reporttypes:Html 2>&1)

    if($?) {
        $indexhtnl = Join-Path $OutDir 'index.html'

        if($Show) {
            Invoke-Item $indexhtnl
        }
        else {
            Write-Output $indexhtnl
        }

    }
    else {
        Write-Error ("", $stderr | Out-String)
    }
}

Set-Alias nccr New-CodeCoverageReport
