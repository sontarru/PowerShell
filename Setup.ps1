$ErrorActionPreference = 'Stop'

Install-PSResource `
    'Posh-Git',
    'DockerCompletion' `
    -Repository PSGallery `
    -Reinstall

Set-PSResourceRepository GitHub `
    -Uri "https://nuget.pkg.github.com/$env:GITHUB_REPOSITORY_OWNER/index.json" `
    -Trusted

if(-not $env:REGISTRY_RO_PAT) {
    Write-Error 'No API key set.'
}

$password = ConvertTo-SecureString $env:REGISTRY_RO_PAT -AsPlainText -Force
$credential = [pscredential]::new($env:GITHUB_REPOSITORY_OWNER, $password)

$psres = 'FkThat.PowerShell.Core',
    'FkThat.PowerShell.Profile',
    'FkThat.PowerShell.Development'

if($IsWindows) {
    $psres += 'FkThat.PowerShell.Alias'
}

Install-PSResource $psres -Repository GitHub -Credential $credential -Reinstall

Copy-Item (Join-Path $PSScriptRoot "Profile.ps1") $PROFILE
