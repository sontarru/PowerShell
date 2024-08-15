$ErrorActionPreference = 'Stop'

Install-PSResource `
    'Posh-Git',
    'DockerCompletion' `
    -Repository PSGallery `
    -Reinstall

Set-PSResourceRepository GitHub `
    -Uri "https://nuget.pkg.github.com/$env:GITHUB_REPOSITORY_OWNER/index.json" `
    -Trusted

$password = ConvertTo-SecureString $env:REGISTRY_RO_PAT -AsPlainText -Force
$credential = [pscredential]::new($env:GITHUB_REPOSITORY_OWNER, $password)

$ns = 'FkThat.PowerShell'
$modules = "$ns.Profile", "$ns.Development"

if($IsWindows) {
    $modules += "$ns.Alias"
}

Install-PSResource $modules -Repository GitHub -Credential $credential -Reinstall

'$ErrorActionPreference = "Stop"',
'Import-Module FkThat.PowerShell.Profile' |
    Set-Content $PROFILE
