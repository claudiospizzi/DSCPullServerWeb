using DSCPullServerWeb.Helpers;
using DSCPullServerWeb.Services;
using Microsoft.Practices.Unity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace DSCPullServerWeb
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services
            IUnityContainer container = new UnityContainer();
            container.RegisterType<IOptions, Options>(new ContainerControlledLifetimeManager());
            container.RegisterType<IFileSystemRepository, FileSystemRepository>(new HierarchicalLifetimeManager());
            config.DependencyResolver = new UnityResolver(container);

            // Web API routes
            config.MapHttpAttributeRoutes();
            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );
        }
    }
}
