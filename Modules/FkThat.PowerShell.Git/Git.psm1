$ErrorActionPreference = 'Stop'

if(-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error 'Git is not available.'
}

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

function Clear-GitRepo {
    [CmdletBinding()]
    param (
        [switch]
        # Clear untracked files as well.
        $Untracked
    )

    $x = $Untracked ? "-x" : "-X"
    git clean -df $x -e '!.vs' -e '!*.suo' -e '!.vscode/*'
}

Set-Alias saflow Start-GitFlow
Set-Alias clgit Clear-GitRepo
