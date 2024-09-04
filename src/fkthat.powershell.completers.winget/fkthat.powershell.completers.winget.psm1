$ErrorActionPreference = 'Stop'

if($IsWindows) {
    $winget = "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"

    if(Test-Path $winget) {
        Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
            & $winget complete --word $args[0] --commandline $args[1] --position $args[2]
        }
    }
}
