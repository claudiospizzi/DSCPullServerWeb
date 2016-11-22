using DSCPullServerWeb.Helpers;
using DSCPullServerWeb.Services;
using Microsoft.Practices.Unity;
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
            container.RegisterType<IModuleRepository, FileSystemRepository>(new HierarchicalLifetimeManager());
            container.RegisterType<IConfigurationRepository, FileSystemRepository>(new HierarchicalLifetimeManager());
            container.RegisterType<IDatabaseRepository, DummyDatabaseRepository>(new HierarchicalLifetimeManager());

            container.Resolve<ILogger>();
            container.Resolve<IOptions>();

            // Set the Unity container for the MVC part
            DependencyResolver.SetResolver(new UnityResolverMvc(container));

            // Set the Unity container for the Web API part
            GlobalConfiguration.Configuration.DependencyResolver = new UnityResolverWebApi(container);
        }
    }
}
