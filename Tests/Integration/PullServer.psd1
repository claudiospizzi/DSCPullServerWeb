@{
    AllNodes = @(
        @{
            NodeName     = 'LAB-DSC-SERVER1'
            Role         = @('PullServer')
        }

        @{
            NodeName     = 'LAB-DSC-NODE11'
            Role         = @('NodeLcm')

            PullServer   = 'http://LAB-DSC-SERVER1:8080/PSDSCPullServer.svc'
        }

        @{
            NodeName     = 'LAB-DSC-NODE12'
            Role         = @('NodeLcm')

            PullServer   = 'http://LAB-DSC-SERVER1:8081/PSDSCPullServer.svc'
        }

        @{
            NodeName     = 'LAB-DSC-SERVER2'
            Role         = @('PullServer')
        }

        @{
            NodeName     = 'LAB-DSC-NODE21'
            Role         = @('NodeLcm')

            PullServer   = 'http://LAB-DSC-SERVER2:8080/PSDSCPullServer.svc'
        }

        @{
            NodeName     = 'LAB-DSC-NODE22'
            Role         = @('NodeLcm')

            PullServer   = 'http://LAB-DSC-SERVER2:8081/PSDSCPullServer.svc'
        }
    )

    PullServerConfig = @(
        @{
            Name    = 'TenantA'

            SvcPort = 8080
            WebPort = 8090
        }

        @{
            Name    = 'TenantB'

            SvcPort = 8081
            WebPort = 8091
        }
    )
}
