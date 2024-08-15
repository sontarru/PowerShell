$ErrorActionPreference = 'Stop'

if(-not $IsWindows) {
    return
}

$aliases = @{
    code   = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"
    vs     = "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
    node   = "$env:ProgramFiles\nodejs\node.exe"
    npm    = "$env:ProgramFiles\nodejs\npm.ps1"
}

$aliases.Keys | ForEach-Object {
    if(Test-Path $aliases[$_]) {
        Set-Alias $_ $aliases[$_]
    }
}
