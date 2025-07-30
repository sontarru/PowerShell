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
               'NestedModules\Software.psm1', 
               'NestedModules\SystemTray.psm1', 
               'NestedModules\VisualStudio.psm1', 
               'NestedModules\VSCode.psm1', 
               'NestedModules\WebSearch.psm1')
FunctionsToExport = 'Assert-Windows', 'Assert-Command', 'Get-ReportGenerator', 
               'New-CodeCoverageReport', 'Update-ContentEolToDos', 'Compare-Content', 
               'Update-ContentEol', 'Update-ContentEolToUnix', 'Update-Content', 
               'Import-Env', 'Start-GitFlow', 'Clear-GitIgnoredFiles', 'Get-Git', 
               'Get-RandomHostName', 'Get-Html', 'Import-HtmlAgilityPack', 
               'Test-PasswordStrength', 'Get-RandomPassword', 'Switch-PowerPlan', 
               'Get-PowerPlan', 'Get-CurrentProcess', 'Get-ParentProcess', 'Get-Gsudo', 
               'Get-Winget', 'Update-Software', 'Reset-SystemTray', 'Get-VisualStudio', 
               'Start-VisualStudio', 'Get-VSCode', 'Start-VSCode', 'Search-Api', 
               'Search-Bing', 'Get-WebSearch', 'Search-Web', 'Search-MS'
CmdletsToExport = @()
VariablesToExport = '*'
AliasesToExport = 'nccr', 'crc', 'fdiff', 'udc', 'udeol', 'sed', 'dos2unix', 'unix2dos', 'ipenv', 
               'clgi', 'sagf', 'ghtml', 'gpwd', 'tpwd', 'gpwp', 'swpwp', 'pscur', 'pspar', 'savs', 
               'sacode', 'gwse', 'srms', 'srbing', 'srweb', 'srapi'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
