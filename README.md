# PowerShell

My personal PowerShell profile and utilities.

## How to setup secret store to work with the GitHub PS repository

Make sure the default secret vault exists:

[How to add credentials to repositories with Microsoft.PowerShell.PSResourceGet.](https://learn.microsoft.com/en-us/powershell/gallery/powershellget/how-to/credential-persistence?view=powershellget-3.x)


[Overview of the SecretManagement and SecretStore modules.](https://learn.microsoft.com/en-us/powershell/utility-modules/secretmanagement/overview)

```powershell
Get-SecretVault
```

```
Name        ModuleName                       IsDefaultVault
----        ----------                       --------------
SecretStore Microsoft.PowerShell.SecretStore True
```

If not then create it:

```powershell
Register-SecretVault -Name SecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault
```

Add the secret to the secret vault:

```powershell
# generate the api key at https://github.com/settings/tokens
# make sure that it assigned registry read/write permissions
$apikey = 'your_api_key_here'
$password = ConvertTo-SecureString $apikey -AsPlainText -Force
$credential = [pscredential]::new('your_account', $password)
Set-Secret -Name GitHub -Secret $credential
```

Register GitHub repository with the created secret:

```powershell
$credinfo = [Microsoft.PowerShell.PSResourceGet.UtilClasses.PSCredentialInfo]('SecretStore', 'GitHub')
Set-PSResourceRepository GitHub `
    -Uri 'https://nuget.pkg.github.com/your_account/index.json' `
    -CredentialInfo $credinfo -Trusted
```
