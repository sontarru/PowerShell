@{
RootModule = 'ScaroPro.PowerShell.Git.psm1'
ModuleVersion = '1.0.0'
GUID = 'a812d4ba-2828-4daf-b845-85c463aaa4f0'
Author = 'Scaro.Pro'
CompanyName = 'Scaro.Pro'
Copyright = '(c) Scaro.Pro, 2025'
Description = 'The Git module.'
NestedModules = @('NestedModules/Flow.psm1',
               'NestedModules/Repo.psm1')
FunctionsToExport = 'Get-Git', 'Start-GitFlow', 'Clear-GitRepo'
CmdletsToExport = @()
AliasesToExport = 'sagflow', 'clgrepo'
PrivateData = @{
    PSData = @{
    }
}
}
