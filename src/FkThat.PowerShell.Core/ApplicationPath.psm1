$ErrorActionPreference = 'Stop'

$apps = @{
    docker = @{
        Win32NT = { "$env:ProgramFiles\Docker\Docker\resources\bin\docker.exe" }
        Unix = { which docker }
    }
    gh = @{
        Win32NT = { "$env:ProgramFiles\GitHub CLI\gh.exe" }
        Unix = { which gh }
    }
    git = @{
        Win32NT = { "$env:ProgramFiles\Git\bin\git.exe" }
        Unix = { which git }
    }
    winget = @{
        Win32NT = { "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe" }
        Unix = { $null }
    }
}

function Get-ApplicationPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Name
    )

    $p = $apps[$Name]

    if($p) {
        $p = $p[$PSVersionTable.Platform]

        if($p) {
            $p = & $p

            if($p -and (Test-Path $p)) {
                return $p
            }
        }
    }
}
