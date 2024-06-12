$ErrorActionPreference = 'Stop'

function Get-RandomHostName {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [int]
        $Count = 1
    )

    $names = Join-Path $PSScriptRoot "HostName.txt" |
        Get-Item | Get-Content

    $result = @{}

    while($result.Count -lt $Count) {
       $i = Get-Random -Maximum $names.Length
       $result[$names[$i]] = $true
    }

    $result.Keys | Sort-Object
}
