$ErrorActionPreference = "Stop"

if(-not $IsWindows) { return }

$EnvRegKey = @{
    'System' = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
    'User' = 'HKCU:\Environment'
}

Class EnvironmentVariableScopeValidateSetValuesGenerator: `
    System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        return $Script:EnvRegKey.Keys
    }
}

#
# Public API
#

function Get-EnvironmentVariable {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string[]]
        $Name = '*',

        [Parameter()]
        [ValidateSet([EnvironmentVariableScopeValidateSetValuesGenerator])]
        [string[]]
        $Scope = @('User', 'System')
    )

    begin {
        $names = @()
    }

    process {
        $names += $Name
    }

    end {
        $EnvRegKey.Keys |
            Where-Object { $_ -in $Scope } |
            Sort-Object |
            ForEach-Object {
                $s = $_
                $rk = Get-Item -Path $EnvRegKey[$_]

                $rk.GetValueNames() |
                    Where-Object { $x = $_; $names | Where-Object { $x -like $_ } } |
                    Sort-Object |
                    ForEach-Object {
                        $n = $_
                        [PSCustomObject]@{
                            Scope = $s
                            Name = $n
                            Value = $rk.GetValue($n, $null, 'DoNotExpandEnvironmentNames')
                        }
                    }
            }
    }
}

function Set-EnvironmentVariable {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'NameValueScope')]
        [string]
        $Name,

        [Parameter(Mandatory, Position = 1, ParameterSetName = 'NameValueScope')]
        [string]
        $Value,

        [Parameter(ParameterSetName = 'NameValueScope')]
        [ValidateSet([EnvironmentVariableScopeValidateSetValuesGenerator])]
        [string]
        $Scope = 'User',

        [Parameter(ValueFromPipeline, ParameterSetName = "InputObject")]
        [psobject[]]
        $InputObject,

        [Parameter()]
        [switch]
        $Force
    )

    begin {
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = 'None'
        }

        if($PSCmdlet.ParameterSetName -eq 'NameValueScope') {
            $InputObject = [pscustomobject]@{
                Name = $Name
                Value = $Value
                Scope = $Scope
            }
            # stop warn
            $null = $InputObject
        }
    }

    process {
        $InputObject | ForEach-Object {
            Set-ItemProperty $EnvRegKey[$_.Scope] `
                -Name $_.Name -Value $_.Value `
                -Type ExpandString
        }
    }
}

function Remove-EnvironmentVariable {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Name,

        [Parameter()]
        [ValidateSet([EnvironmentVariableScopeValidateSetValuesGenerator])]
        [string]
        $Scope = 'User',

        [Parameter()]
        [switch]
        $Force
    )

    if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
        $ConfirmPreference = 'None'
    }

    Remove-ItemProperty $EnvRegKey[$Scope] -Name $Name
}

Set-Alias genv Get-EnvironmentVariable
Set-Alias senv Set-EnvironmentVariable
Set-Alias renv Remove-EnvironmentVariable
