$ErrorActionPreference = 'Stop'

$Script:HtmlAgilityImported = $false

function Import-HtmlAgilityPack {
    if(-not $Script:HtmlAgilityImported) {
        Add-Type -Path (Join-Path $PSScriptRoot 'HtmlAgilityPack.dll')
        $Script:HtmlAgilityImported = $true
    }
}

function Get-Html {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ByUri', ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [uri]
        $Uri,

        [Parameter(Mandatory, ParameterSetName = 'ByPath', ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string]
        $Path
    )

    begin {
        $src = [ordered]@{}
    }

    process {
        $Uri | ForEach-Object {
            $src[$_.ToString()] = @{
                Uri = $_
            }
        }

        $Path | Get-Item -ErrorAction SilentlyContinue |
            Where-Object { $_ -is [System.IO.FileInfo] } |
            ForEach-Object {
                $src[$_.FullName] = @{
                    Path = $_.FullName
                }
            }
    }

    end {
        Import-HtmlAgilityPack

        $htmlWeb = $null

        $src.Values | ForEach-Object {
            if($_.Path) {
                $htmldoc = [HtmlAgilityPack.HtmlDocument]::new()
                $htmldoc.Load($_.Path)
                $htmldoc
            }
            if($_.Uri) {
                $htmlWeb = $htmlWeb ? $htmlWeb : [HtmlAgilityPack.HtmlWeb]::new()
                $htmlWeb.Load($_.Uri)
            }
        }
    }
}

Set-Alias ghtml Get-Html
