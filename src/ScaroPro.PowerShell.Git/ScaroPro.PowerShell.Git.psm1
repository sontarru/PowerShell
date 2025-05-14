$ErrorActionPreference = "Stop"

$git = $IsWindows ? "$env:ProgramFiles\Git\bin\git.exe" : (which git)

if(-not (Get-Command $git -ErrorAction SilentlyContinue)) {
    Write-Error "The '$git' executable is not found."
}

function Get-Git {
    $git
}
