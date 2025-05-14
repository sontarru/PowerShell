$ErrorActionPreference = 'Stop'

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

Set-Alias clgrepo Clear-GitRepo
