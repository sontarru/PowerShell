@{
RootModule = 'Sontar.PowerShell.WebSearch.psm1'
ModuleVersion = '0.0.1'
GUID = '2cce7017-a3e5-490f-a87b-0b912b4a38a9'
Author = 'rnovo'
CompanyName = 'rnovo'
Copyright = '(c) rnovo, 2025'
Description = 'Web search from command prompt.'
NestedModules = @()
FunctionsToExport = 'Search-MS', 'Search-Bing', 'Update-WebSearchEngine',
               'New-WebSearchEngines', 'Search-Api', 'ConvertTo-VimiumSearch',
               'Export-WebSearchEngine', 'Get-WebSearchEngine',
               'Remove-WebSearchEngime', 'Import-WebSearchEngine', 'Search-Web'
AliasesToExport = 'ipwse', 'srms', 'rwse', 'gwse', 'epwse', 'nwse', 'srb', 'udwse', 'srapi', 'srweb'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
