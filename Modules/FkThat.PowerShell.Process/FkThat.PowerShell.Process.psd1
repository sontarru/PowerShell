@{

# Script module or binary module file associated with this manifest.
RootModule = 'Process.psm1'

# Version number of this module.
ModuleVersion = '0.0.1'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '2c2a39ad-5641-471b-8334-470c20936ae8'

# Author of this module
Author = 'fkthat.net'

# Company or vendor of this module
CompanyName = 'fkthat.net'

# Copyright statement for this module
Copyright = '(c) fkthat.net, 2025'

# Description of the functionality provided by this module
Description = 'Windows process tools.'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Get-CurrentProcess', 'Get-ParentProcess'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'pscur', 'pspar'

}

