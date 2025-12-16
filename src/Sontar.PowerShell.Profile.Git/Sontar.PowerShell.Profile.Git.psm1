$ErrorActionPreference = "Stop"

# The hack for lazy loading the Posh-Git module
# However, this requires pressing <Tab> twice the first time.
Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
    Import-Module Posh-Git -ErrorAction SilentlyContinue
}
