$ErrorActionPreference = "Stop"

function Get-PowerPlan {
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [ArgumentCompleter({
            Get-PowerPlan |
                Where-Object Name -Like "$($args[2])*" |
                Select-Object -ExpandProperty Name |
                ForEach-Object { $_.Contains(' ') ? "'$_'" : $_ }
        })]
        [string[]]
        $Name = '*'
    )

    begin {
        Assert-Windows

        $all = powercfg /l | Select-Object -Skip 2 |
            ForEach-Object {
                if($_ -match ':\s*(\S+)\s+\(([^\)]+)\)\s*(\*)?') {
                    [pscustomobject]@{
                        Id = $Matches[1]
                        Name = $Matches[2]
                        Active = [bool]$Matches[3]
                    }
                }
            }

        $filtered = @{}
    }

    process {
        $Name | ForEach-Object {
            $all | Where-Object Name -Like $_ |
                ForEach-Object { $filtered[$_.Id] = $_ }
        }
    }

    end {
        $filtered.Values | Sort-Object Name
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

    Assert-Windows

    Get-PowerPlan |
        Where-Object Name -Eq $Name |
        Select-Object -ExpandProperty Id |
        ForEach-Object {
            powercfg /s $_
        }
}

Set-Alias gpwp Get-PowerPlan
Set-Alias swpwp Switch-PowerPlan
