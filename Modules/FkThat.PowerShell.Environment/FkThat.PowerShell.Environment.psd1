@{

# Script module or binary module file associated with this manifest.
RootModule = 'Environment.psm1'

# Version number of this module.
ModuleVersion = '0.0.4'

# ID used to uniquely identify this module
GUID = '0c9a78f4-6934-4dca-9ce8-f22b0da14cfb'

# Author of this module
Author = 'fkthat'

# Company or vendor of this module
CompanyName = 'fkthat.net'

# Copyright statement for this module
Copyright = '(c) fkthat.net, 2025'

# Description of the functionality provided by this module
Description = 'Environment tools.'

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Get-Environment', 'Import-Environment', 'Export-Environment'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'genv', 'ipenv', 'epenv'

}
