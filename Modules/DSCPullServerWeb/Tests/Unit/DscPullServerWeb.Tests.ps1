
$modulePath = Resolve-Path -Path "$PSScriptRoot\..\..\.." | Select-Object -ExpandProperty Path
$moduleName = Resolve-Path -Path "$PSScriptRoot\..\.." | Get-Item | Select-Object -ExpandProperty BaseName

$resourcePath = Resolve-Path -Path "$modulePath\$moduleName\DSCResources" | Select-Object -ExpandProperty Path
$resourceName = Get-ChildItem -Path $resourcePath | Select-Object -ExpandProperty BaseName

Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$modulePath\$moduleName" -Force

Describe 'DscPullServerWeb' {

    $endpointName = 'PSDSCPullServerWeb'

    Context 'Get-TargetResource' {

        function Get-Website { }

        Mock 'Get-Website' -ModuleName 'DSCPullServerWeb' {
            return $null
        }

        It 'Do It!' {

            #Get-TargetResource -EndpointName $endpointName -CertificateThumbPrint '1234567890ABCDEF1234567890ABCDEF12345678'
        }
    }

    Context 'Set-TargetResource' {

        It 'Do It!' {

            #Set-TargetResource -EndpointName $endpointName -CertificateThumbPrint '1234567890ABCDEF1234567890ABCDEF12345678'
        }
    }

    Context 'Test-TargetResource' {

        It 'Do It!' {

            #Test-TargetResource -EndpointName $endpointName -CertificateThumbPrint '1234567890ABCDEF1234567890ABCDEF12345678'
        }
    }
}
