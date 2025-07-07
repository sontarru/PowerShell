@{
ModuleVersion = '1.1.0'
GUID = '466623f1-635e-4eba-a464-5cad5c9632d5'
Author = 'sontar.ru'
CompanyName = 'sontar.ru'
Copyright = '(c) sontar.ru, 2025'
Description = 'PowerShell profile.'
NestedModules = @('NestedModules\Alias.psm1',
               'NestedModules\Docker.psm1',
               'NestedModules\DotNet.psm1',
               'NestedModules\Git.psm1',
               'NestedModules\GitHub.psm1',
               'NestedModules\GitLab.psm1',
               'NestedModules\Prompt.psm1',
               'NestedModules\PSReadLine.psm1',
               'NestedModules\WinGet.psm1')
FunctionsToExport = 'Prompt'
CmdletsToExport = @()
VariablesToExport = '*'
AliasesToExport = 'scp', 'code', 'less', 'ssh', 'psxp', 'tar', 'devenv', 'gdiff', 'nvim', 'vs', '7z',
               'lua', 'gsudo', 'ffmpeg', 'vbman', 'docker', 'dotnet', 'git', 'gh', 'glab',
               'winget'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
