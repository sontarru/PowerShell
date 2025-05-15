@{
RootModule = 'ScaroPro.PowerShell.WebSearch.psm1'
ModuleVersion = '1.0.0'
GUID = '14ae1933-10c9-44e6-a26e-2220e64de77c'
Author = 'Scaro.Pro'
CompanyName = 'Scaro.Pro'
Copyright = '(c) Scaro.Pro, 2025'
Description = 'The WebSearch module.'
NestedModules = @()
FunctionsToExport = 'ConvertTo-WebSearchJson', 'Search-Api', 'Get-WebSearch', 'Search-MS', 
               'Search-Web', 'Search-Bing', 'ConvertFrom-WebSearchJson', 
               'Export-WebSearch', 'Import-WebSearch', 'ConvertTo-WebSearchVimium'
CmdletsToExport = @()
AliasesToExport = 'epwse', 'srapi', 'srbing', 'srms', 'gwse', 'ipwse', 'srweb'
PrivateData = @{
    PSData = @{
    } 
} 
}
