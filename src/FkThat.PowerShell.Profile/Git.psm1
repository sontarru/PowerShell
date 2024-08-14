$ErrorActionPreference = 'Stop'

$git = Get-ApplicationPath Git

if(-not $git) {
    return
}

Import-Module Posh-Git -ErrorAction Continue

if($IsWindows) {
    Set-Alias git $git
}
