using DSCPullServerWeb.Helpers;
using DSCPullServerWeb.Services;
using Microsoft.Practices.Unity;
using System;
using System.Web.Http;
using System.Web.Mvc;

namespace DSCPullServerWeb
{
    public static class UnityConfig
    {
        public static void RegisterComponents()
        {
            IUnityContainer container = new UnityContainer();

            container.RegisterType<ILogger, Logger>(new ContainerControlledLifetimeManager());
            container.RegisterType<IOptions, Options>(new ContainerControlledLifetimeManager());

            ILogger logger   = container.Resolve<ILogger>();
            IOptions options = container.Resolve<IOptions>();

            container.RegisterType<IModuleRepository, FileSystemRepository>(new HierarchicalLifetimeManager());
            container.RegisterType<IConfigurationRepository, FileSystemRepository>(new HierarchicalLifetimeManager());

            // Based on the option decide which database type is used
            switch (options.DatabaseType)
            {
                case "ESENT":
                    container.RegisterType<IDatabaseRepository, EsentDatabaseRepository>(new ContainerControlledLifetimeManager());
                    break;

                case "SQL":
                    container.RegisterType<IDatabaseRepository, SqlDatabaseRepository>(new ContainerControlledLifetimeManager());
                    break;
            }

            // Set the Unity container for the MVC part
            DependencyResolver.SetResolver(new UnityResolverMvc(container));

            // Set the Unity container for the Web API part
            GlobalConfiguration.Configuration.DependencyResolver = new UnityResolverWebApi(container);
        }
    }
}
