$ErrorActionPreference = 'Stop'

<#
Gets a list of packages from the user account.
#>
function Get-GitHubPackage {
    [CmdletBinding()]
    param (
        # Package name.
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string[]]
        $Name = '*',

        # Package type.
        [Parameter()]
        [ValidateSet("NuGet", "Container")]
        [string[]]
        $PackageType = @("NuGet", "Container")
    )

    begin {
        $names = @()
    }

    process {
        $names += $Name
    }

    end {
        $all = @{}

        $PackageType | ForEach-Object { $_.ToLower() } |
            Select-Object -Unique |
            ForEach-Object { gh api "/user/packages?package_type=$($_)" } |
            ConvertFrom-Json |
            ForEach-Object {
                $all[$_.id] = [PSCustomObject]@{
                    Id = $_.id
                    PacksageType = $_.package_type
                    Name = $_.name
                    Visibility = $_.visibility
                }
            }

        $all.Values | Where-Object {
                $n = $_.Name
                $names | Where-Object { $n -Like $_ }
            } |
            Sort-Object PackageType, Name
    }
}

Set-Alias gghp Get-GitHubPackage
