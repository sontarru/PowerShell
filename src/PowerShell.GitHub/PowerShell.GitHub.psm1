using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

$ErrorActionPreference = 'Stop'

class PackageNameArgumentCompleter : IArgumentCompleter {
    [IEnumerable[CompletionResult]] CompleteArgument(
            [string] $CommandName,
            [string] $parameterName,
            [string] $wordToComplete,
            [CommandAst] $commandAst,
            [IDictionary] $fakeBoundParameters) {
        $t = $fakeBoundParameters.PackageType
        $t ??= @("NuGet", "Container")
        $r = [List[CompletionResult]]::new()
        Get-GitHubPackage "$wordToComplete*" -PackageType $t |
            ForEach-Object { $r.Add([CompletionResult]::new($_.Name)) }
        return $r
    }
}

class PackageNameArgumentCompleterAttribute : ArgumentCompleterAttribute, IArgumentCompleterFactory {
    [IArgumentCompleter] Create() { return [PackageNameArgumentCompleter]::new() }
}

<#
Gets a list of packages from the user account.
#>
function Get-GitHubPackage {
    [CmdletBinding()]
    param (
        # Package name.
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [PackageNameArgumentCompleterAttribute()]
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
                    PackageType = $_.package_type
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

function Remove-GitHubPackage {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Package name.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [PackageNameArgumentCompleterAttribute()]
        [string]
        $Name,

        # Package type.
        [Parameter()]
        [ValidateSet("NuGet", "Container")]
        [string[]]
        $PackageType = @("NuGet", "Container")
    )

    begin {
        $packages = @{}
    }

    process {
        $Name | Get-GitHubPackage -PackageType $PackageType | ForEach-Object {
            $packages[$_.Id] = $_
        }
    }

    end {
        $packages.Values | ForEach-Object {
            if($PSCmdlet.ShouldProcess("$($_.PackageType) package $($_.Name)")) {
                gh api  `
                    --method DELETE `
                    -H "Accept: application/vnd.github+json" `
                    -H "X-GitHub-Api-Version: 2022-11-28" `
                    "/user/packages/$($_.PackageType.ToLower())/$($_.Name)"
            }
        }
    }
}

Set-Alias gghp Get-GitHubPackage
Set-Alias rghp Remove-GitHubPackage
