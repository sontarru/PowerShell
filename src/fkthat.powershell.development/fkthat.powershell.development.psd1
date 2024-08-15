@{
ModuleVersion = '2.3.0'
GUID = '99343d2b-4e30-4514-b605-43af53acd938'
Author = 'fkthat'
CompanyName = 'fkthat.net'
Copyright = '(c) fkthat.net, 2024'
Description = 'The FkThat.PowerShell.Development module.'
NestedModules = 'Alias.psm1', 'Git.psm1', 'CodeCoverage.psm1'
FunctionsToExport = 'Start-GitFlow', 'Clear-GitRepo', 'New-CodeCoverageReport'
CmdletsToExport = @()
VariablesToExport = @()
AliasesToExport = 'code', 'vs', 'node', 'npm', 'saflow', 'clgit', 'nccr'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
