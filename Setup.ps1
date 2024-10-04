$ErrorActionPreference = 'Stop'

Set-PSResourceRepository GitHub `
    -Uri "https://nuget.pkg.github.com/$env:GITHUB_REPOSITORY_OWNER/index.json" `
    -Trusted

$password = ConvertTo-SecureString $env:GITHUB_TOKEN -AsPlainText -Force
$credential = [pscredential]::new($env:GITHUB_REPOSITORY_OWNER, $password)

Install-PSResource `
    'Posh-Git',
    'DockerCompletion' `
    -Repository PSGallery `
    -WarningAction SilentlyContinue

'fkthat.powershell.profile',
'fkthat.powershell.alias',
'fkthat.powershell.utility' |
Install-PSResource ` -Repository GitHub ` -Credential $credential `
    -Reinstall -WarningAction SilentlyContinue

Invoke-WebRequest `
    "https://raw.githubusercontent.com/$env:GITHUB_REPOSITORY_OWNER/PowerShell/develop/Profile.ps1" `
    -OutFile $PROFILE
