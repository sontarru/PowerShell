$ErrorActionPreference = "Stop"

if(-not $IsWindows) {
    return
}

function _Get_PowerPlan {
    powercfg /l |
        Select-Object -Skip 2 |
        ForEach-Object {
            if($_ -match ':\s*(\S+)\s+\(([^\)]+)\)\s*(\*)?') {
                [pscustomobject]@{
                    Id = $Matches[1]
                    Name = $Matches[2]
                    Active = [bool]$Matches[3]
                }
            }
        }
}

function Get-PowerPlan {
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [ArgumentCompleter({
            $wordToComplete = $args[2]
            _Get_PowerPlan |
                Where-Object Name -Like "$wordToComplete*" |
                Select-Object -ExpandProperty Name |
                ForEach-Object { "'$_'" }
        })]
        [string[]]
        $Name = '*'
    )

    begin {
        $all = _Get_PowerPlan
        $filtered = @{}
    }

    process {
        $Name | ForEach-Object {
            $all | Where-Object Name -Like $_ |
                ForEach-Object { $filtered[$_.Id] = $_ }
        }
    }

    end {
        $filtered.Values
    }
}

Class PowerPlanValidateSetGenerator: System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        return (_Get_PowerPlan | Select-Object -ExpandProperty Name)
    }
}

function Switch-PowerPlan {
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        [ValidateSet([PowerPlanValidateSetGenerator])]
        $Name
    )

    Get-PowerPlan |
        Where-Object Name -Eq $Name |
        Select-Object -ExpandProperty Id |
        ForEach-Object {
            powercfg /s $_
        }
}

Set-Alias gpwp Get-PowerPlan
Set-Alias swpwp Switch-PowerPlan
