@{

# Script module or binary module file associated with this manifest.
RootModule = 'Git.psm1'

# Version number of this module.
ModuleVersion = '0.0.2'

# ID used to uniquely identify this module
GUID = '65cd1c29-6c79-43c3-bbea-b4dc9cea74e8'

# Author of this module
Author = 'fkthat'

# Company or vendor of this module
CompanyName = 'fkthat.net'

# Copyright statement for this module
Copyright = '(c) fkthat.net, 2025'

# Description of the functionality provided by this module
Description = 'Git tools.'

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Start-GitFlow', 'Clear-GitRepo'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'saflow', 'clgit'

}

