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

'fkthat.powershell',
'fkthat.powershell.aliases',
'fkthat.powershell.codecoverage',
'fkthat.powershell.completers.docker',
'fkthat.powershell.completers.dotnet',
'fkthat.powershell.completers.gh',
'fkthat.powershell.completers.git',
'fkthat.powershell.completers.winget',
'fkthat.powershell.content',
'fkthat.powershell.git',
'fkthat.powershell.password',
'fkthat.powershell.path',
'fkthat.powershell.powerplan',
'fkthat.powershell.process',
'fkthat.powershell.prompt',
'fkthat.powershell.psreadline',
'fkthat.powershell.systemtray' |
Install-PSResource ` -Repository GitHub ` -Credential $credential `
    -Reinstall -WarningAction SilentlyContinue

Invoke-WebRequest `
    "https://raw.githubusercontent.com/$env:GITHUB_REPOSITORY_OWNER/PowerShell/develop/Profile.ps1" `
    -OutFile $PROFILE
