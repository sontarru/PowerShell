$ErrorActionPreference = "Stop"

if($IsWindows) {
    @{
        '7z'   = "$env:ProgramFiles\7-zip\7z.exe"
        ffmpeg = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\ffmpeg.exe"
        gdiff  = "$env:ProgramFiles\Git\usr\bin\diff.exe"
        gsudo  = "$env:ProgramFiles\gsudo\Current\gsudo.exe"
        less   = "$env:ProgramFiles\Git\usr\bin\less.exe"
        lua    = "$env:LOCALAPPDATA\Programs\Lua\bin\lua.exe"
        nvim   = "$env:ProgramFiles\Neovim\bin\nvim.exe"
        psxp   = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\procexp64.exe"
        scp    = "$env:SystemRoot\System32\OpenSSH\scp.exe"
        ssh    = "$env:SystemRoot\System32\OpenSSH\ssh.exe"
        tar    = "$env:ProgramFiles\Git\usr\bin\tar.exe"
        vbman  = "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe"
        code   = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"
        vs     =  "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
        devenv =  "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
    }.GetEnumerator() | ForEach-Object {
        Set-Alias $_.Key $_.Value
    }
}
