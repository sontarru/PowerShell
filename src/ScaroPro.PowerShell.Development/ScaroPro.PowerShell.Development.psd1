@{
ModuleVersion = '1.0.0'
GUID = 'fbb2c586-9a97-4a58-9c88-294fb1ac5d93'
Author = 'Scaro.Pro'
CompanyName = 'Scaro.Pro'
Copyright = '(c) Scaro.Pro, 2025'
Description = 'Development tools for this repo.'

NestedModules =
    'NestedModules/Options.psm1',
    'NestedModules/Module.psm1'

FunctionsToExport =
    'Get-DevelopmentOptions',
    'Get-DevelopmentModule',
    'New-DevelopmentModule',
    'Update-DevelopmentModule',
    'Optimize-DevelopmentModule'
}
