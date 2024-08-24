$ErrorActionPreference = 'Stop'

if(Get-Command winget -ErrorAction SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
        winget complete --word $args[0] --commandline $args[1] --position $args[2]
    }
}
