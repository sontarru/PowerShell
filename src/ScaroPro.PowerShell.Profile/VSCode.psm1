$ErrorActionPreference = 'Stop'

$code = $IsWindows ? "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd" : (which code)

if(-not $code -or -not (Test-Path $code -ErrorAction SilentlyContinue)) {
    return
}

function Start-VSCode {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Path = '.'
    )

    process {
        $Path | Get-Item -ErrorAction SilentlyContinue |
            Select-Object -ExpandProperty FullName -Unique |
            ForEach-Object { & $code -n $_ }
    }
}

Set-Alias sacode Start-VSCode
