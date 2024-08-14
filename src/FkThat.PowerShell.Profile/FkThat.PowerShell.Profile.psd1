@{
ModuleVersion = '2.1.0'
GUID = '6edd1a8c-65fc-4acc-b9fe-6cfb61c9f87d'
Author = 'fkthat'
CompanyName = 'fkthat.net'
Copyright = '(c) fkthat.net, 2024'
Description = 'The FkThat.PowerShell.Profile module.'
NestedModules = `
    'PSReadLine.psm1',
    'Prompt.psm1',
    'GH.psm1',
    'Git.psm1',
    'Docker.psm1',
    'WinGet.psm1',
    'DotNet.psm1'
FunctionsToExport = 'Prompt'
CmdletsToExport = @()
VariablesToExport = @()
AliasesToExport = 'winget', 'git', 'gh', 'docker', 'winget', 'dotnet'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
