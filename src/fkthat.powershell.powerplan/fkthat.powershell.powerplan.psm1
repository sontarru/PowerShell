$ErrorActionPreference = "Stop"

if(-not $IsWindows) {
    return
}

function Get-PowerPlan {
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

Class PowerPlanValidateSetGenerator: System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        return (Get-PowerPlan | Select-Object -ExpandProperty Name)
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
