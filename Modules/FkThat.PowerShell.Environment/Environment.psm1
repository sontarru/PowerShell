$ErrorActionPreference = "Stop"

if(-not $IsWindows) {
    Write-Error 'Not supported platform.'
}

$RegKeys = @{
    'User' = 'HKCU:\Environment'
    'System' = 'HKLM:\System\CurrentControlSet\Control\Session Manager\Environment'
}
function Import-Environment {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    $src = Join-Path $PSScriptRoot 'Environment.json'
    $env = Get-Content $src | ConvertFrom-Json -AsHashtable

    foreach($scope in $env.Keys) {
        $reg = $RegKeys[$scope]

        foreach($name in $env[$scope].Keys) {
            $val = $env[$scope][$name]

            if($val) {
                Set-ItemProperty $reg -Name $name -Value $val
            }
            else {
                if(Get-ItemProperty $reg -Name $name -ErrorAction SilentlyContinue) {
                    Remove-ItemProperty $reg -Name $name
                }
            }
        }
    }
}

Set-Alias ipenv Import-Environment
