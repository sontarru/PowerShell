# PowerShell module collection

## Setup GitHub PSResourceRepository

### Reset secret store

```powershell
Reset-SecretStore
```

### Turn off secret store password

```powershell
Set-SecretStoreConfiguration -Authentication None
```

### Add GitHub credential

```powershell
$password = ConvertTo-SecureString 'apikey' -AsPlainText -Force
$credential = [pscredential]::new('fkthat', $password)
Set-Secret GitHub -Vault SecretStore -Secret $credential
```

### Get pscredentialinfo

```powershell
$credentialinfo = [Microsoft.PowerShell.PSResourceGet.UtilClasses.PSCredentialInfo]::new('SecretStore', 'GitHub')
```

### Setup repo

```powershell
Set-PSResourceRepository GitHub -Uri https://nuget.pkg.github.com/fkthat/index.json -Trusted -CredentialInfo $credentialinfo
```
