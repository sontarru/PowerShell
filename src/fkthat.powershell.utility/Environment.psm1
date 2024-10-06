$ErrorActionPreference = "Stop"

if(-not $IsWindows) { return }

enum Scope {
    All = 0
    User = 1
    Machine = 2
}

$EnvRegKey = @{
    [Scope]::User = 'HKCU:\Environment'
    [Scope]::Machine = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
}

function _Get_EnvironmentVariable {
    $EnvRegKey.Keys | ForEach-Object {
            $scope = $_
            $key = Get-Item $EnvRegKey[$scope]

            $key.GetValueNames() | ForEach-Object {
                [PSCustomObject]@{
                    Scope = [Scope]$scope
                    Name = $_
                    Value = $key.GetValue($_, $null, 'DoNotExpandEnvironmentNames')
                }
            }
        }
}

function global:_EnvironmentVariableCompleter {
    $wordToComplete = $args[2]
    $fakeBoundParameters = $args[4]

    if($fakeBoundParameters.ContainsKey('Scope')) {
        $useScope = $fakeBoundParameters['Scope']
    }
    else {
        $useScope = $null
    }

    _Get_EnvironmentVariable |
        Where-Object { (-not $useScope) -or ($_.Scope -eq $useScope) } |
        Where-Object Name -Like "$wordToComplete*" |
        Select-Object -ExpandProperty Name |
        ForEach-Object { "'$_'" }
}

function Get-EnvironmentVariable {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [ArgumentCompleter({ global:_EnvironmentVariableCompleter @args })]
        [string[]]
        $Name = '*',

        [Parameter()]
        [Scope]
        $Scope = 'All'
    )

    begin {
        $all = _Get_EnvironmentVariable |
            Where-Object { -not $Scope -or $_.Scope -eq $Scope }

        $filtered = @()
    }

    process {
        $Name | ForEach-Object {
            $n = $_

            $all | Where-Object { $_.Name -like $n } |
                ForEach-Object { $filtered += $_ }
        }
    }

    end {
        $filtered | Sort-Object Scope, Name -Unique
    }
}

function Set-EnvironmentVariable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'ByName')]
        [ArgumentCompleter({ global:_EnvironmentVariableCompleter @args })]
        [string]
        $Name,

        [Parameter(Mandatory, Position = 1, ParameterSetName = 'ByName')]
        [string]
        $Value,

        [Parameter(ParameterSetName = 'ByName')]
        [ValidateSet('User', 'Machine')]
        [Scope]
        $Scope = 'User',

        [Parameter(ValueFromPipeline, ParameterSetName = 'ByInputObject')]
        [psobject]
        $InputObject
    )

    begin {
        if($Name) {
            $InputObject = [PSCustomObject]@{
                Name = $Name
                Value = $Value
                Scope = $Scope
            }
        }
    }

    process {
        $InputObject | ForEach-Object {
            $path = $EnvRegKey[$_.Scope]
            $null = Set-ItemProperty $path -Name $_.Name -Value $_.Value -Type ExpandString
        }
    }
}

function Remove-EnvironmentVariable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'ByName')]
        [ArgumentCompleter({ global:_EnvironmentVariableCompleter @args })]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByName')]
        [ValidateSet('User', 'Machine')]
        [Scope]
        $Scope = 'User',

        [Parameter(ValueFromPipeline, ParameterSetName = 'ByInputObject')]
        [psobject]
        $InputObject
    )

    begin {
        if($Name) {
            $InputObject = [PSCustomObject]@{
                Name = $Name
                Scope = $Scope
            }
        }
    }

    process {
        $path = $EnvRegKey[$_.Scope]
        $null = Remove-ItemProperty $path -Name $_.Name
    }
}

Set-Alias genv Get-EnvironmentVariable
Set-Alias senv Set-EnvironmentVariable
Set-Alias renv Remove-EnvironmentVariable
