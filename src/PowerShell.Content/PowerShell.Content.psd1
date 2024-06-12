@{
RootModule = 'PowerShell.Content.psm1'
ModuleVersion = '1.0.0'
GUID = '521fe95a-1429-487c-b872-0ee78ba2e293'
Author = 'Mosja.Dev'
CompanyName = 'Mosja.Dev'
Copyright = '(c) Mosja.Dev, 2025'
Description = 'Text content tools.'
NestedModules = @()
FunctionsToExport = 'Update-ContentEolToDos', 'Update-ContentEol', 'Compare-Content',
               'Update-Content', 'Update-ContentEolToUnix'
CmdletsToExport = @()
VariablesToExport = @()
AliasesToExport = 'sed', 'dos2unix', 'udc', 'fdiff', 'udeol', 'unix2dos'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
