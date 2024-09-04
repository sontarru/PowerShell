$ErrorActionPreference = 'Stop'

$docker = $IsWindows ? "$env:ProgramFiles\Docker\Docker\resources\bin\docker.exe" : (which docker)

$script:CompleterRegistered = $false

if(Test-Path $docker -ErrorAction SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName docker -ScriptBlock {
        if(-not $script:CompleterRegistered) {
            Import-Module DockerCompletion
            $script:CompleterRegistered = $true
        }
    }
}
