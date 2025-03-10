@{

# Version number of this module.
ModuleVersion = '0.0.4'

# ID used to uniquely identify this module
GUID = '466623f1-635e-4eba-a464-5cad5c9632d5'

# Author of this module
Author = 'fkthat'

# Company or vendor of this module
CompanyName = 'fkthat.net'

# Copyright statement for this module
Copyright = '(c) fkthat.net, 2025'

# Description of the functionality provided by this module
Description = 'PowerShell profile.'

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = 'Prompt.psm1', 'PSReadLine.psm1', 'Git.psm1',
    'DotNet.psm1', 'Docker.psm1', 'GH.psm1'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Prompt'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'docker', 'gh'

}

