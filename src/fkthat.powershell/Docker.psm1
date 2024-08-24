$ErrorActionPreference = 'Stop'

$script:CompleterRegistered = $false

if(Get-Command docker -ErrorAction SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName docker -ScriptBlock {
        if(-not $script:CompleterRegistered) {
            Import-Module DockerCompletion
            $script:CompleterRegistered = $true
        }
    }
}
