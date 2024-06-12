$ErrorActionPreference = 'Stop'

$docker = $IsWindows ?  "$env:ProgramFiles\Docker\Docker\resources\bin\docker.exe" : (which docker)

if(-not $docker -or -not (Test-Path $docker)) {
    return
}

Register-ArgumentCompleter -Native -CommandName docker -ScriptBlock {
    Import-Module DockerCompletion
}

$Script:Completion = $false

function Start-Docker {
    if(-not $Script:Completion) {
        Import-Module DockerCompletion
        $Script:Completion = $true
    }

    & $docker @args
}

Set-Alias docker $docker
