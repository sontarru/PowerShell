$ErrorActionPreference = 'Stop'

function Test-Admin {
    if($IsWindows) {
        $Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $Principal = New-Object Security.Principal.WindowsPrincipal $Identity
        return $Principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    }
    elseif($IsLinux) {
        return ((id -u) -eq 0)
    }
}
