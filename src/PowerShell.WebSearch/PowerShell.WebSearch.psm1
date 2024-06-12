using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

$ErrorActionPreference = "Stop"

$Wse = Join-Path $PSScriptRoot 'wse.json'

class WseKeyArgumentCompleter : IArgumentCompleter {
    [IEnumerable[CompletionResult]] CompleteArgument(
            [string] $CommandName,
            [string] $parameterName,
            [string] $wordToComplete,
            [CommandAst] $commandAst,
            [IDictionary] $fakeBoundParameters) {
        $r = [List[CompletionResult]]::new()
        Get-WebSearchEngine "$wordToComplete*" |
            ForEach-Object { $r.Add([CompletionResult]::new($_.Key)) }
        return $r
    }
}

class WseKeyArgumentCompleterAttribute : ArgumentCompleterAttribute, IArgumentCompleterFactory {
    [IArgumentCompleter] Create() { return [WseKeyArgumentCompleter]::new() }
}

<#
.SYNOPSIS
Gets registered search engines.
#>
function Get-WebSearchEngine {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [WseKeyArgumentCompleterAttribute()]
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
        Get-Content $Wse -ErrorAction SilentlyContinue |
            ConvertFrom-Json | ForEach-Object {
                $k = $_.Key
                if($k) {
                    $n = $_.Name ?? $k
                    $u = $_.Url
                    if($u) {
                        [PSCustomObject]@{
                            Key = $k
                            Name = $n
                            Url = $u
                        }
                    }
                }
            } |
            Where-Object {
                $k = $_.Key
                $keys | Where-Object { $k -like $_ }
            }
    }
}

<#
.SYNOPSIS
Adds a new search engine.
#>
function New-WebSearchEngines {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Key,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [uri]
        $Url,

        [switch]
        $Force
    )

    $Name = $Name ? $Name : $Key
    $all = @() + (Get-WebSearchEngine)
    $existing = $all | Where-Object Key -eq $Key
    $save = { $all | ConvertTo-Json -AsArray | Out-File $Wse }

    if(-not $existing) {
        $new = [PSCustomObject]@{
            Key = $Key
            Name = $Name
            Url = $Url
        }

        $all += $new
        &$save
        $new
    }
    elseif ($Force) {
        $existing.Name = $Name
        $existing.Url = $Url
        &$save
        $existing
    }
    else {
        Write-Error "The engine '$Key' already exists."
    }
}

<#
.SYNOPSIS
Updates a search engine.
#>
function Update-WebSearchEngine {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [WseKeyArgumentCompleterAttribute()]
        [string]
        $Key,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [uri]
        $Url,

        [switch]
        $PassThrough
    )

    $all = Get-WebSearchEngine
    $engine = $all | Where-Object Key -EQ $Key

    if($engine) {
        if($Name) {
            $engine.Name = $Name
        }

        if($Url) {
            $engine.Url = $Url
        }

        $all | ConvertTo-Json |
            Out-File $Wse

        if($PassThrough) {
            Write-Output $engine
        }
    }
    else {
        Write-Error "Cannot find the '$Key' web search engine."
    }
}

<#
Removes a specified web search engine.
#>
function Remove-WebSearchEngime {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [WseKeyArgumentCompleterAttribute()]
        [string[]]
        $Key,

        [switch]
        $Force
    )

    begin {
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = 'None'
        }

        $all = [ordered]@{}
        Get-WebSearchEngine | ForEach-Object { $all[$_.Key] = $_ }
        $remove = @{}
    }

    process {
        $Key | ForEach-Object {
            $k = $_
            $all.Keys | Where-Object { $_ -Like $k } | ForEach-Object {
                $remove[$_] = $true
            }
        }
    }

    end {
        foreach($r in $remove.Keys) {
            if($PSCmdlet.ShouldProcess($r)) {
                $all.Remove($r)
            }
        }

        $all.Values | ConvertTo-Json |
            Out-File $Wse -Confirm:$false
    }
}

<#
.SYNOPSIS
Writes registered search engines to the specified file or the output.
#>
function Export-WebSearchEngine {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]
        $Path
    )

    $ht = [ordered]@{}

    Get-WebSearchEngine | ForEach-Object {
        $ht[$_.Key] ??= [ordered]@{}
        $ht[$_.Key] = [ordered]@{ Name = $_.Name; Url = $_.Url }
    }

    $f = { $ht | ConvertTo-Json }
    $Path ? (&$f | Out-File $Path) : (&$f)
}



<#
Reads and adds search engines from a specified file.
#>
function Import-WebSearchEngine {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Path,

        [switch]
        $PassThrough
    )

    $ht = Get-Content $Path | ConvertFrom-Json -AsHashtable

    $ht.Keys | ForEach-Object {
        $k = $_
        if($k) {
            $n = $ht[$k]["Name"] ?? $k
            $u = $ht[$k]["Url"]
            if($u) {
                if(-not (Update-WebSearchEngine $k -Name $n -Url $u -PassThrough `
                            -ErrorAction SilentlyContinue)) {
                    $null = New-WebSearchEngines $k -Name $n -Url $u
                }

                if($PassThrough) {
                    [PSCustomObject]@{
                        Key = $k
                        Name = $n
                        Url = $u
                    }
                }
            }
        }
    }
}

<#
.SYNOPSIS
Converts the input to Vimium omnibar search settings.
#>
function ConvertTo-VimiumSearch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $InputObject | ForEach-Object {
            $k = $_.Key
            if($k) {
                $n = $_.Name ?? $k
                $u = $_.Url
                if($u) {
                    $u = $_.Url -replace '\{terms\}','$s'
                    $s = [uri]::new($u)
                    $p = $s.IsDefaultPort ? "" : ":$($s.Port)"
                    $s = "$($s.Scheme)://$($s.Host)$p"
                    "$($k): $u blank=$s $n"
                }
            }
        }
    }
}

<#
.SYNOPSIS
Opens a web search result page in the default browser.
#>
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

<#
.SYNOPSIS
Opens a Bing search result page in the default browser.
#>
function Search-Bing {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Terms
    )

    Search-Web 'b' $Terms
}

<#
.SYNOPSIS
Opens a MS learning search result page in the default browser.
#>
function Search-MS {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Terms
    )

    Search-Web 'ms' $Terms
}

<#
.SYNOPSIS
Opens a Microsoft API search result page in the default browser.
#>
function Search-Api {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments)]
        [string[]]
        $Terms
    )

    Search-Web 'api' $Terms
}

Set-Alias gwse Get-WebSearchEngine
Set-Alias nwse New-WebSearchEngines
Set-Alias udwse Update-WebSearchEngine
Set-Alias rwse Remove-WebSearchEngime
Set-Alias epwse Export-WebSearchEngine
Set-Alias ipwse Import-WebSearchEngine
Set-Alias srweb Search-Web
Set-Alias srb Search-Bing
Set-Alias srms Search-MS
Set-Alias srapi Search-Api
