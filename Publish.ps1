[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $ApiKey
)

foreach($mod in (Get-ChildItem (Join-Path $PSScriptRoot 'Modules'))) {
    Publish-PSResource $mod -Repository GitHub -ApiKey $ApiKey -ErrorAction Continue
}
