@{
RootModule = 'Sontar.PowerShell.Utility.psm1'
ModuleVersion = '1.1.0'
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
FunctionsToExport = 'Assert-Command', 'Assert-Windows', 'Get-ReportGenerator',
               'New-CodeCoverageReport', 'Update-Content', 'Update-ContentEol',
               'Compare-Content', 'Update-ContentEolToDos',
               'Update-ContentEolToUnix', 'Import-Env', 'Start-GitFlow',
               'Clear-GitRepo', 'Get-Git', 'Get-RandomHostName', 'Get-Html',
               'Import-HtmlAgilityPack', 'Test-PasswordStrength',
               'Get-RandomPassword', 'Get-PowerPlan', 'Switch-PowerPlan',
               'Get-ParentProcess', 'Get-CurrentProcess', 'Reset-SystemTray',
               'Get-VisualStudio', 'Start-VisualStudio', 'Get-VSCode', 'Start-VSCode',
               'Search-MS', 'Get-WebSearch', 'Search-Bing', 'Search-Web', 'Search-Api'
CmdletsToExport = @()
VariablesToExport = '*'
AliasesToExport = 'nccr', 'crc', 'sed', 'fdiff', 'unix2dos', 'udeol', 'dos2unix', 'udc', 'ipenv',
               'clgrepo', 'sagflow', 'ghtml', 'gpwd', 'tpwd', 'gpwp', 'swpwp', 'pspar', 'pscur',
               'savs', 'sacode', 'srms', 'srapi', 'srweb', 'srbing', 'gwse'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
