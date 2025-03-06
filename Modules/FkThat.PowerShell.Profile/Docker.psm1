$ErrorActionPreference = 'Stop'

if($IsWindows) {
    $docker = "$env:ProgramFiles\Docker\Docker\resources\bin\docker.exe"
    if(Test-Path $docker) {
        Set-Alias docker $docker
    }
}

# If docker is available import DockerCompletion module
if(Get-Command docker -ErrorAction SilentlyContinue) {
    Import-Module DockerCompletion
}
