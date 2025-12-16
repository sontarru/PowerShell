$ErrorActionPreference = 'Stop'

<#
.SYNOPSIS
Cleans the current Git repository.
#>
function Clear-GitIgnoredFiles {
    [CmdletBinding()]
    param (
        [switch]
        # Remove untracked files.
        $Untracked
    )

    $x = $Untracked ? "-x" : "-X"
    git clean -df $x -e '!.vs' -e '!*.suo' -e '!.vscode/*'
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

    git checkout $Base -b $Name &&
        git fetch origin "${Base}:${Base}" &&
        git rebase $Base &&
        git push -u origin $Name
}

Set-Alias clgi Clear-GitIgnoredFiles
Set-Alias sagf Start-GitFlow

