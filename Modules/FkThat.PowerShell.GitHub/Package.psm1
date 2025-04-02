$ErrorActionPreference = 'Stop'

Update-TypeData -TypeName 'FkThat.PowerShell.GitHub.Package' `
    -DefaultDisplayPropertySet 'Name', 'Type', 'Visibility' `
    -Force

Update-TypeData -TypeName 'FkThat.PowerShell.GitHub.PackageVersion' `
    -DefaultDisplayPropertySet 'Name', 'Type', 'Version' `
    -Force

function Get-GitHubPackage {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [SupportsWildcards()]
        [string]
        $Name = '*',

        [Parameter()]
        [ValidateSet('nuget')]
        [string]
        $Type = 'nuget'
    )

    gh api "user/packages?package_type=$Type" |
        ConvertFrom-Json |
        Where-Object name -like $Name |
        ForEach-Object {
            [PSCustomObject]@{
                PSTypeName = 'FkThat.PowerShell.GitHub.Package'
                Name = $_.name
                Type = $_.package_type
                VersionCount = $_.version_count
                Visibility = $_.visibility
                Url = $_.url
                CreatedAt = $_.created_at
                UpdatedAt = $_.updated_at
                Repository = $_.repository.name
                HtmlUrl = $_.html_url
            }
        } |
        Sort-Object Name
}

function Get-GitHubPackageVersion {
   [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [SupportsWildcards()]
        [string]
        $Name = '*',

        [Parameter()]
        [ValidateSet('nuget')]
        [string]
        $Type = 'nuget'
    )

    Get-GitHubPackage $Name -Type $Type | ForEach-Object {
        $pkg = $_
        gh api "/user/packages/$($pkg.Type)/$($pkg.Name)/versions" |
            ConvertFrom-Json | ForEach-Object {
                [PSCustomObject]@{
                    PSTypeName = 'FkThat.PowerShell.GitHub.PackageVersion'
                    Name = $pkg.Name
                    Type = $pkg.Type
                    Version = [System.Version]::new($_.name)
                    CreatedAt = $_.created_at
                    UpdatedAt = $_.updated_at
                    HtmlUrl = $_.html_url
                }
            } |
            Sort-Object Version -Descending
    }
}

Set-Alias gghpkg Get-GitHubPackage
Set-Alias gghpkv Get-GitHubPackageVersion
