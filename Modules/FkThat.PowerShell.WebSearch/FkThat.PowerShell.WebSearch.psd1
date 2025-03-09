@{

# Script module or binary module file associated with this manifest.
RootModule = 'WebSearch.psm1'

# Version number of this module.
ModuleVersion = '0.0.1'

# ID used to uniquely identify this module
GUID = '6406f921-78b7-42ea-87e2-566bbf9811d1'

# Author of this module
Author = 'fkthat'

# Company or vendor of this module
CompanyName = 'fkthat.net'

# Copyright statement for this module
Copyright = '(c) fkthat.net, 2025'

# Description of the functionality provided by this module
Description = 'Web search module.'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Get-WebSearchEngine', 'Import-WebSearchEngine', 'ConvertTo-VimiumSearch',
    'Search-Web', 'Search-Bing', 'Search-MS', 'Search-Api'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'gwse', 'ipwse', 'srweb', 'srbing', 'srms', 'srapi'

}
