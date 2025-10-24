$ErrorActionPreference = 'Stop'

Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    dotnet complete --position $args[2] $args[1]
}
