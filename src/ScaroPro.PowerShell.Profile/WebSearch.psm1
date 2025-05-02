$ErrorActionPreference = 'Stop'

$WseJsonPath = "$PSScriptRoot/WebSearch.json"
$WseTypeName = "ScaroPro.PowerShell.Profile.WebSearch"

Update-TypeData -TypeName $WseTypeName `
    -MemberName "SiteUrl" -MemberType "ScriptProperty" -Value {
        $uri = [uri]::new($this.Url)
        $port = $uri.IsDefaultPort ? "" : ":$($uri.Port)"
        "$($uri.Scheme)://$($uri.Host)$port"
    } `
    -Force

Update-TypeData -TypeName $WseTypeName `
    -MemberName "Vimium" -MemberType "ScriptProperty" -Value {
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
    -DefaultDisplayPropertySet "Key","Name","Url" `
    -Force

function Get-WebSearch {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [ArgumentCompleter({
            Get-WebSearch "$($args[2])*" |
                Select-Object -ExpandProperty Key
        })]
        [string[]]
        $Key = '*'
    )

    begin {
        $filters = @()
    }

    process {
        $filters += $Key
    }

    end {
        & {
            try {
                Get-Content $WseJsonPath |
                    ConvertFrom-Json |
                    Where-Object { $_.Key -and $_.Url } |
                    ForEach-Object {
                        [PSCustomObject]@{
                            PSTypeName = $WseTypeName
                            Key = $_.Key
                            Name = $_.Name ? $_.Name : $_.Key
                            Url = $_.Url
                        }
                    }
            }
            catch {
                # Do nothing.
            }
        } |
        Where-Object {
            $x = $_
            $filters | Where-Object { $x.Key -like "$_*" }
        }
    }
}

function Import-WebSearch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string[]]
        # The path to the source file to import from.
        $Path
    )

    begin {
        $wse = [ordered]@{}
    }

    process {
        $Path | Get-Item -ErrorAction SilentlyContinue |
            ForEach-Object {
                try { Get-Content $_ | ConvertFrom-Json -AsHashtable }
                catch { <# do nothing #> }
            } |
            ForEach-Object { $_.GetEnumerator() } |
            Where-Object { $_.Key -and $_.Value -and $_.Value.Url } |
            ForEach-Object {
                $wse[$_.Key] = [pscustomobject]@{
                    Key = $_.Key
                    Name = $_.Value.Name ? $_.Value.Name : $_.Key
                    Url = $_.Value.Url
                }
            }
    }

    end {
        $wse.Values | ConvertTo-Json |
            Out-File $WseJsonPath
    }
}

function Export-WebSearch {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position = 0)]
        [string]
        # The path to the file to import to.
        $Path,

        [switch]
        # Export to VimiumC omnibar search settings.
        $Vimium,

        [switch]
        $Force
    )

    $wse = Get-WebSearch

    if($Vimium) {
        $result = $wse | ForEach-Object {
            "$($_.Key): $($_.Vimium) blank=$($_.SiteUrl) $($_.Name)"
        }
    }
    else {
        $result = $wse | ForEach-Object `
            -Begin { $r = [ordered]@{} } `
            { $r[$_.Key] = [ordered]@{ Name = $_.Name; Url = $_.Url } } `
            -End { $r } |
            ConvertTo-Json
    }

    if($Path) {
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
        [ArgumentCompleter({
            Get-WebSearch "$($args[2])*" |
                Select-Object -ExpandProperty Key
        })]
        [string[]]
        $Key,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Term
    )

    Get-WebSearch $Key | ForEach-Object {
        Start-Process ($Term ? ($_.BuildSearchUrl($Term)) : $_.SiteUrl)
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
