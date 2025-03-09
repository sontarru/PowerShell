$ErrorActionPreference = 'Stop'

if(-not $IsWindows) {
    Write-Error 'Not supported platform.'
}

$WebSearchDB = "$PSScriptRoot\WebSearch.json"

function Get-WebSearchEngine {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [SupportsWildcards()]
        [string]
        $Keyword = '*'
    )

    if(Test-Path $WebSearchDB) {
        $db = Get-Content $WebSearchDB |
            ConvertFrom-Json -AsHashtable

        foreach($key in ($db.Keys | Sort-Object)) {
            if($key -like $Keyword) {
                $v = $db[$key]
                [PSCustomObject]@{
                    Keyword = $key
                    Name = $v.Name
                    SearchUrl = $v.SearchUrl
                    SiteUrl = $v.SiteUrl
                }
            }
        }
    }
}

function Import-WebSearchEngine {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Path
    )

    Copy-Item $Path $WebSearchDB
}

function ConvertTo-VimiumSearch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [psobject[]]
        $InputObject
    )

    process {
        $InputObject | ForEach-Object {
            "$($_.Keyword): $($_.SearchUrl -replace '\{terms\}','$s') blank=$($_.SiteUrl) $($_.Name)"
        }
    }
}

function Search-Web {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string[]]
        $Keyword,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Term
    )

    $terms = [Uri]::EscapeDataString(($Term | Join-String -Separator ' '))

    $Keyword | ForEach-Object { Get-WebSearchEngine $_ } |
        ForEach-Object { $terms ? ($_.SearchUrl -replace '\{terms\}',$terms) : $_.SiteUrl } |
        ForEach-Object { Start-Process $_ }
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

Set-Alias gwse Get-WebSearchEngine
Set-Alias ipwse Import-WebSearchEngine
Set-Alias srweb Search-Web
Set-Alias srbing Search-Bing
Set-Alias srms Search-MS
Set-Alias srapi Search-Api
