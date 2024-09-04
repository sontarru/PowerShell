$ErrorActionPreference = 'Stop'

$git = $IsWindows ? "$env:ProgramFiles\Git\bin\git.exe" : (which git)

if(Test-Path $git -ErrorAction SilentlyContinue) {
    $script:CompleterRegistered = $false

    Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
        if(-not $script:CompleterRegistered) {
            Import-Module posh-git
            $script:CompleterRegistered = $true
        }
    }
}
