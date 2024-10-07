[CmdletBinding()]
param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Name
)

$dir = Join-Path $PSScriptRoot '..' 'src' $Name
$null = New-Item -Path (Join-Path $dir "$($Name).psm1") -Force

$null = New-ModuleManifest `
    -Path (Join-Path $dir "$($Name).psd1") `
    -RootModule "$Name.psm1" `
    -ModuleVersion "1.0.0" `
    -Description "The $Name module." `
    -Author "fkthat" `
    -Company "fkthat.net" `
    -Copyright "(c) fkthat.net, $(Get-Date -Format 'yyyy')" `
    -VariablesToExport @() `
    -CmdletsToExport @() `
    -FunctionsToExport @() `
    -AliasesToExport @() `
    -RequiredModules @() `
    -NestedModules @()
