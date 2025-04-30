$ErrorActionPreference = 'Stop'

$gh = $IsWindows ? "$env:ProgramFiles\GitHub CLI\gh.exe" : (which gh)

if(-not $gh -or -not (Test-Path $gh)) {
    return
}

Register-ArgumentCompleter -Native -CommandName gh -ScriptBlock {
    # Cannot run `gh completion` directly since it places
    # functions to the wrong scope in this case.
    $null = New-Module -ScriptBlock {
        gh completion --shell powershell | Out-String | Invoke-Expression
    }
}

function New-GitHubIssue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Title,

        [Parameter()]
        [string]
        $Repo,

        [Parameter()]
        [string]
        $Assignee = '@me',

        [Parameter()]
        [string]
        $Body = '',

        [Parameter()]
        [ArgumentCompletions('enhancement', 'bug', 'documentation')]
        [string]
        $Label = 'enhancement',

        [Parameter()]
        [string]
        $Project,

        [Parameter()]
        [switch]
        $Editor
    )

    $p = "issue", "create",
         "--title", $Title,
         "--assignee", $Assignee,
         "--body", $Body,
         "--label", $Label

    if($Editor) {
        $p += "--editor"
    }

    if($Repo) {
        $p += "--repo", $Repo
    }

    if($Project) {
        $p += "--project", $Project
    }

    & $gh @p
}

Set-Alias gh $gh
Set-Alias nghi New-GitHubIssue
