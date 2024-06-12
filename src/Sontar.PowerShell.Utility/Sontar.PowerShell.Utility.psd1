@{
RootModule = 'Sontar.PowerShell.Utility.psm1'
ModuleVersion = '1.0.0'
GUID = 'b19e8c97-93b2-4dfd-9cd8-de4d77e225b7'
Author = 'rnovo'
CompanyName = 'rnovo'
Copyright = '(c) rnovo, 2025'
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
FunctionsToExport = 'Assert-Command', 'Assert-Windows', 'New-CodeCoverageReport', 
               'Get-ReportGenerator', 'Update-ContentEolToDos', 'Update-ContentEol', 
               'Compare-Content', 'Update-Content', 'Update-ContentEolToUnix', 
               'Import-Env', 'Start-GitFlow', 'Clear-GitRepo', 'Get-Git', 
               'Get-RandomHostName', 'Import-HtmlAgilityPack', 'Get-Html', 
               'Test-PasswordStrength', 'Get-RandomPassword', 'Switch-PowerPlan', 
               'Get-PowerPlan', 'Get-CurrentProcess', 'Get-ParentProcess', 
               'Reset-SystemTray', 'Start-VisualStudio', 'Get-VisualStudio', 
               'Start-VSCode', 'Get-VSCode', 'Search-Bing', 'Get-WebSearch', 
               'Search-Web', 'Search-Api', 'Search-MS'
CmdletsToExport = @()
VariablesToExport = '*'
AliasesToExport = 'nccr', 'udc', 'udeol', 'dos2unix', 'sed', 'crc', 'fdiff', 'unix2dos', 'ipenv', 
               'clgrepo', 'sagflow', 'ghtml', 'tpwd', 'gpwd', 'swpwp', 'gpwp', 'pspar', 'gpscur', 
               'gpspar', 'pscur', 'savs', 'sacode', 'srbing', 'srms', 'gwse', 'srapi', 'srweb'
PrivateData = @{
    PSData = @{
    } # End of PSData hashtable
} # End of PrivateData hashtable
}
