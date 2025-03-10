@{

# Script module or binary module file associated with this manifest.
RootModule = 'Content.psm1'

# Version number of this module.
ModuleVersion = '0.0.3'

# ID used to uniquely identify this module
GUID = '7909a7cb-57af-4dd4-b14d-b9a7ea2d3039'

# Author of this module
Author = 'fkthat'

# Company or vendor of this module
CompanyName = 'fkthat.net'

# Copyright statement for this module
Copyright = '(c) fkthat.net, 2025'

# Description of the functionality provided by this module
Description = 'Text content tools.'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Compare-Content', 'Update-Content', 'Update-ContentEol',
               'Update-ContentEolToDos', 'Update-ContentEolToUnix'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'crc', 'udc', 'udeol', 'dos2unix', 'unix2dos'

}

