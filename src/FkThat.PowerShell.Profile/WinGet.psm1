$ErrorActionPreference = 'Stop'

$winget = Get-ApplicationPath winget

if(-not $winget) {
    return
}

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    & $winget complete --word $wordToComplete --commandline $commandAst --position $cursorPosition |
    ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

if($IsWindows) {
    Set-Alias winget $winget
}
