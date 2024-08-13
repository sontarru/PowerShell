$ErrorActionPreference = 'Stop'

if($IsWindows) {
    $gh = "$env:ProgramFiles\GitHub CLI\gh.exe"
    if(Test-Path $gh) { Set-Alias gh $gh }
}

if(-not $gh -or -not (Test-Path $gh)) {
    return
}

if(Get-Command gh -ErrorAction SilentlyContinue) {
    gh completion -s powershell | Out-String | Invoke-Expression
}
