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
               'NestedModules\VSCode.psm1', 
               'NestedModules\WebSearch.psm1')
FunctionsToExport = 'Assert-Windows', 'Assert-Command', 'New-CodeCoverageReport', 
               'Get-ReportGenerator', 'Compare-Content', 'Update-ContentEolToDos', 
               'Update-ContentEol', 'Update-ContentEolToUnix', 'Update-Content', 
               'Import-Env', 'Get-RandomHostName', 'Import-HtmlAgilityPack', 
               'Get-Html', 'Test-PasswordStrength', 'Get-RandomPassword', 
               'Get-PowerPlan', 'Switch-PowerPlan', 'Get-CurrentProcess', 
               'Get-ParentProcess', 'Get-Gsudo', 'Get-Winget', 'Update-Software', 
               'Reset-SystemTray', 'Get-VSCode', 'Start-VSCode', 'Search-Api', 
               'Search-Bing', 'Get-WebSearch', 'Search-MS', 'Search-Web'
CmdletsToExport = @()
VariablesToExport = '*'
AliasesToExport = 'nccr', 'udc', 'unix2dos', 'sed', 'udeol', 'dos2unix', 'fdiff', 'crc', 'ipenv', 
               'ghtml', 'tpwd', 'gpwd', 'swpwp', 'gpwp', 'pspar', 'pscur', 'sacode', 'srweb', 
               'srapi', 'srbing', 'gwse', 'srms'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
