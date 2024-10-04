$ErrorActionPreference = "Stop"

# $PasswordChars = "!#%+23456789:=?@ABCDEFGHJKLMNPRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
# $PasswordChars = "!#%+23456789:?@ABCDEFGHJKLMNPRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

$script:PasswordChars = @{
    UpperCase = 'ABCDEFGHJKLMNPRSTUVWXYZ'
    LowerCase = 'abcdefghijkmnopqrstuvwxyz'
    Digit = '23456789'
    Symbol = '!#$%&*'
}

Class CharKindValuesGenerator : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        return ($script:PasswordChars.Keys)
    }
}

function Test-PasswordStrength {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [SecureString[]]
        $Password,

        [Parameter()]
        [int]
        [ValidateRange(8, [int]::MaxValue)]
        $Length = 16,

        [Parameter()]
        [ValidateSet([CharKindValuesGenerator])]
        [string[]]
        $Require = ($script:PasswordChars.Keys)
    )

    process {
        $Password | ConvertFrom-SecureString -AsPlainText |
            ForEach-Object {
                if($_.Length -lt $Length) {
                    return $false
                }

                foreach ($r in $Require) {
                   $ok = $false
                   foreach($c in $_.ToCharArray()) {
                     if($script:PasswordChars[$r].Contains($c)) {
                        $ok = $true
                        break;
                     }
                   }
                   if(-not $ok) {
                    return $false
                   }
                }

                return $true
            }
    }
}

function Get-RandomPassword {
    [CmdletBinding()]
    [OutputType([SecureString], [string])]
    param (
        [Parameter()]
        [ValidateRange(8, [int]::MaxValue)]
        [int]
        $Length = 16,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $Count = 1,

        [Parameter()]
        [ValidateSet([CharKindValuesGenerator])]
        [string[]]
        # Character kinds to use.
        $Require = $script:PasswordChars.Keys,

        [switch]
        $AsPlainText
    )

    $chars = ''

    $Require | ForEach-Object {
        $chars += $script:PasswordChars[$_]
    }

    $c = $Count
    while($c-- -gt 0) {
        while($true) {

            $p = Get-Random -Minimum 0 -Maximum $chars.Length -Count $Length |
                ForEach-Object { $chars[$_] } | Join-String |
                ConvertTo-SecureString -AsPlainText -Force

            if(Test-PasswordStrength $p -Length $Length -Require $Require) {
                Write-Output ($AsPlainText ? (ConvertFrom-SecureString $p -AsPlainText) : $p)
                break
            }
        }
    }
}

Set-Alias gpwd Get-RandomPassword
