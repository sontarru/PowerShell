$ErrorActionPreference = 'Stop'

Install-PSResource `
    'Posh-Git',
    'DockerCompletion' `
    -Repository PSGallery `
    -Reinstall

Set-PSResourceRepository GitHub `
    -Uri "https://nuget.pkg.github.com/$env:GITHUB_REPOSITORY_OWNER/index.json" `
    -Trusted

$password = ConvertTo-SecureString $env:GITHUB_TOKEN -AsPlainText -Force
$credential = [pscredential]::new($env:GITHUB_REPOSITORY_OWNER, $password)

Install-PSResource fkthat.powershell -Repository GitHub -Credential $credential -Reinstall

Invoke-WebRequest `
    "https://raw.githubusercontent.com/$env:GITHUB_REPOSITORY_OWNER/PowerShell/develop/Profile.ps1" `
    -OutFile $PROFILE
