@{
ModuleVersion = '1.0.0'
GUID = '24ff383f-1dff-4c5d-a3e4-e94313849875'
Author = 'Scaro.Pro'
CompanyName = 'Scaro.Pro'
Copyright = '(c) Scaro.Pro, 2025'
Description = 'Development tools for this repo.'
NestedModules = @('NestedModules/Module.psm1', 
               'NestedModules/Options.psm1')
FunctionsToExport = 'Update-DevelopmentModuleManifest', 'Get-DevelopmentModule', 
               'Optimize-DevelopmentModuleManifest', 'New-DevelopmentModule', 
               'Get-DevelopmentOptions'
CmdletsToExport = @()
AliasesToExport = @()
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
