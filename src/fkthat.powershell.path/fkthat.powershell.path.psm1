$ErrorActionPreference = 'Stop'

if(-not $IsWindows) { return }

function Reset-Path {
    param
    Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' `
        'PATH' `
        '%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem' `
        -Type ExpandString

    Set-ItemProperty 'HKCU:\Environment' `
        'PATH' `
        '%ProgramFiles%\Git\bin;%ProgramFiles%\dotnet;%USERPROFILE%\.dotnet\tools' `
        -Type ExpandString
}

Set-Alias rspath Reset-Path
