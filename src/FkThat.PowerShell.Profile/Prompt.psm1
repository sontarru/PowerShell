$ErrorActionPreference = 'Stop'

$White = "`e[37m";
$Green = "`e[32m";
$Blue = "`e[34m";
$Red = "`e[31m";
$User = [System.Environment]::UserName
$Machine = [System.Environment]::MachineName

function Prompt {
    $h = [regex]::Escape($HOME)
    $s = [regex]::Escape([System.IO.Path]::DirectorySeparatorChar)
    $Dir = (Get-Location).Path -replace "^$h(?<tail>$s.*)?",'~${tail}'

    $Host.UI.RawUI.WindowTitle = $Dir

    return `
        (Test-Admin) ?
            "${White}PS " +
            "${Red}${User}@${Machine}" +
            "${Red}:" +
            "${Red}${Dir}" +
            "${White}`# " `
            :
            "${White}PS " +
            "${Green}${User}@${Machine}" +
            "${White}:" +
            "${Blue}${Dir}" +
            "${White}`$ "
}
