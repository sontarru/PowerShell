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
               'NestedModules\SystemTray.psm1', 
               'NestedModules\WebSearch.psm1')
FunctionsToExport = 'Assert-Windows', 'Assert-Command', 'Get-ReportGenerator', 
               'New-CodeCoverageReport', 'Update-ContentEolToUnix', 
               'Update-ContentEolToDos', 'Update-Content', 'Compare-Content', 
               'Update-ContentEol', 'Import-Env', 'Get-RandomHostName', 'Get-Html', 
               'Import-HtmlAgilityPack', 'Get-RandomPassword', 
               'Test-PasswordStrength', 'Get-PowerPlan', 'Switch-PowerPlan', 
               'Get-ParentProcess', 'Get-CurrentProcess', 'Get-Gsudo', 
               'Update-Software', 'Get-Winget', 'Reset-SystemTray', 'Search-Api', 
               'Get-WebSearch', 'Search-Bing', 'Search-Web', 'Search-MS'
CmdletsToExport = @()
VariablesToExport = '*'
AliasesToExport = 'nccr', 'dos2unix', 'sed', 'crc', 'udeol', 'fdiff', 'udc', 'unix2dos', 'ipenv', 
               'ghtml', 'gpwd', 'tpwd', 'swpwp', 'gpwp', 'pspar', 'pscur', 'srapi', 'gwse', 
               'srweb', 'srbing', 'srms'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
