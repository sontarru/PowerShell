$ErrorActionPreference = 'Stop'

if(Get-Command git -ErrorAction SilentlyContinue) {
    Import-Module posh-git
}
