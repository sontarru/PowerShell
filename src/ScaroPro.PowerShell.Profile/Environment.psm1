$ErrorActionPreference = "Stop"

if(-not $IsWindows) {
    return
}

$RegKeys = @{
    'User' = 'HKCU:\Environment'
    'System' = 'HKLM:\System\CurrentControlSet\Control\Session Manager\Environment'
}

function Get-Environment {
    $RegKeys.Keys | ForEach-Object {
        $scope = $_
        $rkey = Get-Item $RegKeys[$_]

        $rkey.GetValueNames() | ForEach-Object {
            $name = $_
            $value = $rkey.GetValue($name, $null, 'DoNotExpandEnvironmentNames')

            [PSCustomObject]@{
                Scope = $scope
                Name = $name
                Value = $value
            }
        }
    }
}

function Import-Environment {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Path
    )

    $env = Get-Content $Path | ConvertFrom-Json -AsHashtable

    foreach($scope in $env.Keys) {
        $reg = $RegKeys[$scope]

        foreach($name in $env[$scope].Keys) {
            $val = $env[$scope][$name]

            if($val) {
                Set-ItemProperty $reg -Name $name -Value $val `
                    -Type ExpandString
            }
            else {
                if(Get-ItemProperty $reg -Name $name -ErrorAction SilentlyContinue) {
                    Remove-ItemProperty $reg -Name $name
                }
            }
        }
    }
}

function Export-Environment {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]
        $Path
    )

    if(-not $Path) {
        $environment = @{}

        Get-Environment | ForEach-Object {
            if($environment[$_.Scope]) {
                $environment[$_.Scope][$_.Name] = $_.Value
            }
            else  {
                $environment[$_.Scope] = @{ $_.Name = $_.Value }
            }
        }

        $environment.Keys.Clone() | ForEach-Object {
            $environment[$_] = [pscustomobject]$environment[$_]
        }

        [pscustomobject]$environment
    }
    else {
        Export-Environment | ConvertTo-Json | Out-File $Path
    }
}

Set-Alias genv Get-Environment
Set-Alias ipenv Import-Environment
Set-Alias epenv Export-Environment
