$ErrorActionPreference = 'Stop'

if(-not $IsWindows) { return }

$aliases = @{
    '7z'    = "$env:ProgramFiles\7-zip\7z.exe"
    code    = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"
    docker  = "$env:ProgramFiles\Docker\Docker\resources\bin\docker.exe"
    ffmpeg  = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\ffmpeg.exe"
    gdiff   = "$env:ProgramFiles\Git\usr\bin\diff.exe"
    gh      = "$env:ProgramFiles\GitHub CLI\gh.exe"
    less    = "$env:ProgramFiles\Git\usr\bin\less.exe"
    node    = "$env:ProgramFiles\nodejs\node.exe"
    npm     = "$env:ProgramFiles\nodejs\npm.cmd"
    nvim    = "$env:ProgramFiles\Neovim\bin\nvim.exe"
    nvm     = "$env:APPDATA\nvm\nvm.exe"
    procexp = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\procexp.exe"
    qemu    = "$env:ProgramFiles\qemu\qemu-system-x86_64.exe"
    scp     = "$env:SystemRoot\System32\OpenSSH\scp.exe"
    ssh     = "$env:SystemRoot\System32\OpenSSH\ssh.exe"
    sudo    = "$env:ProgramFiles\gsudo\Current\gsudo.exe"
    tar     = "$env:ProgramFiles\Git\usr\bin\tar.exe"
    vbman   = "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe"
    vs      = "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
    winget  = "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"
}

$aliases.Keys |  ForEach-Object {
    if(Test-Path $aliases[$_]) {
        Set-Alias $_ $aliases[$_]
    }
}
