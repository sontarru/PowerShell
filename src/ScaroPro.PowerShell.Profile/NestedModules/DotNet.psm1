$ErrorActionPreference = 'Stop'

$dotnet = $IsWindows ? "$env:ProgramFiles\dotnet\dotnet.exe" : (which dotnet)

if(Get-Command $dotnet -ErrorAction SilentlyContinue) {
    Set-Alias dotnet $dotnet

    Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
        dotnet complete --position $args[2] $args[1]
    }
}
