$ErrorActionPreference = "Stop"

# The hack for lazy loading GitLab CLI completion
# However, this requires pressing <Tab> twice the first time.
Register-ArgumentCompleter -Native -CommandName glab -ScriptBlock {
    # Invoke New-Module to put some "hidden" functions to the global scope
    $null = New-Module {
        glab completion --shell powershell |
            Out-String | Invoke-Expression
    }
}
