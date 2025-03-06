$ErrorActionPreference = 'Stop'

if(-not $IsWindows) {
    Write-Error 'Not supported platform.'
}

$winget = "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"

if(Test-Path $winget) {
    Set-Alias winget $winget

    Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
        winget complete --word $args[0] --commandline $args[1] --position $args[2]
    }
}
