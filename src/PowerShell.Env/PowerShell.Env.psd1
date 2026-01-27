@{
RootModule = 'PowerShell.Env.psm1'
ModuleVersion = '1.0.0'
GUID = '7797517c-266b-4ac0-acf2-acfac736c099'
Author = 'Mosja.Dev'
CompanyName = 'Mosja.Dev'
Copyright = '(c) Mosja.Dev, 2025'
Description = 'Windows environment variables management.'
NestedModules = @()
FunctionsToExport = 'Get-Env', 'Set-Env', 'Remove-Env',
    'Export-Env', 'Import-Env'
    # 'New-EnvNameArgumentCompletionAttribute'
AliasesToExport = 'genv', 'senv', 'renv', 'epenv', 'ipenv'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
