$ErrorActionPreference = 'Stop'

$gh = $IsWindows ? "$env:ProgramFiles\GitHub CLI\gh.exe" : (which gh)

if(Test-Path $gh -ErrorAction SilentlyContinue) {
    $script:CompleterRegistered = $false

    if(-not $script:CompleterRegistered) {
        & $gh completion -s powershell | Out-String | Invoke-Expression
        $script:CompleterRegistered = $true
    }
}
