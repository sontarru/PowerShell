$ErrorActionPreference = 'Stop'

if(-not $IsWindows) {
    return
}

$aliases = @{
    '7z'   = "$env:ProgramFiles\7-zip\7z.exe"
    code   = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"
    ffmpeg = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\ffmpeg.exe"
    gdiff  = "$env:ProgramFiles\Git\usr\bin\diff.exe"
    less   = "$env:ProgramFiles\Git\usr\bin\less.exe"
    nvim   = "$env:ProgramFiles\Neovim\bin\nvim.exe"
    scp    = "$env:SystemRoot\System32\OpenSSH\scp.exe"
    ssh    = "$env:SystemRoot\System32\OpenSSH\ssh.exe"
    sudo   = "$env:ProgramFiles\gsudo\Current\gsudo.exe"
    tar    = "$env:ProgramFiles\Git\usr\bin\tar.exe"
    vbman  = "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe"
    vs     = "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
    node   = "$env:ProgramFiles\nodejs\node.exe"
    npm    = "$env:ProgramFiles\nodejs\npm.cmd"
    nvm    = "$env:APPDATA\nvm\nvm.exe"
    winget = "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"
    gh     = "$env:ProgramFiles\GitHub CLI\gh.exe"
    docker = "$env:ProgramFiles\Docker\Docker\resources\bin\docker.exe"
}

$aliases.Keys |  ForEach-Object {
    if(Test-Path $aliases[$_]) {
        Set-Alias $_ $aliases[$_]
    }
}
