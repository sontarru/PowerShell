$ErrorActionPreference = 'Stop'

Install-PSResource `
    'Posh-Git',
    'DockerCompletion' `
    -Repository PSGallery `
    -Reinstall

Set-PSResourceRepository GitHub `
    -Uri "https://nuget.pkg.github.com/fkthat/index.json" `
    -Trusted

if(-not $env:REGISTRY_RO_PAT) {
    Write-Error 'No API key set.'
}

$password = ConvertTo-SecureString $env:REGISTRY_RO_PAT -AsPlainText -Force
$credential = [pscredential]::new($env:GITHUB_REPOSITORY_OWNER, $password)

Install-PSResource `
    "FkThat.PowerShell.Profile",
    "FkThat.PowerShell.Utility" `
    -Repository GitHub `
    -Credential $credential `
    -Reinstall

Copy-Item (Join-Path $PSScriptRoot "Profile.ps1") $PROFILE
