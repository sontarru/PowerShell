$ErrorActionPreference = 'Stop'

if(-not $IsWindows) {
    Write-Error 'Not supported platform.'
}

$VSCodeDir = "$env:LOCALAPPDATA\Programs\Microsoft VS Code"
$VSCodeExePath = "$VSCodeDir\code.exe"
$VSCodeJsPath = ".\resources\app\out\cli.js"
$ArgList = @($VSCodeJsPath, '-n')
$Environment = @{VSCODE_DEV = ''; ELECTRON_RUN_AS_NODE = 1}

function Start-VSCode {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Path = '.'
    )

    process {
        $Path | Get-Item | Select-Object -ExpandProperty FullName -Unique |
            ForEach-Object {
                Start-Process -FilePath $VSCodeExePath -ArgumentList ($ArgList + @($_)) `
                    -Environment $Environment -WorkingDirectory $VSCodeDir
            }
    }
}

Set-Alias sacode Start-VSCode
