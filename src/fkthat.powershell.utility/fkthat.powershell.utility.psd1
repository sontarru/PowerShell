@{
ModuleVersion = '1.0.0'
GUID = '64abed9f-34a1-4954-a2bb-abda86ab0e18'
Author = 'fkthat'
CompanyName = 'fkthat.net'
Copyright = '(c) fkthat.net, 2024'
Description = 'The Fkthat.PowerShell.Utility module.'
NestedModules = 'Path.psm1', 'SystemTray.psm1', 'Password.psm1', 'Content.psm1'
FunctionsToExport = 'Reset-Path', 'Reset-SystemTray', 'Get-RandomPassword',
    'Compare-Content', 'Update-Content', 'Update-ContentEol',
     'Update-ContentEolToDos', 'Update-ContentEolToUnix'
CmdletsToExport = @()
VariablesToExport = @()
AliasesToExport = 'rspath', 'rstray', 'gpwd',
    'cdiff', 'dos2unix', 'sed', 'ueol', 'unix2dos'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
