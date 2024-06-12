$ErrorActionPreference = "Stop"

$WebSearchJsonPath = Join-Path $PSScriptRoot 'WebSearch.json'

function Get-WebSearch {
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
        $all = @()

        $ht = Get-Content $WebSearchJsonPath |
            ConvertFrom-Json -AsHashtable

        foreach($k in $ht.Keys) {
            $v = $ht[$k]
            $all += [PSCustomObject]@{
                Key = $k
                Name = $v.name
                Url = $v.url
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
            Get-WebSearch "$($args[2])*" | Select-Object -ExpandProperty Key
        })]
        [string[]]
        $Key,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Terms
    )

    $t = [Uri]::EscapeDataString(($Terms | Join-String -Separator ' '))

    Get-WebSearch $Key | ForEach-Object {
        $u = $_.Url -replace '\{terms\}',"$t"
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

Set-Alias gwse Get-WebSearch
Set-Alias srweb Search-Web
Set-Alias srbing Search-Bing
Set-Alias srms Search-MS
Set-Alias srapi Search-Api
