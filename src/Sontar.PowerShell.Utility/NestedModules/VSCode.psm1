$ErrorActionPreference = "Stop"

function Get-VSCode {
    $code = $IsWindows ? "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd" : (which code)
    Assert-Command $code
    return $code
}

function Start-VSCode {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Path = '.'
    )

    begin {
        $code = Get-VSCode
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

Set-Alias sacode Start-VSCode
