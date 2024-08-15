$ErrorActionPreference = "Stop"

$reportgenerator = switch($PSVersionTable.Platform) {
    "Win32NT" { "$env:USERPROFILE\.dotnet\tools\reportgenerator.exe" }
    "Unix" { which reportgenerator }
}

if(-not $reportgenerator -or -not (Test-Path $reportgenerator)) {
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
        $OutDir = Join-Path $p::GetTempPath() `
            $p::GetRandomFileName()
    }

    $log = (& $reportgenerator -reports:**/coverage.* `
        -targetdir:$OutDir -reporttypes:Html 2>&1)

    if($?) {
        $index = Join-Path $OutDir 'index.html'
        Write-Output $index
    }
    else {
        Write-Error $log
    }
}

Set-Alias nccr New-CodeCoverageReport
