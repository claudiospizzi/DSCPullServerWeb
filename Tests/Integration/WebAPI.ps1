
$ModulePath = Resolve-Path -Path "$PSScriptRoot\..\..\Modules" | ForEach-Object Path
$ModuleName = Get-ChildItem -Path $ModulePath | Select-Object -First 1 -ExpandProperty BaseName

Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$ModulePath\$ModuleName" -Force

Describe 'WebAPI' {

    $api = 'http://localhost:34361/api'

    Context 'Configurations' {

        $expectedConfigurations = @(
            @{
                Name           = 'FeatureDemo'
                Checksum       = '1AB2C0140C2B523156BE8142CD458FA20C5C2826879C7C37D97049E7DC25D66B'
                ChecksumStatus = 'Valid'
            }
            @{
                Name           = 'FileDemo'
                Checksum       = '2DEF328446FF7D9CA96DF51495394D26697CB43ADF3E671C133820755D2A6E2D'
                ChecksumStatus = 'Invalid'
            }
            @{
                Name           = 'RegistryDemo'
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
            $actualConfigurations.Count | Should Be $expectedCount
            $actualConfigurations.Name  | Should Be $expectedName
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

        It 'should create a binary valid configuration' {

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
                Checksum       = 'EBBE30927695ADAE86A989C2627653861563E81C98B855303EC92138A0212F47'
                ChecksumStatus = 'Valid'
            }
            @{
                Name           = 'SharePointDsc'
                Version        = '1.4.0.0'
                Checksum       = '35B1622E1890BAA2D529EDFB07285BEEFCFE8F8D3A4640FF785E1E30E64181A9'
                ChecksumStatus = 'Invalid'
            }
            @{
                Name           = 'SystemLocaleDsc'
                Version        = '1.1.0.0'
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
                $actualModules[$c].Checksum       | Should Be $expectedModules[$c].Checksum
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
            $actualModules.Count   | Should Be $expectedCount
            $actualModules.Name    | Should Be $expectedName
            $actualModules.Version | Should Be $expectedVersion
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

        It 'should create a binary valid module' {

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
