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
               'NestedModules\Git.psm1', 
               'NestedModules\HostName.psm1', 
               'NestedModules\Html.psm1', 
               'NestedModules\Password.psm1', 
               'NestedModules\PowerPlan.psm1', 
               'NestedModules\Process.psm1', 
               'NestedModules\SystemTray.psm1', 
               'NestedModules\VisualStudio.psm1', 
               'NestedModules\VSCode.psm1', 
               'NestedModules\WebSearch.psm1')
FunctionsToExport = 'Assert-Windows', 'Assert-Command', 'Get-ReportGenerator', 
               'New-CodeCoverageReport', 'Compare-Content', 
               'Update-ContentEolToUnix', 'Update-ContentEol', 
               'Update-ContentEolToDos', 'Update-Content', 'Import-Env', 
               'Clear-GitIgnoredFiles', 'Start-GitFlow', 'Get-Git', 
               'Get-RandomHostName', 'Import-HtmlAgilityPack', 'Get-Html', 
               'Get-RandomPassword', 'Test-PasswordStrength', 'Switch-PowerPlan', 
               'Get-PowerPlan', 'Get-ParentProcess', 'Get-CurrentProcess', 
               'Reset-SystemTray', 'Get-VisualStudio', 'Start-VisualStudio', 
               'Start-VSCode', 'Get-VSCode', 'Get-WebSearch', 'Search-Api', 'Search-Web', 
               'Search-MS', 'Search-Bing'
CmdletsToExport = @()
VariablesToExport = '*'
AliasesToExport = 'nccr', 'dos2unix', 'unix2dos', 'crc', 'udc', 'udeol', 'fdiff', 'sed', 'ipenv', 
               'clgit', 'sagflow', 'ghtml', 'gpwd', 'tpwd', 'swpwp', 'gpwp', 'pspar', 'pscur', 
               'savs', 'sacode', 'gwse', 'srweb', 'srbing', 'srapi', 'srms'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
