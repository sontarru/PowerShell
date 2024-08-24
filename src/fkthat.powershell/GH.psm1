$ErrorActionPreference = 'Stop'

$script:CompleterRegistered = $false

if(Get-Command gh -ErrorAction SilentlyContinue) {
    if(-not $script:CompleterRegistered) {
        gh completion -s powershell | Out-String | Invoke-Expression
        $script:CompleterRegistered = $true
    }
}
