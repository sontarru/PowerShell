Set-PSResourceRepository GitHub `
    -Uri "https://nuget.pkg.github.com/$env:GITHUB_REPOSITORY_OWNER/index.json" `
    -Trusted

$password = ConvertTo-SecureString $env:REGISTRY_RW_PAT -AsPlainText -Force
$credential = [pscredential]::new($env:GITHUB_REPOSITORY_OWNER, $password)

Join-Path $PSScriptRoot '..' 'src' | Get-ChildItem | ForEach-Object {
    Publish-PSResource -Path $_ -Repository GitHub -Credential $credential `
        -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
}
