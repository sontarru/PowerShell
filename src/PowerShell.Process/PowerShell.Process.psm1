$ErrorActionPreference = "Stop"

function Get-CurrentProcess {
    [System.Diagnostics.Process]::GetCurrentProcess()
}

function Get-ParentProcess {
    Get-CurrentProcess | Select-Object -ExpandProperty Parent
}
