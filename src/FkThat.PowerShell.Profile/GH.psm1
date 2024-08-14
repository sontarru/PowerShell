$ErrorActionPreference = 'Stop'

$gh = Get-ApplicationPath 'gh'

if(-not $gh) {
    return
}

& $gh completion -s powershell | Out-String | Invoke-Expression

if($IsWindows) {
    Set-Alias gh $gh
}
