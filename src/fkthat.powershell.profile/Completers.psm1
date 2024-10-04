$ErrorActionPreference = 'Stop'

if($IsWindows) {
    $winget = "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"

    if(Test-Path $winget) {
        Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
            & $winget complete --word $args[0] --commandline $args[1] --position $args[2]
        }
    }
}

$git = $IsWindows ? "$env:ProgramFiles\Git\bin\git.exe" : (which git)

if(Test-Path $git -ErrorAction SilentlyContinue) {
    $script:CompleterRegistered = $false

    Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
        if(-not $script:CompleterRegistered) {
            Import-Module posh-git
            $script:CompleterRegistered = $true
        }
    }
}

$gh = $IsWindows ? "$env:ProgramFiles\GitHub CLI\gh.exe" : (which gh)

if(Test-Path $gh -ErrorAction SilentlyContinue) {
    $script:CompleterRegistered = $false

    if(-not $script:CompleterRegistered) {
        & $gh completion -s powershell | Out-String | Invoke-Expression
        $script:CompleterRegistered = $true
    }
}

$dotnet = $IsWindows ? "$env:ProgramFiles\dotnet\dotnet.exe" : (which dotnet)

if(Test-Path $dotnet -ErrorAction SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
        & $dotnet complete --position $args[2] $args[1]
    }
}

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
