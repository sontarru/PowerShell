$ErrorActionPreference = 'Stop'

$dotnet = $IsWindows ? "$env:ProgramFiles\dotnet\dotnet.exe" : (which dotnet)

if(Test-Path $dotnet -ErrorAction SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
        & $dotnet complete --position $args[2] $args[1]
    }
}
