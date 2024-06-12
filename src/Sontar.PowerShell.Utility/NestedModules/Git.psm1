$ErrorActionPreference = 'Stop'

function Get-Git {
    $git = $IsWindows ? "$env:ProgramFiles\Git\bin\git.exe" : (which git)
    Assert-Command $git
    return $git
}

<#
.SYNOPSIS
Cleans the current Git repository.
#>
function Clear-GitRepo {
    [CmdletBinding()]
    param (
        [switch]
        # Remove untracked files.
        $Untracked
    )

    $git = Get-Git
    $x = $Untracked ? "-x" : "-X"
    & $git clean -df $x -e '!.vs' -e '!*.suo' -e '!.vscode/*'
}

<#
.SYNOPSIS
Starts a new Git flow branch.
#>
function Start-GitFlow {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        # The name of a new working branch.
        $Name,

        [Parameter()]
        [string]
        # The base branch for the flow.
        $Base
    )

    if(-not $Base) {
        $Base = (git branch --show-current)
    }

    $git = Get-Git

    & $git checkout $Base -b $Name &&
        & $git fetch origin "${Base}:${Base}" &&
        & $git rebase $Base &&
        & $git push -u origin $Name
}

Set-Alias clgrepo Clear-GitRepo
Set-Alias sagflow Start-GitFlow
