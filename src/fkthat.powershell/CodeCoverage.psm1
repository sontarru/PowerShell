$ErrorActionPreference = "Stop"

if(-not (Get-Command reportgenerator -ErrorAction SilentlyContinue)) {
    return
}

function New-CodeCoverageReport {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]
        $OutDir
    )

    if(-not $OutDir) {
        $p = [System.IO.Path]
        $OutDir = Join-Path $p::GetTempPath() $p::GetRandomFileName()
    }

    $stderr = (reportgenerator -reports:**/coverage.* -targetdir:$OutDir -reporttypes:Html 2>&1)

    if($?) {
        Join-Path $OutDir 'index.html'
    }
    else {
        Write-Error $stderr
    }
}

Set-Alias nccr New-CodeCoverageReport
