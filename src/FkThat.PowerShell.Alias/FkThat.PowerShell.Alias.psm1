$ErrorActionPreference = 'Stop'

if(-not $IsWindows) {
    return
}

$aliases = @{
    scp    = "$env:SystemRoot\System32\OpenSSH\scp.exe"
    ssh    = "$env:SystemRoot\System32\OpenSSH\ssh.exe"
    '7z'   = "$env:ProgramFiles\7-zip\7z.exe"
    gdiff  = "$env:ProgramFiles\Git\usr\bin\diff.exe"
    less   = "$env:ProgramFiles\Git\usr\bin\less.exe"
    nvim   = "$env:ProgramFiles\Neovim\bin\nvim.exe"
    sudo   = "$env:ProgramFiles\gsudo\Current\gsudo.exe"
    tar    = "$env:ProgramFiles\Git\usr\bin\tar.exe"
    vbman  = "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe"
    ffmpeg = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\ffmpeg.exe"
}

$aliases.Keys | ForEach-Object {
    if(Test-Path $aliases[$_]) {
        Set-Alias $_ $aliases[$_]
    }
}

