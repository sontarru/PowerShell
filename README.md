# PowerShell module collection

## Installation

```powershell
$env:GITHUB_REPOSITORY_OWNER = 'fkthat'
$env:REGISTRY_RO_PAT = '***'

Invoke-WebRequest 'https://raw.githubusercontent.com/fkthat/PowerShell/develop/Setup.ps1' |
    Select-Object -ExpandProperty Content | Invoke-Expression
```
