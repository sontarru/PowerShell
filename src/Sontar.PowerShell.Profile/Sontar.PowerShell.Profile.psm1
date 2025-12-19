$ErrorActionPreference = 'Stop'

<#
.SYNOPSIS
Gets the console cursor escape sequences.
#>
function Get-CursorEscapeSequence {
    [PSCustomObject]@{
        BlinkingBar = "`e[5 q"
        BlinkingBlock = "`e[1 q"
    }
}

<#
.SYNOPSIS
Gets the console color escape sequences.
#>
function Get-ColorEscapeSequence {
    [PSCustomObject]@{
        White = "`e[37m";
        Green = "`e[32m";
        Blue = "`e[34m";
        Red = "`e[31m";
    }
}

<#
.SYNOPSIS
Gets system environment info.
#>
function Get-SystemEnvironment {
    [PSCustomObject]@{
        User = [System.Environment]::UserName
        Machine = [System.Environment]::MachineName
    }
}

<#
.SYNOPSIS
Tests the current user has admin priveleges.
#>
function Test-AdminUser {
    if($null -eq $Script:IsAdminUser) {
        switch ($PSVersionTable.Platform) {
            'Win32NT' {
                $Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
                $Principal = New-Object Security.Principal.WindowsPrincipal $Identity
                $Script:IsAdminUser = $Principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
            }
            'Linux' {
                $Script:IsAdminUser = ((id -u) -eq 0)
            }
            Default { Write-Error 'Unknown platform.' }
        }
    }

    return $Script:IsAdminUser
}

#
# Customize the PowerShell prompt string.
#

function Prompt {
    $h = [regex]::Escape($HOME)
    $s = [regex]::Escape([System.IO.Path]::DirectorySeparatorChar)
    $Dir = (Get-Location).Path -replace "^$h(?<tail>$s.*)?",'~${tail}'

    $Host.UI.RawUI.WindowTitle = $Dir

    $c = Get-ColorEscapeSequence
    $e = Get-SystemEnvironment
    $cur = (Get-CursorEscapeSequence).BlinkingBar

    ((Test-AdminUser) `
        ? "$($c.White)PS " +
          "$($c.Red)$($e.User)@$($e.Machine)" +
          "$($c.Red):" +
          "$($c.Red)$Dir" +
          "$($c.White)`# "
        : "$($c.White)PS " +
          "$($c.Green)$($e.User)@$($e.Machine)" +
          "$($c.White):" +
          "$($c.Blue)$Dir" +
          "$($c.White)`$ ") +
        $cur
}

#
# PSReadLine options.
#

Set-PSReadLineOption -EditMode vi -ViModeIndicator Script `
    -ViModeChangeHandler {
        $c = Get-CursorEscapeSequence
        Write-Host -NoNewLine ($args[0] -eq 'Command') ? $c.BlinkingBlock : $c.BlinkingBar
    }

<#
.SYNOPSIS
Tests whether a command is available.
#>

function Test-Command {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        # Specifies a name of a command.
        $Name
    )

    [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

#
# `dotnet` argument tab completion.
#

if(Test-Command dotnet) {
    Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
        dotnet complete --position $args[2] $args[1]
    }
}

#
# `git` argument tab completion.
#

if(Test-Command git) {
    # The hack for lazy loading the Posh-Git module
    # However, this requires pressing <Tab> twice the first time.
    Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
        Import-Module Posh-Git -ErrorAction SilentlyContinue
    }
}

#
# `winget` argument tab completion.
#

if(Test-Command winget) {
    Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
        winget complete --word $args[0] --commandline $args[1] --position $args[2]
    }
}

#
# `docker` argument tab completion.
#

if(Test-Command docker) {
    # The hack for lazy loading the DockerCompletion module
    # However, this requires pressing <Tab> twice the first time.
    Register-ArgumentCompleter -Native -CommandName docker -ScriptBlock {
        Import-Module DockerCompletion -ErrorAction SilentlyContinue
    }
}

#
# `gh` argument tab completion.
#

if(Test-Command gh) {
    # The hack for lazy loading GitHub CLI completion
    # However, this requires pressing <Tab> twice the first time.
    Register-ArgumentCompleter -Native -CommandName gh -ScriptBlock {
        # Requires New-Module to put some "hidden" functions to the global scope
        $null = New-Module {
            gh completion --shell powershell |
                Out-String | Invoke-Expression
        }
    }
}
