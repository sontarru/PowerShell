$ErrorActionPreference = "Stop"

$code = $IsWindows ? "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd" : (which code)

if(-not (Get-Command $code -ErrorAction SilentlyContinue)) {
    Write-Error "The '$code' executable is not found."
}

function Start-VSCode {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Path = '.'
    )

    begin {
        $paths = @{}
    }

    process {
        $Path | Get-Item -ErrorAction SilentlyContinue |
            ForEach-Object { $paths[$_.FullName] = $true }
    }

    end {
        $paths.Keys | ForEach-Object {
            & $code -n $_
        }
    }
}

Set-Alias code $code
Set-Alias sacode Start-VSCode
