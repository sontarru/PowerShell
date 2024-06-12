$ErrorActionPreference = 'Stop'

if(-not $IsWindows) {
    return
}

$winget =  "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"

if(-not (Test-Path $winget)) {
    return
}

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    winget complete --word $args[0] --commandline $args[1] --position $args[2]
}

Set-Alias winget $winget
