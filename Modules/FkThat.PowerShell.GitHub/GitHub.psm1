$ErrorActionPreference = 'Stop'

if(-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Error 'GitHub CLI is not available.'
}
