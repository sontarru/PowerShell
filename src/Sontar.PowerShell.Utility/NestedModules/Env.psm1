$ErrorActionPreference = 'Stop'

$EnvRegKey = @{
    User = "HKCU:\Environment"
    System = "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment"
}

function Import-Env {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position = 0)]
        [string]
        $Path
    )

    Assert-Windows

    if(-not $Path) {
        $Path = Join-Path $PSScriptRoot 'Env.json'
    }

    Get-Content $Path | ConvertFrom-Json -AsHashtable |
        ForEach-Object { $_.GetEnumerator() } |
        ForEach-Object {
            $scope = $_.Key
            $values = $_.Value

            $reg = $EnvRegKey[$scope]

            $values.GetEnumerator() | ForEach-Object {
                $name = $_.Key
                $value = $_.Value

                if($value) {
                    Set-ItemProperty $reg -Name $name -Value $value -Type ExpandString
                }
                else {
                    Remove-ItemProperty $reg -Name $name -ErrorAction Continue
                }
            }
        }
}

Set-Alias ipenv Import-Env
