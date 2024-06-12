$ErrorActionPreference = "Stop"

$gh = $IsWindows ? "$env:ProgramFiles\GitHub CLI\gh.exe" : (which gh)

if(Get-Command $gh -ErrorAction SilentlyContinue) {
    Set-Alias gh $gh

    # The hack for lazy loading GitHub CLI completion
    # However, this requires pressing <Tab> twice the first time.
    Register-ArgumentCompleter -Native -CommandName gh -ScriptBlock {
        # Requires New-Module to put some "hidden" functions to the global scope
        $null = New-Module {
            gh completion --shell powershell |
                Out-String | Invoke-Expression
        }
    }
}
