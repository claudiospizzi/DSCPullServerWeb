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

            container.RegisterType<IOptions, Options>(new ContainerControlledLifetimeManager());
            container.RegisterType<IFileSystemRepository, FileSystemRepository>(new HierarchicalLifetimeManager());

            container.Resolve<IOptions>();

            // Set the Unity container for the MVC part
            DependencyResolver.SetResolver(new UnityResolverMvc(container));

            // Set the Unity container for the Web API part
            GlobalConfiguration.Configuration.DependencyResolver = new UnityResolverWebApi(container);
        }
    }
}
