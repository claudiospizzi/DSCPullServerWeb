
$ModulePath = Resolve-Path -Path "$PSScriptRoot\..\..\Modules" | ForEach-Object Path
$ModuleName = Get-ChildItem -Path $ModulePath | Select-Object -First 1 -ExpandProperty BaseName

Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$ModulePath\$ModuleName" -Force

Describe 'Get-DSCPullServerModule' {

    $api = 'http://localhost:8090/api'

    Context 'Web Request' {

        Mock 'Invoke-RestMethod' -ModuleName $ModuleName {
            ConvertFrom-Json -InputObject '{"Name":"SharePointDsc","Version":"1.3.0.0","Size":429285,"Created":"2016-11-03T15:11:20.4960172+01:00","Checksum":"EBBE30927695ADAE86A989C2627653861563E81C98B855303EC92138A0212F47","ChecksumStatus":"Valid"}'
        }

        $expectedModules = @(
            @{
                Name           = 'SharePointDsc'
                Version        = '1.3.0.0'
                Size           = 429285
                Created        = [DateTime] "2016-11-03T15:11:20.4960172+01:00"
                Checksum       = 'EBBE30927695ADAE86A989C2627653861563E81C98B855303EC92138A0212F47'
                ChecksumStatus = 'Valid'
            }
        )

        It 'should call the valid REST endpoint' {

            # Act
            Get-DSCPullServerModule -Uri $api -Name $expectedModules[0].Name -Version $expectedModules[0].Version | Out-Null

            # Assert
            Assert-MockCalled 'Invoke-RestMethod' -ModuleName $ModuleName -Times 1 -Exactly
        }

        It 'should return a valid object type' {

            # Arrange
            $expectedType = 'DSCPullServerWeb.Module'

            # Act
            $actualModule = Get-DSCPullServerModule -Uri $api -Name $expectedModules[0].Name -Version $expectedModules[0].Version

            # Assert
            $actualModule.PSTypeNames[0] | Should Be 'DSCPullServerWeb.Module'
        }

        It 'should return a valid module' {

            # Arrange
            $expectedCount = $expectedModules.Count

            # Act
            $actualModules = @(Get-DSCPullServerModule -Uri $api -Name $expectedModule.Name -Version $expectedModule.Version)

            # Assert
            $actualModules.Count | Should Be $expectedCount
            for ($c = 0; $c -lt $expectedCount; $c++)
            {
                $actualModules[$c].Name           | Should Be $expectedModules[$c].Name
                $actualModules[$c].Version        | Should Be $expectedModules[$c].Version
                $actualModules[$c].Size           | Should Be $expectedModules[$c].Size
                $actualModules[$c].Created        | Should Be $expectedModules[$c].Created
                $actualModules[$c].Checksum       | Should Be $expectedModules[$c].Checksum
                $actualModules[$c].ChecksumStatus | Should Be $expectedModules[$c].ChecksumStatus
            }
        }
    }
}
