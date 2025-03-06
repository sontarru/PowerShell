$ErrorActionPreference = "Stop"

$rgen = $IsWindows ? "$env:USERPROFILE\.dotnet\tools\reportgenerator.exe" : (which reportgenerator)

if(-not (Test-Path $rgen -ErrorAction SilentlyContinue)) {
    Write-Error 'The reportgenerator tool is not available.'
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

    $stderr = (& $rgen -reports:**/coverage.* -targetdir:$OutDir -reporttypes:Html 2>&1)

    if($?) {
        Join-Path $OutDir 'index.html'
    }
    else {
        Write-Error ("", $stderr | Out-String)
    }
}

Set-Alias nccr New-CodeCoverageReport
