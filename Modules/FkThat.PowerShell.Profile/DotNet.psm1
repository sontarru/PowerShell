$ErrorActionPreference = 'Stop'

if(Get-Command dotnet -ErrorAction SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
        dotnet complete --position $args[2] $args[1]
    }
}
