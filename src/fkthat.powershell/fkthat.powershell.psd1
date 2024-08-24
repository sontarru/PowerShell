@{
ModuleVersion = '1.0.0'
GUID = '6edd1a8c-65fc-4acc-b9fe-6cfb61c9f87d'
Author = 'fkthat'
CompanyName = 'fkthat.net'
Copyright = '(c) fkthat.net, 2024'
Description = 'The module to import from $PROFILE. ' +
    'It provides tab completion for some often used application (git, winget, dotnet, gh)' +
    'as well as various utility functions and aliases.'
RequiredModules = @()
NestedModules = 'Aliases.psm1', 'Docker.psm1', 'DotNet.psm1', 'GH.psm1',
    'Git.psm1', 'Prompt.psm1', 'PSReadLine.psm1', 'WinGet.psm1', 'SystemTray.psm1',
    'Content.psm1', 'Password.psm1', 'Process.psm1', 'Path.psm1'
FunctionsToExport = 'Prompt', 'Start-GitFlow', 'Clear-GitRepo', 'Reset-SystemTray',
    'Compare-Content', 'Update-Content', 'Update-ContentEol', 'Update-ContentEolToDos',
    'Update-ContentEolToUnix','Get-RandomPassword', 'Test-PasswordStrength',
    'Get-CurrentProcess', 'Get-ParentProcess', 'Reset-Path'
CmdletsToExport = @()
VariablesToExport = @()
AliasesToExport = '7z', 'code', 'ffmpeg', 'gdiff', 'less', 'node', 'npm', 'nvim', 'nvm', 'scp',
    'ssh', 'sudo', 'tar', 'vbman', 'vs', 'winget', 'gh', 'docker', 'saflow', 'clgit', 'rstray',
    'cdiff', 'dos2unix', 'sed', 'ueol', 'unix2dos', 'gpwd', 'pscur', 'pspar', 'rspath'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
