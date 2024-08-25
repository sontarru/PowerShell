[CmdletBinding()]
param(
    [Parameter()]
    [switch]
    $Update,

    [Parameter()]
    [switch]
    $Reinstall
)

$ErrorActionPreference = 'Stop'

Set-PSResourceRepository GitHub `
    -Uri "https://nuget.pkg.github.com/$env:GITHUB_REPOSITORY_OWNER/index.json" `
    -Trusted

$password = ConvertTo-SecureString $env:GITHUB_TOKEN -AsPlainText -Force
$credential = [pscredential]::new($env:GITHUB_REPOSITORY_OWNER, $password)

if(-not $Update) {
    Install-PSResource `
        'Posh-Git',
        'DockerCompletion' `
        -Repository PSGallery `
        -Reinstall:$Reinstall `
        -WarningAction SilentlyContinue

    Install-PSResource `
        'fkthat.powershell' `
        -Repository GitHub `
        -Credential $credential `
        -Reinstall:$Reinstall `
        -WarningAction SilentlyContinue

}
else {
    Get-InstalledPSResource | ForEach-Object {
        Update-PSResource $_.Name -Repository $_.Repository `
            -Credential $credential -WarningAction SilentlyContinue
    }
}

Invoke-WebRequest `
    "https://raw.githubusercontent.com/$env:GITHUB_REPOSITORY_OWNER/PowerShell/develop/Profile.ps1" `
    -OutFile $PROFILE
