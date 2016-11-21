
$ModulePath = Resolve-Path -Path "$PSScriptRoot\..\..\Modules" | ForEach-Object Path
$ModuleName = Get-ChildItem -Path $ModulePath | Select-Object -First 1 -ExpandProperty BaseName

Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$ModulePath\$ModuleName" -Force

Describe 'Get-DSCPullServerConfiguration' {

    Mock 'Invoke-RestMethod' -ModuleName $ModuleName {
    }

    Context 'Web Request' {

        It 'should call the valid REST endpoint' {

        }
    }
}
