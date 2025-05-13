#
# Customize the PowerShell prompt string.
#

$ErrorActionPreference = 'Stop'

$White = "`e[37m";
$Green = "`e[32m";
$Blue = "`e[34m";
$Red = "`e[31m";

$BlinkingBar = "`e[5 q"

$User = [System.Environment]::UserName
$Machine = [System.Environment]::MachineName

if($IsWindows) {
    $Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $Principal = New-Object Security.Principal.WindowsPrincipal $Identity
    $IsAdmin = $Principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
elseif($IsLinux) {
    $IsAdmin = ((id -u) -eq 0)
}

function Prompt {
    $h = [regex]::Escape($HOME)
    $s = [regex]::Escape([System.IO.Path]::DirectorySeparatorChar)
    $Dir = (Get-Location).Path -replace "^$h(?<tail>$s.*)?",'~${tail}'

    $Host.UI.RawUI.WindowTitle = $Dir

    return `
        $IsAdmin ?
            "${White}PS " +
            "${Red}${User}@${Machine}" +
            "${Red}:" +
            "${Red}${Dir}" +
            "${White}`# " +
            "${BlinkingBar}"
            :
            "${White}PS " +
            "${Green}${User}@${Machine}" +
            "${White}:" +
            "${Blue}${Dir}" +
            "${White}`$ " +
            "${BlinkingBar}"
}
