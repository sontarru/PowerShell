$ErrorActionPreference = 'Stop'

if(-not $IsWindows) {
    return
}

$winget = "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"

if(-not (Test-Path $winget)) {
    return
}

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    & $winget complete --word $wordToComplete --commandline $commandAst --position $cursorPosition |
    ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

Set-Alias winget $winget
