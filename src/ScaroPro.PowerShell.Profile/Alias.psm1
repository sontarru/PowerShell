$ErrorActionPreference = 'Stop'

if(-not $IsWindows) {
    return
}

@{
    '7z'    = "$env:ProgramFiles\7-zip\7z.exe"
    code    = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"
    ffmpeg  = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\ffmpeg.exe"
    gdiff   = "$env:ProgramFiles\Git\usr\bin\diff.exe"
    gsudo   = "$env:ProgramFiles\gsudo\Current\gsudo.exe"
    sudo   = "$env:ProgramFiles\gsudo\Current\gsudo.exe"
    less    = "$env:ProgramFiles\Git\usr\bin\less.exe"
    lua     = "$env:LOCALAPPDATA\Programs\Lua\bin\lua.exe"
    nvim    = "$env:ProgramFiles\Neovim\bin\nvim.exe"
    procexp = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\procexp.exe"
    scp     = "$env:SystemRoot\System32\OpenSSH\scp.exe"
    ssh     = "$env:SystemRoot\System32\OpenSSH\ssh.exe"
    tar     = "$env:ProgramFiles\Git\usr\bin\tar.exe"
    vbman   = "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe"
    vs      = "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
}.GetEnumerator() | ForEach-Object {
    if(Test-Path $_.Value) {
        Set-Alias $_.Key $_.Value
    }
}
