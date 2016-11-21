@{
    AllNodes = @(
        @{
            NodeName = '*'

        }

        @{
            NodeName = 'PULLSERVER'
            Role     = @('PullServer')
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