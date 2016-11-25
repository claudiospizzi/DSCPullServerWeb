
$ModulePath = Resolve-Path -Path "$PSScriptRoot\..\..\Modules" | ForEach-Object Path
$ModuleName = Get-ChildItem -Path $ModulePath | Select-Object -First 1 -ExpandProperty BaseName

Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$ModulePath\$ModuleName" -Force

Describe 'WebAPI' {

    $api = 'http://localhost:34361/api'

    Context 'Nodes by Id' {

        $expectedNodes = @(
            @{
                ConfigurationID    = 'DD34ADD4-DF15-4FC5-A922-B0B2D4E8809A'
                TargetName         = '192.168.144.82'
                NodeCompliant      = $true
                Dirty              = $false
                LastHeartbeatTime  = [DateTime] '2016-11-24 15:40:25.228'
                LastComplianceTime = [DateTime] '2016-11-24 15:40:25.228'
                StatusCode         = '0'
                ServerCheckSum     = '3F660B4567B21A92EF715289036FCC282E9F834465040BEED7E716855A0DA04F'
                TargetCheckSum     = '3F660B4567B21A92EF715289036FCC282E9F834465040BEED7E716855A0DA04F'
            }
        )

        It 'should return all nodes' {

            # Arrange
            $expectedCount = 1

            # Act
            $actualNodes = @(Get-DSCPullServerIdNode -Uri $api)

            # Assert
            $actualNodes.Count | Should Be $expectedCount
            for ($c = 0; $c -lt $expectedCount; $c++)
            {
                $actualNodes[$c].ConfigurationID    | Should Be $expectedNodes[$c].ConfigurationID
                $actualNodes[$c].TargetName         | Should Be $expectedNodes[$c].TargetName
                $actualNodes[$c].NodeCompliant      | Should Be $expectedNodes[$c].NodeCompliant
                $actualNodes[$c].Dirty              | Should Be $expectedNodes[$c].Dirty
                $actualNodes[$c].LastHeartbeatTime  | Should Be $expectedNodes[$c].LastHeartbeatTime
                $actualNodes[$c].LastComplianceTime | Should Be $expectedNodes[$c].LastComplianceTime
                $actualNodes[$c].StatusCode         | Should Be $expectedNodes[$c].StatusCode
                $actualNodes[$c].ServerCheckSum     | Should Be $expectedNodes[$c].ServerCheckSum
                $actualNodes[$c].TargetCheckSum     | Should Be $expectedNodes[$c].TargetCheckSum
            } 
        }
    }

    Context 'Nodes by Names' {

        $expectedNodes = @(
            @{
                AgentId            = 'bc9fdf70-b252-11e6-841a-00155d67ca7a'
                NodeName           = 'LAB-DSC-NODE32'
                LCMVersion         = '2.0'
                IPAddress          = '192.168.144.83;127.0.0.1;fe80::5150:a3fe:bae2:a0c6%4;::2000:0:0:0;::1;::2000:0:0:0'
                ConfigurationNames = @('MyConfigName')
            }
        )

        It 'should return all nodes' {

            # Arrange
            $expectedCount = 1

            # Act
            $actualNodes = @(Get-DSCPullServerNamesNode -Uri $api)

            # Assert
            $actualNodes.Count | Should Be $expectedCount
            for ($c = 0; $c -lt $expectedCount; $c++)
            {
                $actualNodes[$c].AgentId            | Should Be $expectedNodes[$c].AgentId
                $actualNodes[$c].NodeName           | Should Be $expectedNodes[$c].NodeName
                $actualNodes[$c].LCMVersion         | Should Be $expectedNodes[$c].LCMVersion
                $actualNodes[$c].IPAddress          | Should Be $expectedNodes[$c].IPAddress
                $actualNodes[$c].ConfigurationNames | Should Be $expectedNodes[$c].ConfigurationNames
            } 
        }
    }

    Context 'Reports' {

        It 'should return all reports' {

            # Arrange
            $expectedCount = 40

            # Act
            $actualReports = @(Get-DSCPullServerReport -Uri $api)

            # Assert
            $actualReports.Count | Should Be $expectedCount
        }
    }

    Context 'Configurations' {

        $expectedConfigurations = @(
            @{
                Name           = 'FeatureDemo'
                Size           = 1846
                Created        = [DateTime] '2016-11-17T17:45:38.1428987+01:00'
                Checksum       = '1AB2C0140C2B523156BE8142CD458FA20C5C2826879C7C37D97049E7DC25D66B'
                ChecksumStatus = 'Valid'
            }
            @{
                Name           = 'FileDemo'
                Size           = 2178
                Created        = [DateTime] '2016-11-17T17:45:38.1619006+01:00'
                Checksum       = '2DEF328446FF7D9CA96DF51495394D26697CB43ADF3E671C133820755D2A6E2D'
                ChecksumStatus = 'Invalid'
            }
            @{
                Name           = 'RegistryDemo'
                Size           = 2026
                Created        = [DateTime] '2016-11-17T18:57:54.7429415+01:00'
                Checksum       = ''
                ChecksumStatus = 'Missing'
            }
        )

        It 'should return all configurations' {

            # Arrange
            $expectedCount = 3

            # Act
            $actualConfigurations = @(Get-DSCPullServerConfiguration -Uri $api)

            # Assert
            $actualConfigurations.Count | Should Be $expectedCount
            for ($c = 0; $c -lt $expectedCount; $c++)
            {
                $actualConfigurations[$c].Name           | Should Be $expectedConfigurations[$c].Name
                $actualConfigurations[$c].Size           | Should Be $expectedConfigurations[$c].Size
                $actualConfigurations[$c].Created        | Should Be $expectedConfigurations[$c].Created
                $actualConfigurations[$c].Checksum       | Should Be $expectedConfigurations[$c].Checksum
                $actualConfigurations[$c].ChecksumStatus | Should Be $expectedConfigurations[$c].ChecksumStatus
            }
        }

        It 'should return one configuration by name' {

            # Arrange
            $expectedCount = 1
            $expectedName  = 'FileDemo'

            # Act
            $actualConfigurations = @(Get-DSCPullServerConfiguration -Uri $api -Name $expectedName)

            # Assert
            $actualConfigurations.Count   | Should Be $expectedCount
            $actualConfigurations[0].Name | Should Be $expectedName
        }

        It 'should save an existing configuration' {

            # Arrange
            $inputName       = 'FeatureDemo'
            $expectedPath    = "TestDrive:\$inputName.mof"
            $expectedContent = Get-Content -Path "$PSScriptRoot\TestData\$inputName.mof"

            # Act
            Save-DSCPullServerConfiguration -Uri $api -Name $inputName -Path $expectedPath
            $actualContent    = Get-Content -Path $expectedPath
            $actualDifference = @(Compare-Object -ReferenceObject $expectedContent -DifferenceObject $actualContent)

            # Assert
            Test-Path -Path $expectedPath | Should Be $true
            $actualDifference.Count -eq 0 | Should Be $true
        }

        It 'should create a new configuration' {

            # Arrange
            $expectedName           = 'UserDemo'
            $expectedChecksum       = 'DC04265400F4B9232B3F2EAE9E3D146B32A791120A76375360C833E164DB40CF'
            $expectedChecksumStatus = 'Valid'
            $inputPath              = "$PSScriptRoot\TestData\$expectedName.mof"

            # Act
            $actualConfiguration  = Publish-DSCPullServerConfiguration -Uri $api -Name $expectedName -Path $inputPath

            # Assert
            $actualConfiguration.Name           | Should Be $expectedName
            $actualConfiguration.Checksum       | Should Be $expectedChecksum
            $actualConfiguration.ChecksumStatus | Should Be $expectedChecksumStatus
        }

        It 'should create a valid configuration' {

            # Arrange
            $inputName    = 'UserDemo'
            $expectedPath = "TestDrive:\$inputName.mof"
            $expectedHash = (Get-FileHash -Path "$PSScriptRoot\TestData\$inputName.mof" -Algorithm SHA256).Hash

            # Act
            Save-DSCPullServerConfiguration -Uri $api -Name $inputName -Path $expectedPath
            $actualHash = (Get-FileHash -Path $expectedPath -Algorithm SHA256).Hash

            # Assert
            $actualHash | Should Be $expectedHash
        }

        It 'should update a configuration checksum (valid)' {

            # Arrange
            $expectedCount          = 1
            $expectedName           = 'FeatureDemo'
            $expectedChecksum       = '1AB2C0140C2B523156BE8142CD458FA20C5C2826879C7C37D97049E7DC25D66B'
            $expectedChecksumStatus = 'Valid'

            # Act
            $actualConfigurations = @(Update-DSCPullServerConfigurationChecksum -Uri $api -Name $expectedName)

            # Assert
            $actualConfigurations.Count             | Should Be $expectedCount
            $actualConfigurations[0].Name           | Should Be $expectedName
            $actualConfigurations[0].Checksum       | Should Be $expectedChecksum
            $actualConfigurations[0].ChecksumStatus | Should Be $expectedChecksumStatus
        }

        It 'should update a configuration checksum (invalid)' {

            # Arrange
            $expectedCount          = 1
            $expectedName           = 'FileDemo'
            $expectedChecksum       = '2DD456B2366BA165902CEFF53644ADA4D3D39E5D2B2B825FBCEBBE8C84F43CD0'
            $expectedChecksumStatus = 'Valid'

            # Act
            $actualConfigurations = @(Update-DSCPullServerConfigurationChecksum -Uri $api -Name $expectedName)

            # Assert
            $actualConfigurations.Count             | Should Be $expectedCount
            $actualConfigurations[0].Name           | Should Be $expectedName
            $actualConfigurations[0].Checksum       | Should Be $expectedChecksum
            $actualConfigurations[0].ChecksumStatus | Should Be $expectedChecksumStatus
        }

        It 'should update a configuration checksum (missing)' {

            # Arrange
            $expectedCount          = 1
            $expectedName           = 'RegistryDemo'
            $expectedChecksum       = '3AE71B4DE6583BBF0D53A8663F515E9DF1957536C0E85613722781A605370D48'
            $expectedChecksumStatus = 'Valid'

            # Act
            $actualConfigurations = @(Update-DSCPullServerConfigurationChecksum -Uri $api -Name $expectedName)

            # Assert
            $actualConfigurations.Count             | Should Be $expectedCount
            $actualConfigurations[0].Name           | Should Be $expectedName
            $actualConfigurations[0].Checksum       | Should Be $expectedChecksum
            $actualConfigurations[0].ChecksumStatus | Should Be $expectedChecksumStatus
        }

        It 'should delete an existing configuration' {

            # Arrange
            $inputName = 'UserDemo'

            # Act
            Unpublish-DSCPullServerConfiguration -Uri $api -Name $inputName

            # Assert
            { Get-DSCPullServerConfiguration -Uri $api -Name $inputName -ErrorAction Stop } | Should Throw
        }
    }

    Context 'Modules' {

        $expectedModules = @(
            @{
                Name           = 'SharePointDsc'
                Version        = '1.3.0.0'
                Size           = 429285
                Created        = [DateTime] "2016-11-03T15:11:20.4960172+01:00"
                Checksum       = 'EBBE30927695ADAE86A989C2627653861563E81C98B855303EC92138A0212F47'
                ChecksumStatus = 'Valid'
            }
            @{
                Name           = 'SharePointDsc'
                Version        = '1.4.0.0'
                Size           = 441882
                Created        = [DateTime] "2016-11-03T15:11:48.6318305+01:00"
                Checksum       = '35B1622E1890BAA2D529EDFB07285BEEFCFE8F8D3A4640FF785E1E30E64181A9'
                ChecksumStatus = 'Invalid'
            }
            @{
                Name           = 'SystemLocaleDsc'
                Version        = '1.1.0.0'
                Size           = 9566
                Created        = [DateTime] "2016-11-03T15:13:04.2023868+01:00"
                Checksum       = ''
                ChecksumStatus = 'Missing'
            }
        )

        It 'should return all modules' {

            # Arrange
            $expectedCount = 3

            # Act
            $actualModules = @(Get-DSCPullServerModule -Uri $api)

            # Assert
            $actualModules.Count | Should Be $expectedCount
            for ($c = 0; $c -lt $expectedCount; $c++)
            {
                $actualModules[$c].Name           | Should Be $expectedModules[$c].Name
                $actualModules[$c].Version        | Should Be $expectedModules[$c].Version
                $actualModules[$c].Size           | Should Be $expectedModules[$c].Size
                $actualModules[$c].Checksum       | Should Be $expectedModules[$c].Checksum
                $actualModules[$c].Created        | Should Be $expectedModules[$c].Created
                $actualModules[$c].ChecksumStatus | Should Be $expectedModules[$c].ChecksumStatus
            }
        }

        It 'should return all modules by name' {

            # Arrange
            $expectedCount = 2
            $expectedName  = 'SharePointDsc'

            # Act
            $actualModules = @(Get-DSCPullServerModule -Uri $api -Name $expectedName)

            # Assert
            $actualModules.Count   | Should Be $expectedCount
            $actualModules[0].Name | Should Be $expectedName
            $actualModules[1].Name | Should Be $expectedName
        }

        It 'should return one module by name and version' {

            # Arrange
            $expectedCount   = 1
            $expectedName    = 'SharePointDsc'
            $expectedVersion = '1.4.0.0'

            # Act
            $actualModules = @(Get-DSCPullServerModule -Uri $api -Name $expectedName -Version $expectedVersion)

            # Assert
            $actualModules.Count      | Should Be $expectedCount
            $actualModules[0].Name    | Should Be $expectedName
            $actualModules[0].Version | Should Be $expectedVersion
        }

        It 'should save an existing module' {

            # Arrange
            $inputName       = 'SharePointDsc'
            $inputVersion    = '1.3.0.0'
            $expectedPath    = "TestDrive:\$inputName`_$inputVersion.zip"
            $expectedContent = Get-Content -Path "$PSScriptRoot\TestData\$inputName`_$inputVersion.zip"

            # Act
            Save-DSCPullServerModule -Uri $api -Name $inputName -Version $inputVersion -Path $expectedPath
            $actualContent    = Get-Content -Path $expectedPath
            $actualDifference = @(Compare-Object -ReferenceObject $expectedContent -DifferenceObject $actualContent)

            # Assert
            Test-Path -Path $expectedPath | Should Be $true
            $actualDifference.Count -eq 0 | Should Be $true
        }

        It 'should create a new module' {

            # Arrange
            $expectedName           = 'PSDscResources'
            $expectedVersion        = '2.1.0.0'
            $expectedChecksum       = 'D4F555302639D7C25CBE14AE8021AD9377F993788A2C992683634322E0012D5B'
            $expectedChecksumStatus = 'Valid'
            $inputPath              = "$PSScriptRoot\TestData\$expectedName`_$expectedVersion.zip"

            # Act
            $actualModule  = Publish-DSCPullServerModule -Uri $api -Name $expectedName -Version $expectedVersion -Path $inputPath

            # Assert
            $actualModule.Name           | Should Be $expectedName
            $actualModule.Version        | Should Be $expectedVersion
            $actualModule.Checksum       | Should Be $expectedChecksum
            $actualModule.ChecksumStatus | Should Be $expectedChecksumStatus
        }

        It 'should create a valid module' {

            # Arrange
            $inputName    = 'PSDscResources'
            $inputVersion = '2.1.0.0'
            $expectedPath = "TestDrive:\$inputName`_$inputVersion.zip"
            $expectedHash = (Get-FileHash -Path "$PSScriptRoot\TestData\$inputName`_$inputVersion.zip" -Algorithm SHA256).Hash

            # Act
            Save-DSCPullServerModule -Uri $api -Name $inputName -Version $inputVersion -Path $expectedPath
            $actualHash = (Get-FileHash -Path $expectedPath -Algorithm SHA256).Hash

            # Assert
            $actualHash | Should Be $expectedHash
        }

        It 'should update a module checksum (valid)' {

            # Arrange
            $expectedCount          = 1
            $expectedName           = 'SharePointDsc'
            $expectedVersion        = '1.3.0.0'
            $expectedChecksum       = 'EBBE30927695ADAE86A989C2627653861563E81C98B855303EC92138A0212F47'
            $expectedChecksumStatus = 'Valid'

            # Act
            $actualModules = @(Update-DSCPullServerModuleChecksum -Uri $api -Name $expectedName -Version $expectedVersion)

            # Assert
            $actualModules.Count             | Should Be $expectedCount
            $actualModules[0].Name           | Should Be $expectedName
            $actualModules[0].Version        | Should Be $expectedVersion
            $actualModules[0].Checksum       | Should Be $expectedChecksum
            $actualModules[0].ChecksumStatus | Should Be $expectedChecksumStatus
        }

        It 'should update a module checksum (invalid)' {

            # Arrange
            $expectedCount          = 1
            $expectedName           = 'SharePointDsc'
            $expectedVersion        = '1.4.0.0'
            $expectedChecksum       = '3012DFF7FCD64115AD8CCD4918C1F9F19029762F96EB2DCF48A46D2B2E1BD6BA'
            $expectedChecksumStatus = 'Valid'

            # Act
            $actualModules = @(Update-DSCPullServerModuleChecksum -Uri $api -Name $expectedName -Version $expectedVersion)

            # Assert
            $actualModules.Count             | Should Be $expectedCount
            $actualModules[0].Name           | Should Be $expectedName
            $actualModules[0].Version        | Should Be $expectedVersion
            $actualModules[0].Checksum       | Should Be $expectedChecksum
            $actualModules[0].ChecksumStatus | Should Be $expectedChecksumStatus
        }

        It 'should update a module checksum (missing)' {

            # Arrange
            $expectedCount          = 1
            $expectedName           = 'SystemLocaleDsc'
            $expectedVersion        = '1.1.0.0'
            $expectedChecksum       = '35B1622E1890BAA2D529EDFB07285BEEFCFE8F8D3A4640FF785E1E30E64181A9'
            $expectedChecksumStatus = 'Valid'

            # Act
            $actualModules = @(Update-DSCPullServerModuleChecksum -Uri $api -Name $expectedName -Version $expectedVersion)

            # Assert
            $actualModules.Count             | Should Be $expectedCount
            $actualModules[0].Name           | Should Be $expectedName
            $actualModules[0].Version        | Should Be $expectedVersion
            $actualModules[0].Checksum       | Should Be $expectedChecksum
            $actualModules[0].ChecksumStatus | Should Be $expectedChecksumStatus
        }

        It 'should delete an existing module' {

            # Arrange
            $inputName    = 'PSDscResources'
            $inputVersion = '2.1.0.0'

            # Act
            Unpublish-DSCPullServerModule -Uri $api -Name $inputName -Version $inputVersion

            # Assert
            { Get-DSCPullServerModule -Uri $api -Name $inputName -Version $inputVersion -ErrorAction Stop } | Should Throw
        }
    }
}
