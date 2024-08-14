$ErrorActionPreference = 'Stop'

$docker = Get-ApplicationPath docker

if(-not $docker) {
    return
}

Import-Module DockerCompletion -ErrorAction Continue

if($IsWindows) {
    Set-Alias docker $docker
}
