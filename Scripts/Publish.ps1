[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $ApiKey
)

$moduleRoot = Join-Path $PSScriptRoot 'Modules'

foreach($mod in (Get-ChildItem $moduleRoot)) {
    $psd = Join-Path $mod "$($mod.Name).psd1"
    $ver = (Get-Content $psd -Raw | Invoke-Expression).ModuleVersion

    if(-not (Find-PSResource $mod.Name -Version $ver -Repository GitHub -ErrorAction SilentlyContinue)) {
        Write-Host "Publish $($mod.Name)."
        Publish-PSResource $mod -Repository GitHub -ApiKey $ApiKey -ErrorAction Continue
    }
    else {
        Write-Host "Skip $($mod.Name)."
    }
}
