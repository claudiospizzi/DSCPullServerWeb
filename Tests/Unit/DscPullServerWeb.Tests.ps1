
$ModulePath = Resolve-Path -Path "$PSScriptRoot\..\..\Modules" | ForEach-Object Path
$ModuleName = Get-ChildItem -Path $ModulePath | Select-Object -First 1 -ExpandProperty BaseName

$ResourcePath = Resolve-Path -Path "$ModulePath\$ModuleName\DSCResources" | ForEach-Object Path
$ResourceName = 'DscPullServerWeb'

Remove-Module -Name $ResourceName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$ResourcePath\$ResourceName" -Force

Describe 'DscPullServerWeb' {

    $endpointName = 'PSDSCPullServerWeb'

    Context 'Get-TargetResource' {

        It 'Do It!' {

            Get-TargetResource -EndpointName $endpointName
        }
    }

    Context 'Set-TargetResource' {

        It 'Do It!' {

            Set-TargetResource -EndpointName $endpointName
        }
    }

    Context 'Test-TargetResource' {

        It 'Do It!' {

            Test-TargetResource -EndpointName $endpointName
        }
    }
}
