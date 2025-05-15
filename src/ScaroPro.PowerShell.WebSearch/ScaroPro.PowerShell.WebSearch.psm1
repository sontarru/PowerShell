$ErrorActionPreference = "Stop"

$WebSearchDataPath = Join-Path $PSScriptRoot 'Data'
$WebSearchJsonPath = Join-Path $WebSearchDataPath 'WebSearch.json'

if(-not (Test-Path $WebSearchJsonPath -PathType Leaf)) {
    Remove-Item $WebSearchDataPath -Recurse -Force -ErrorAction SilentlyContinue
    New-Item $WebSearchJsonPath -Force
    Set-Content -Path $WebSearchJsonPath -Value "[]"
}

function ConvertFrom-WebSearchJson {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string[]]
        $InputObject
    )

    begin {
        $iobj = @()
    }

    process {
        $iobj += $InputObject
    }

    end {
        $iobj | ConvertFrom-Json -AsHashtable |
        ForEach-Object  `
            -Begin { $ht = [ordered]@{}; $null = $ht } `
            -Process {
                $k = $_.key
                $n = $_.name
                $u = $_.url

                if($k) {
                    $k = $k.ToString().ToLower()

                    if($n -and $u) {
                        $ht[$k] = [PSCustomObject]@{
                            Key = $k
                            Name = $n
                            Url = $u
                        }
                    }
                }
            } `
            -End { $ht.Values }
    }
}

function ConvertTo-WebSearchJson {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object[]]
        $InputObject
    )

    begin {
        $ht = [ordered]@{}
    }

    process {
        $InputObject | ForEach-Object {
            $k = $_.Key
            $n = $_.Name
            $u = $_.Url

            if($k) {
                $k = $k.ToString().ToLower()

                if($n -and $u) {
                    $ht[$k] = [PSCustomObject]@{
                        key = $k
                        name = $n
                        url = $u
                    }
                }
            }
        }
    }

    end {
        $ht.Values | ConvertTo-Json
    }
}

function ConvertTo-WebSearchVimium {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object[]]
        $InputObject
    )

    begin {
        $vimium = [ordered]@{}
    }

    process {
        $InputObject | ForEach-Object {
            $k = $_.Key
            $n = $_.Name
            $u = $_.Url

            if($k) {
                $k = $k.ToString().ToLower()

                if($n -and $u) {
                    $u = $u -replace '\{terms\}','$s'
                    $s = [uri]::new($u)
                    $p = $s.IsDefaultPort ? "" : ":$($s.Port)"
                    $s = "$($s.Scheme)://$($s.Host)$p"
                    $vimium[$k] = "${k}: $u blank=$s $n"
                }
            }
        }
    }

    end {
        $vimium.Values
    }
}

function Get-WebSearch {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [ArgumentCompleter({
            Get-WebSearch "$($args[2])*" | Select-Object -ExpandProperty Key
        })]
        [string[]]
        $Key = '*'
    )

    begin {
        $keys = @()
    }

    process {
        $keys += $Key
    }

    end {
        Get-Content $WebSearchJsonPath |
            ConvertFrom-WebSearchJson |
            Where-Object {
                $k = $_.Key
                $keys | Where-Object { $k -like "$($_)*" }
            }
    }
}

function Import-WebSearch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Path
    )

    begin{
        $ht = [ordered]@{}
    }

    process {
        $Path | Get-Item -ErrorAction SilentlyContinue |
            Where-Object { $_ -is [System.IO.FileInfo] } |
            Get-Content |
            ConvertFrom-WebSearchJson |
            ForEach-Object {
                $ht[$_.Key] = $_
            }
    }

    end {
        $ht.Values | ConvertTo-WebSearchJson |
            Out-File $WebSearchJsonPath
    }
}

function Export-WebSearch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Path
    )

    Get-WebSearch |
        ConvertTo-WebSearchJson |
        Out-File $Path
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
        $Term
    )

    $t= [Uri]::EscapeDataString(($Term | Join-String -Separator ' '))

    Get-WebSearch $Key | ForEach-Object {
        $u = $_.Url -replace '\{terms\}',"$t"
        Start-Process $u
    }
}

function Search-Bing {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Term
    )

    Search-Web 'b' $Term
}

function Search-MS {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Term
    )

    Search-Web 'ms' $Term
}

function Search-Api {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Term
    )

    Search-Web 'api' $Term
}

Set-Alias gwse Get-WebSearch
Set-Alias ipwse Import-WebSearch
Set-Alias epwse Export-WebSearch
Set-Alias srweb Search-Web
Set-Alias srbing Search-Bing
Set-Alias srms Search-MS
Set-Alias srapi Search-Api
