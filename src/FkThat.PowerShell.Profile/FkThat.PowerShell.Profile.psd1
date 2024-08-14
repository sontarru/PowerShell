@{
ModuleVersion = '2.0.1'
GUID = '6edd1a8c-65fc-4acc-b9fe-6cfb61c9f87d'
Author = 'fkthat'
CompanyName = 'fkthat.net'
Copyright = '(c) fkthat.net, 2024'
Description = 'The FkThat.PowerShell.Profile module.'
NestedModules = `
    'PSReadLine.psm1',
    'Prompt.psm1',
    'Alias.psm1',
    'GH.psm1',
    'Git.psm1',
    'Docker.psm1',
    'WinGet.psm1'
FunctionsToExport = 'Prompt'
CmdletsToExport = @()
VariablesToExport = @()
AliasesToExport = 'scp', 'ssh', '7z', 'gdiff', 'less', 'nvim', 'sudo', 'tar',
    'vbman', 'ffmpeg', 'winget', 'git', 'gh', 'docker', 'winget'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
