$ErrorActionPreference = 'Stop'

function Assert-Windows {
    if(-not $IsWindows) {
        Write-Error "The $($PSVersionTable.Platform) platform is not supported."
    }
}

function Assert-Command {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]
        $Name
    )

    if(-not (Get-Command $Name)) {
        Write-Error "The command, alias, or executable '$Name' is not found."
    }
}
