# PowerShell module collection

## Installation

```powershell
$env:GITHUB_REPOSITORY_OWNER = 'fkthat'
$env:GITHUB_TOKEN = '***'

Invoke-WebRequest `
    "https://raw.githubusercontent.com/$env:GITHUB_REPOSITORY_OWNER/PowerShell/develop/Setup.ps1" |
    Select-Object -ExpandProperty Content | Invoke-Expression
```
