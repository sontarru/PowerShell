<#
.SYNOPSIS
Uninstalls old module (PSResource) versions.
#>

Get-InstalledPSResource | Select-Object Name, Version | Group-Object Name |
  ForEach-Object {
    $_.Group | Sort-Object Version -Descending | Select-Object -Skip 1 |
      ForEach-Object { Uninstall-PSResource $_.Name -Version $_.Version }
  }

