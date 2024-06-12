$ErrorActionPreference = 'Stop'

$dotnet = $IsWindows ? "$env:ProgramFiles\dotnet\dotnet.exe" : (which dotnet)

if(-not $dotnet -or -not (Test-Path $dotnet)) {
    return
}

Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    dotnet complete --position $args[2] $args[1]
}

Set-Alias dotnet $dotnet
