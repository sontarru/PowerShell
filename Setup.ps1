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

$ns = 'fkthat.powershell'
$modules = "$ns.profile", "$ns.development", "$ns.utility"

if($IsWindows) {
    $modules += "$ns.alias"
}

Install-PSResource $modules -Repository GitHub -Credential $credential -Reinstall

'$ErrorActionPreference = "Stop"',
'Import-Module fkthat.powershell.profile' |
    Set-Content $PROFILE
