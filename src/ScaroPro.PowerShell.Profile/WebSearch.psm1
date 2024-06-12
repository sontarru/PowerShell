using namespace System.Collections.Generic

$ErrorActionPreference = 'Stop'

$DefaultStorePath = "$PSScriptRoot\WebSearch.json"
$WseTypeName = "ScaroPro.PowerShell.Profile.WebSearchEngine"

Update-TypeData -TypeName $WseTypeName `
    -MemberName "SiteUrl" -MemberType "ScriptProperty" -Value {
        $uri = [uri]::new($this.Url)
        $port = $uri.IsDefaultPort ? "" : ":$($uri.Port)"
        "$($uri.Scheme)://$($uri.Host)$port"
    } `
    -Force

Update-TypeData -TypeName $WseTypeName `
    -MemberName "VimiumUrl" -MemberType "ScriptProperty" -Value {
        $this.Url -replace '\{terms\}','$s'
    } `
    -Force

Update-TypeData -TypeName $WseTypeName `
    -MemberName "BuildSearchUrl" -MemberType "ScriptMethod" -Value {
        param([string[]] $term)
        $terms = [Uri]::EscapeDataString(($term | Join-String -Separator ' '))
        $this.Url -replace '\{terms\}',$terms
    } `
    -Force

Update-TypeData -TypeName $WseTypeName `
    -DefaultDisplayPropertySet "Key","Name","Url"

function Get-WebSearchEngine {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [ArgumentCompleter({
            Get-WebSearchEngine "$($args[2])*" |
                Select-Object -ExpandProperty Keyword
        })]
        [string[]]
        $Key,

        [Parameter()]
        [string]
        $StorePath = $DefaultStorePath
    )

    begin {
        $result = @{}
        $all = @()

        try {
            $all = Get-Content $StorePath |
                ConvertFrom-Json | ForEach-Object {
                    $k = $_.Key
                    $name = $_.Name ? $_.Name : $kw
                    $url = $_.Url

                    if($k -and $name -and $url) {
                        [PSCustomObject]@{
                            PSTypeName = $WseTypeName
                            Key = $k
                            Name = $name
                            Url = $url
                        }
                    }
                }
        }
        catch {
            # Do nothing.
        }
    }

    process {
        $Key | ForEach-Object {
            $filter = "$($_)*"
            $all | ForEach-Object {
                if($_.Key -like $filter) {
                    $result[$_.Key] = $_
                }
            }
        }
    }

    end {
        $result.Values | Sort-Object Key
    }
}

function Import-WebSearchEngine {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string[]]
        # The path to the source file to import from.
        $Path,

        [switch]
        # Append to the existing search engines.
        $Append,

        [Parameter()]
        [string]
        $StorePath = $DefaultStorePath
    )

    begin {
        $wse = @{}

        if($Append) {
            Get-WebSearchEngine | ForEach-Object {
                $wse[$_.Key] = $_
            }
        }
    }

    process {
        $Path | Get-Item -ErrorAction SilentlyContinue |
            ForEach-Object {
                try {
                    Get-Content $_ | ConvertFrom-Json -AsHashtable
                } catch {
                    # do nothing
                }
            } |
            ForEach-Object {
                foreach ($key in $_.Keys) {
                    if($key) {
                        $props = $_[$key]
                        $name = $props.Name
                        $name = $name ? $name : $key
                        if($name) {
                            $url = $props.Url
                            if($url) {
                                $wse[$key] = [pscustomobject]@{
                                    Key = $key
                                    Name = $name
                                    Url = $url
                                }
                            }
                        }
                    }
                }
            }
    }

    end {
        $wse.Values | Sort-Object Key |
            ConvertTo-Json | Out-File $StorePath
    }
}

function Export-WebSearchEngine {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position = 0)]
        [string]
        # The path to the file to import to.
        $Path,

        [switch]
        # Export to VimiumC omnibar search settings.
        $Vimium,

        [Parameter()]
        [string]
        $StorePath = $DefaultStorePath
    )

    $wse = Get-WebSearchEngine -StorePath $StorePath

    if($Vimium) {
        $result = $wse | ForEach-Object {
            "$($_.Key): $($_.VimiumUrl) blank=$($_.SiteUrl) $($_.Name)"
        }
    }
    else {
        $result = $wse | ForEach-Object `
            -Begin { $r = [ordered]@{} } `
            { $r[$_.Key] = @{ Name = $_.Name; Url = $_.Url } } `
            -End { $r } |
            ConvertTo-Json
    }

    if($Path) {
        if(Test-Path $Path -PathType Container) {
            Remove-Item $Path -Recurse -Force:$Force
        }

        Set-Content $Path -Value $result -Force:$Force
    }
    else {
        $result
    }
}

function Search-Web {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string[]]
        $Key,

        [Parameter()]
        [string]
        $StorePath = $DefaultStorePath,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Term
    )

    Get-WebSearchEngine $Key -StorePath $StorePath |
        ForEach-Object { Start-Process ($Term ? ($_.BuildSearchUrl($Term)) : $_.SiteUrl) }
}

function Search-Bing {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $StorePath = $DefaultStorePath,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Term
    )

    Search-Web 'b' -StorePath $StorePath $Term
}
function Search-MS {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $StorePath = $DefaultStorePath,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Term
    )

    Search-Web 'ms' -StorePath $StorePath $Term
}

function Search-Api {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $StorePath = $DefaultStorePath,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Term
    )

    Search-Web 'api' -StorePath $StorePath $Term
}

Set-Alias gwse Get-WebSearchEngine
Set-Alias ipwse Import-WebSearchEngine
Set-Alias srweb Search-Web
Set-Alias srbing Search-Bing
Set-Alias srms Search-MS
Set-Alias srapi Search-Api
