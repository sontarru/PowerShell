$ErrorActionPreference = "Stop"

function  _GetWsePath {
    Join-Path $PSScriptRoot 'wse.json'
}

function Import-WebSearchEngine {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Path
    )

    Copy-Item $Path (_GetWsePath) -Force
}

function Export-WebSearchEngine {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Path
    )

    $wse = _GetWsePath

    if(Test-Path $wse) {
        Copy-Item $wse $Path -Force
    }
    else {
        Set-Content $Path "{}"
    }
}

function Get-WebSearchEngine {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [ArgumentCompleter({
            Get-WebSearch "$($args[2])*" | Select-Object -ExpandProperty Key
        })]
        [string[]]
        $Key = '*',

        [switch]
        $AsVimium
    )

    begin {
        $wse = _GetWsePath
        $all = @()

        if(Test-Path "$PSScriptRoot/wse.json") {
            $ht = Get-Content $wse | ConvertFrom-Json -AsHashtable

            foreach($k in $ht.Keys) {
                $v = $ht[$k]
                $all += [PSCustomObject]@{
                    Key = $k
                    Name = $v.name
                    Url = $v.url
                }
            }
        }

        $filtered = [ordered]@{}
    }

    process {
        $Key | ForEach-Object {
            $all | Where-Object Key -Like $_ |
                ForEach-Object { $filtered.Add($_.Key, $_) }
        }
    }

    end {
        if($AsVimium) {
            $filtered.Values | ForEach-Object {
                $u = $_.Url -replace '\{terms\}','$s'
                $s = [uri]::new($u)
                $p = $s.IsDefaultPort ? "" : ":$($s.Port)"
                $s = "$($s.Scheme)://$($s.Host)$p"
                "$($_.Key): $u blank=$s $($_.Name)"
            }
        }
        else {
            $filtered.Values
        }
    }
}

function Search-Web {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({
            Get-WebSearchEngine "$($args[2])*" | Select-Object -ExpandProperty Key
        })]
        [string[]]
        $Key,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Terms
    )

    $t = $Terms ? [Uri]::EscapeDataString(($Terms | Join-String -Separator ' ')) : $null

    Get-WebSearchEngine $Key | ForEach-Object {
        if($t) {
            $u = $_.Url -replace '\{terms\}',"$t"
        }
        else {
            $s = [uri]::new($_.Url)
            $p = $s.IsDefaultPort ? "" : ":$($s.Port)"
            $u = "$($s.Scheme)://$($s.Host)$p"
        }

        $IsWindows ? (Start-Process $u) : $u
    }
}

function Search-Bing {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Terms
    )

    Search-Web 'b' $Terms
}

function Search-MS {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Terms
    )

    Search-Web 'ms' $Terms
}

function Search-Api {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Terms
    )

    Search-Web 'api' $Terms
}

Set-Alias ipwse Import-WebSearchEngine
Set-Alias epwse Export-WebSearchEngine
Set-Alias gwse Get-WebSearchEngine
Set-Alias srweb Search-Web
Set-Alias srbing Search-Bing
Set-Alias srms Search-MS
Set-Alias srapi Search-Api
