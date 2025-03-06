BeforeAll {
    Import-Module $PSScriptRoot -Force

    $envRegKey = @{
        'System' = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
        'User' = 'HKCU:\Environment'
    }

    $reg = @{
        $envRegKey['System'] = [pscustomobject]@{
            ACSetupSvcPort = '23210'
            ACSvcPort = '17532'
            ComSpec = '%SystemRoot%\system32\cmd.exe'
            DriverData = 'C:\Windows\System32\Drivers\DriverData'
            NUMBER_OF_PROCESSORS = '16'
            OS = 'Windows_NT'
            PATH = '%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem'
            PATHEXT = '.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC'
            POWERSHELL_DISTRIBUTION_CHANNEL = 'MSI:Windows 10 Pro'
            PROCESSOR_ARCHITECTURE = 'AMD64'
            PROCESSOR_IDENTIFIER = 'Intel64 Family 6 Model 167 Stepping 1, GenuineIntel'
            PROCESSOR_LEVEL = '6'
            PROCESSOR_REVISION = 'a701'
            PSModulePath = '%SystemRoot%\System32\WindowsPowerShell\v1.0\Modules'
            RlsSvcPort = '22112'
            TEMP = '%SystemRoot%\TEMP'
            TMP = '%SystemRoot%\TEMP'
            USERNAME = 'SYSTEM'
            VBOX_MSI_INSTALL_PATH = 'C:\Program Files\Oracle\VirtualBox\'
            windir = '%SystemRoot%'
            ZES_ENABLE_SYSMAN = '1'
        }
        $envRegKey['User'] = [pscustomobject]@{
            EDITOR = '%ProgramFiles%\Neovim\bin\nvim.exe'
            OneDrive = 'C:\Users\fkthat\OneDrive'
            OneDriveConsumer = 'C:\Users\fkthat\OneDrive'
            PAGER = '%ProgramFiles%\Git\usr\bin\less.exe'
            PATH = '%ProgramFiles%\Git\bin;%ProgramFiles%\dotnet;%USERPROFILE%\.dotnet\tools'
            TEMP = '%USERPROFILE%\AppData\Local\Temp'
            TMP = '%USERPROFILE%\AppData\Local\Temp'
            VBOX_USER_HOME = '%USERPROFILE%\VBox\Config'
        }
    }

    $GetValueNames = {
        $this.PSObject.Properties.Name
    }

    $GetValue = {
        param([string] $name, [object] $defaultValue, [Microsoft.Win32.RegistryValueOptions] $options)
        $this.PSObject.Properties[$name].Value ?? $defaultValue
    }

    $reg.Values |
        Add-Member `
            -Name GetValueNames `
            -MemberType ScriptMethod `
            -Value $GetValueNames `
            -PassThru |
        Add-Member `
            -Name GetValue `
            -MemberType ScriptMethod `
            -Value $GetValue `

    Mock Get-Item { $reg[$Path] } -ModuleName 'Environment'

    $regFlat = $envRegKey.Keys |
        ForEach-Object {
            $scope = $_
            $rp = $envRegKey[$scope]
            $rk = $reg[$rp]

            $rk.PSObject.Properties | ForEach-Object {
                $name = $_.Name
                $value = $_.Value

                [PSCustomObject]@{
                    Scope = $scope
                    Name = $name
                    Value = $value
                }
            }
        }
    # suppress warning
    $null = $regFlat
}

Describe Get-EnvironmentVariable {
    It ' Returns all with default params.' {
        $actual = Get-EnvironmentVariable
        $expected = $regFlat | Sort-Object Scope, Name

        Compare-Object $actual $expected -Property Scope, Name, Value |
            Should -BeNullOrEmpty
    }

    It ' Filters by scope (User).' {
        $actual = Get-EnvironmentVariable -Scope User
        $expected = $regFlat | Where-Object Scope -eq User | Sort-Object Scope, Name

        Compare-Object $actual $expected -Property Scope, Name, Value |
            Should -BeNullOrEmpty
    }

    It ' Filters by scope (System).' {
        $actual = Get-EnvironmentVariable -Scope System
        $expected = $regFlat | Where-Object Scope -eq System | Sort-Object Scope, Name

        Compare-Object $actual $expected -Property Scope, Name, Value |
            Should -BeNullOrEmpty
    }

    It ' Filters by name (all scopes).' {
        $expected = $regFlat | Where-Object {
            $_.Name -like 'pat*' -or $_.Name -like 'vbox_*'
        } | Sort-Object Scope, Name


        $actual = Get-EnvironmentVariable 'pat*','vbox_*'

        Compare-Object $actual $expected -Property Scope, Name, Value |
            Should -BeNullOrEmpty

        $actual = 'pat*','vbox_*' | Get-EnvironmentVariable

        Compare-Object $actual $expected -Property Scope, Name, Value |
            Should -BeNullOrEmpty
    }

    It ' Filters by name (System).' {
        $expected = $regFlat |
            Where-Object Scope -eq System |
            Where-Object { $_.Name -like 'pat*' -or $_.Name -like 'vbox_*' } |
            Sort-Object Scope, Name

        $actual = Get-EnvironmentVariable 'pat*','vbox_*' -Scope System

        Compare-Object $actual $expected -Property Scope, Name, Value |
            Should -BeNullOrEmpty

        $actual = 'pat*','vbox_*' | Get-EnvironmentVariable -Scope System

        Compare-Object $actual $expected -Property Scope, Name, Value |
            Should -BeNullOrEmpty
    }

    It ' Filters by name (User).' {
        $expected = $regFlat |
            Where-Object Scope -eq User |
            Where-Object { $_.Name -like 'pat*' -or $_.Name -like 'vbox_*' } |
            Sort-Object Scope, Name

        $actual = Get-EnvironmentVariable 'pat*','vbox_*' -Scope User

        Compare-Object $actual $expected -Property Scope, Name, Value |
            Should -BeNullOrEmpty

        $actual = 'pat*','vbox_*' | Get-EnvironmentVariable -Scope User

        Compare-Object $actual $expected -Property Scope, Name, Value |
            Should -BeNullOrEmpty
    }

    It ' Filters by name (System,User).' {
        $expected = $regFlat |
            Where-Object { $_.Name -like 'pat*' -or $_.Name -like 'vbox_*' } |
            Sort-Object Scope, Name

        $actual = Get-EnvironmentVariable 'pat*','vbox_*' -Scope System,User

        Compare-Object $actual $expected -Property Scope, Name, Value |
            Should -BeNullOrEmpty

        $actual = 'pat*','vbox_*' | Get-EnvironmentVariable -Scope System,User

        Compare-Object $actual $expected -Property Scope, Name, Value |
            Should -BeNullOrEmpty
    }
}

Describe Set-EnvironmentVariable {
    BeforeAll {
        Mock Set-ItemProperty { } -ModuleName Environment
    }

    It ' Calls Set-ItemProperty (System) with the correct path and name.' {
        Set-EnvironmentVariable 'Foo' 'Bar' -Scope System

        Should -Invoke -CommandName Set-ItemProperty `
            -ModuleName Environment `
            -ParameterFilter {
                $Path -eq 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -and
                $Name -eq 'Foo' -and
                $Value -eq 'Bar' -and
                $Type -eq 'ExpandString'
            }
    }

    It ' Calls Set-ItemProperty (User) with the correct path and name.' {
        Set-EnvironmentVariable 'Foo' 'Bar' -Scope User

        Should -Invoke -CommandName Set-ItemProperty `
            -ModuleName Environment `
            -ParameterFilter {
                $Path -eq 'HKCU:\Environment' -and
                $Name -eq 'Foo' -and
                $Value -eq 'Bar' -and
                $Type -eq 'ExpandString'
            }
    }

    It ' Calls Set-ItemProperty (by $InputObject) with the correct path and name.' {
        [PSCustomObject]@{ Name = 'Foo'; Value = 'Bar'; Scope = 'System' },
        [PSCustomObject]@{ Name = 'Baz'; Value = 'Ololo'; Scope = 'User' } |
            Set-EnvironmentVariable

        Should -Invoke -CommandName Set-ItemProperty `
            -ModuleName Environment `
            -ParameterFilter {
                $Path -eq 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -and
                $Name -eq 'Foo' -and
                $Value -eq 'Bar' -and
                $Type -eq 'ExpandString'
            }

        Should -Invoke -CommandName Set-ItemProperty `
            -ModuleName Environment `
            -ParameterFilter {
                $Path -eq 'HKCU:\Environment' -and
                $Name -eq 'Baz' -and
                $Value -eq 'Ololo' -and
                $Type -eq 'ExpandString'
            }
    }
}

Describe Remove-EnvironmentVariable {
    BeforeAll {
        Mock Remove-ItemProperty { } -ModuleName Environment
    }

    It ' Calls Remove-ItemProperty (user env variable).' {
        Remove-EnvironmentVariable 'Foo' -Scope User

        Should -Invoke -CommandName Remove-ItemProperty `
            -ModuleName Environment `
            -ParameterFilter {
                $Path -eq 'HKCU:\Environment' -and
                $Name -eq 'Foo'
            }
    }

    It ' Calls Remove-ItemProperty (system env variable).' {
        Remove-EnvironmentVariable 'Foo' -Scope System

        Should -Invoke -CommandName Remove-ItemProperty `
            -ModuleName Environment `
            -ParameterFilter {
                $Path -eq 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -and
                $Name -eq 'Foo'
            }
    }
}
