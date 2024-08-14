$ErrorActionPreference = 'Stop'

$winapps = @{
    docker = "$env:ProgramFiles\Docker\Docker\resources\bin\docker.exe"
    gh = "$env:ProgramFiles\GitHub CLI\gh.exe"
    git = "$env:ProgramFiles\Git\bin\git.exe"
    winget = "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe"
    dotnet = "$env:ProgramFiles\dotnet\dotnet.exe"
}

$winapps.Keys | ForEach-Object {
    $app = $_

    $p = switch($PSVersionTable.Platform) {
        Win32NT { $winapps[$app] }
        Unix { which $app }
    }

    if($p -and (Test-Path $p)) {
        switch($app) {
            docker {
                Import-Module DockerCompletion -ErrorAction SilentlyContinue
            }
            gh {
                & $p completion -s powershell | Out-String | Invoke-Expression
            }
            git {
                Import-Module Posh-Git -ErrorAction SilentlyContinue
            }
            winget {
                $script:winget = $p
                Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
                    param($w, $c, $p)
                    & $script:winget complete --word $w --commandline $c --position $p
                }
            }
            dotnet {
                $script:dotnet = $p
                Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
                    param($w, $c, $p)
                    & $script:dotnet complete --position $p $c
                }
            }
        }

        Set-Alias $app $p
    }
}
