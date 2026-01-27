using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

$ErrorActionPreference = 'Stop'

[Flags()]
enum Scope {
    System = 1
    User = 2
    All = 3
}

$EnvRegKey = @{
    [Scope]::System = "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment"
    [Scope]::User = "HKCU:\Environment"
}

class EnvNameArgumentCompleter : IArgumentCompleter {
    [IEnumerable[CompletionResult]] CompleteArgument(
            [string] $CommandName,
            [string] $parameterName,
            [string] $wordToComplete,
            [CommandAst] $commandAst,
            [IDictionary] $fakeBoundParameters) {
        $s = $fakeBoundParameters.Scope
        $s ??= [Scope]::All
        $r = [List[CompletionResult]]::new()
        Get-Env "$wordToComplete*" -Scope $s |
            ForEach-Object { $r.Add([CompletionResult]::new($_.Name)) }
        return $r
    }
}

class EnvNameArgumentCompleterAttribute : ArgumentCompleterAttribute, IArgumentCompleterFactory {
    [IArgumentCompleter] Create() { return [EnvNameArgumentCompleter]::new() }
}

<#
.SYNOPSIS
Gets environment variable(s).
#>
function Get-Env {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string[]]
        [EnvNameArgumentCompleterAttribute()]
        $Name = '*',

        [Parameter()]
        [Scope]
        $Scope = [Scope]::All
    )

    begin {
        $names = @()
    }

    process {
        $names += $Name
    }

    end {
        $EnvRegKey.GetEnumerator() | ForEach-Object {
            $s = $_.Key
            $k = Get-Item $_.Value

            $k.GetValueNames() | ForEach-Object {
                $n = $_
                $v = $k.GetValue($n, $null, 1)

                [PSCustomObject]@{
                    Scope = $s
                    Name = $n
                    Value = $v
                }
            }
        } |
        Where-Object { $_.Scope -band $Scope } |
        Where-Object {
            $n = $_.Name
            $names | Where-Object { $n -like $_ }
        } |
        Sort-Object Scope, Name
    }
}

<#
.SYNOPSIS
Sets an environment variable.
#>
function Set-Env {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        [EnvNameArgumentCompleterAttribute()]
        $Name,

        [Parameter(Mandatory, Position = 1)]
        [string]
        $Value,

        [Parameter()]
        [Scope]
        [ValidateSet('System', 'User')]
        $Scope = [Scope]::User
    )

    Set-ItemProperty $EnvRegKey[$Scope] `
        -Name $Name -Value $Value `
        -Type ExpandString
}

<#
.SYNOPSIS
Removes an environment variable.
#>
function Remove-Env {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        [EnvNameArgumentCompleterAttribute()]
        $Name,

        [Parameter()]
        [Scope]
        [ValidateSet('System', 'User')]
        $Scope = [Scope]::User
    )

    Remove-ItemProperty $EnvRegKey[$Scope] -Name $Name
}

<#
Writes all environment variables to a specified file or the output.
#>
function Export-Env {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]
        $Path
    )

    $ht = [ordered]@{}

    Get-Env | ForEach-Object {
        $ht[[string]$_.Scope] ??= [ordered]@{}
        $ht[[string]$_.Scope][$_.Name] = $_.Value
    }

    $f = { $ht | ConvertTo-Json }
    $Path ? (&$f | Out-File $Path) : (&$f)
}

<#
Reads all environment variables from a specified file.
#>
function Import-Env {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Path
    )

    $ht = Get-Content $Path | ConvertFrom-Json -AsHashtable

    foreach ($scope in $ht.Keys) {
        foreach($name in $ht[$scope].Keys) {
            $value = $ht[$scope][$name]
            $value ? (Set-Env $name $value -Scope $scope -ErrorAction Continue) :
                (Remove-Env $name -Scope $scope -ErrorAction Continue)
        }
    }
}

Set-Alias genv Get-Env
Set-Alias senv Set-Env
Set-Alias renv Remove-Env
Set-Alias epenv Export-Env
Set-Alias ipenv Import-Env
