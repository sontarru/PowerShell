$ErrorActionPreference = "Stop"

function Reset-SystemTray {
    Assert-Windows

    Stop-Process -Name 'explorer' -Force -ErrorAction Stop

    Remove-Item 'HKCU:\Control Panel\NotifyIconSettings' -Recurse -Force `
        -ErrorAction SilentlyContinue

    Remove-ItemProperty `
        'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify\' `
        -Name 'IconStreams','PastIconsStream' -ErrorAction SilentlyContinue

    Start-Process 'explorer'
}
