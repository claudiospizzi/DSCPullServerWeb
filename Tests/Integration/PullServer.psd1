@{
    AllNodes = @(
        @{
            NodeName = 'LAB-DSC-SERVER1'
            Role     = @('PullServer')

            CertificateThumbPrint = '0FA990AF420A7D597FD221374297DE23B8860B8C'
            RegistrationKey       = '822CE064-9EA6-4DBE-AFC6-D90F256AF199'
        }

        @{
            NodeName = 'LAB-DSC-NODE11'
            Role     = @('NodeLcm')

            PullServerUrl   = 'https://LAB-DSC-SERVER1.spizzi.lab:8080/PSDSCPullServer.svc'
            RegistrationKey = '822CE064-9EA6-4DBE-AFC6-D90F256AF199'

            ConfigurationId    = 'DD34ADD4-DF15-4FC5-A922-B0B2D4E8809A'
            ConfigurationNames = $null
        }

        @{
            NodeName = 'LAB-DSC-NODE12'
            Role     = @('NodeLcm')

            PullServerUrl   = 'https://LAB-DSC-SERVER1.spizzi.lab:8080/PSDSCPullServer.svc'
            RegistrationKey = '822CE064-9EA6-4DBE-AFC6-D90F256AF199'

            ConfigurationId    = $null
            ConfigurationNames = @('MyConfigName')
        }

        @{
            NodeName = 'LAB-DSC-SERVER2'
            Role     = @('PullServer')

            CertificateThumbPrint = '60BDA548E01F51D76B9762DB30750F63AE67C24B'
            RegistrationKey       = '822CE064-9EA6-4DBE-AFC6-D90F256AF199'
        }

        @{
            NodeName = 'LAB-DSC-NODE21'
            Role     = @('NodeLcm')

            PullServerUrl   = 'https://LAB-DSC-SERVER2.spizzi.lab:8080/PSDSCPullServer.svc'
            RegistrationKey = '822CE064-9EA6-4DBE-AFC6-D90F256AF199'

            ConfigurationId    = 'DD34ADD4-DF15-4FC5-A922-B0B2D4E8809A'
            ConfigurationNames = $null
        }

        @{
            NodeName = 'LAB-DSC-NODE22'
            Role     = @('NodeLcm')

            PullServerUrl   = 'https://LAB-DSC-SERVER2.spizzi.lab:8080/PSDSCPullServer.svc'
            RegistrationKey = '822CE064-9EA6-4DBE-AFC6-D90F256AF199'

            ConfigurationId    = $null
            ConfigurationNames = @('MyConfigName')
        }
    )
}
