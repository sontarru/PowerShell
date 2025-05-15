$ErrorActionPreference = "Stop"

$glab = $IsWindows ? "${env:ProgramFiles(x86)}\glab\glab.exe" : (which gh)

if(Get-Command $glab -ErrorAction SilentlyContinue) {
    Set-Alias glab $glab

    # The hack for lazy loading GitLab CLI completion
    # However, this requires pressing <Tab> twice the first time.
    Register-ArgumentCompleter -Native -CommandName glab -ScriptBlock {
        # Requires New-Module to put some "hidden" functions to the global scope
        $null = New-Module {
            glab completion --shell powershell |
                Out-String | Invoke-Expression
        }
    }
}

