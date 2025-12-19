@{
RootModule = 'Sontar.PowerShell.WebSearch.psm1'
ModuleVersion = '0.0.1'
GUID = '2cce7017-a3e5-490f-a87b-0b912b4a38a9'
Author = 'rnovo'
CompanyName = 'rnovo'
Copyright = '(c) rnovo, 2025'
Description = 'Web search from command prompt.'
NestedModules = @()
FunctionsToExport = 'Export-WebSearchEngine', 'Search-Web', 'Search-Bing', 'Search-MS',
               'Search-Api', 'Get-WebSearchEngine', 'Import-WebSearchEngine'
CmdletsToExport = @()
AliasesToExport = 'gwse', 'srms', 'ipwse', 'srapi', 'srweb', 'epwse', 'srbing'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
