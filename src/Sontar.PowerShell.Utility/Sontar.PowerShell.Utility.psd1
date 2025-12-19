@{
RootModule = 'Sontar.PowerShell.Utility.psm1'
ModuleVersion = '2.0.0'
GUID = 'b19e8c97-93b2-4dfd-9cd8-de4d77e225b7'
Author = 'sontar.ru'
CompanyName = 'sontar.ru'
Copyright = '(c) sontar.ru, 2025'
Description = 'The Utility module.'
NestedModules = @('NestedModules\CodeCoverage.psm1', 
               'NestedModules\Content.psm1', 
               'NestedModules\Env.psm1', 
               'NestedModules\HostName.psm1', 
               'NestedModules\Html.psm1', 
               'NestedModules\Password.psm1', 
               'NestedModules\PowerPlan.psm1', 
               'NestedModules\Process.psm1', 
               'NestedModules\Software.psm1', 
               'NestedModules\SystemTray.psm1')
FunctionsToExport = 'Assert-Command', 'Assert-Windows', 'New-CodeCoverageReport', 
               'Get-ReportGenerator', 'Compare-Content', 'Update-ContentEol', 
               'Update-Content', 'Update-ContentEolToUnix', 'Update-ContentEolToDos', 
               'Import-Env', 'Get-RandomHostName', 'Get-Html', 
               'Import-HtmlAgilityPack', 'Test-PasswordStrength', 
               'Get-RandomPassword', 'Switch-PowerPlan', 'Get-PowerPlan', 
               'Get-ParentProcess', 'Get-CurrentProcess', 'Update-Software', 
               'Get-Gsudo', 'Get-Winget', 'Reset-SystemTray'
CmdletsToExport = @()
VariablesToExport = '*'
AliasesToExport = 'nccr', 'crc', 'dos2unix', 'udc', 'fdiff', 'udeol', 'sed', 'unix2dos', 'ipenv', 
               'ghtml', 'tpwd', 'gpwd', 'swpwp', 'gpwp', 'pspar', 'pscur'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
