
$ModulePath = Resolve-Path -Path "$PSScriptRoot\..\..\Modules" | ForEach-Object Path
$ModuleName = Get-ChildItem -Path $ModulePath | Select-Object -First 1 -ExpandProperty BaseName

Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$ModulePath\$ModuleName" -Force

Describe 'Get-DSCPullServerConfiguration' {

    $api = 'http://localhost:8090/api'

    Context 'Web Request' {

        Mock 'Invoke-RestMethod' -ModuleName $ModuleName {
            ConvertFrom-Json -InputObject '{"Name":"FeatureDemo","Size":1846,"Created":"2016-11-17T17:45:38.1428987+01:00","Checksum":"1AB2C0140C2B523156BE8142CD458FA20C5C2826879C7C37D97049E7DC25D66B","ChecksumStatus":"Valid"}'
        }

        $expectedConfigurations = @(
            @{
                Name           = 'FeatureDemo'
                Size           = 1846
                Created        = [DateTime] '2016-11-17T17:45:38.1428987+01:00'
                Checksum       = '1AB2C0140C2B523156BE8142CD458FA20C5C2826879C7C37D97049E7DC25D66B'
                ChecksumStatus = 'Valid'
            }
        )

        It 'should call the valid REST endpoint' {

            # Act
            Get-DSCPullServerConfiguration -Uri $api -Name $expectedConfigurations[0].Name | Out-Null

            # Assert
            Assert-MockCalled 'Invoke-RestMethod' -ModuleName $ModuleName -Times 1 -Exactly
        }

        It 'should return a valid object type' {

            # Arrange
            $expectedType = 'DSCPullServerWeb.Configuration'

            # Act
            $actualConfiguration = Get-DSCPullServerConfiguration -Uri $api -Name $expectedConfigurations[0].Name

            # Assert
            $actualConfiguration.PSTypeNames[0] | Should Be 'DSCPullServerWeb.Configuration'
        }

        It 'should return a valid configuration' {

            # Arrange
            $expectedCount = $expectedConfigurations.Count

            # Act
            $actualConfigurations = @(Get-DSCPullServerConfiguration -Uri $api -Name $expectedConfiguration.Name)

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
    }
}
