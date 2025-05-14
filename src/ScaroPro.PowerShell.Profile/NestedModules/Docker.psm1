$ErrorActionPreference = 'Stop'

$docker = $IsWindows ? "$env:ProgramFiles\Docker\Docker\resources\bin\docker.exe" : (which docker)

if(Get-Command $docker -ErrorAction SilentlyContinue) {
    Set-Alias docker $docker

    # The hack for lazy loading the DockerCompletion module
    # However, this requires pressing <Tab> twice the first time.
    Register-ArgumentCompleter -Native -CommandName docker -ScriptBlock {
        Import-Module DockerCompletion -ErrorAction SilentlyContinue
    }
}
