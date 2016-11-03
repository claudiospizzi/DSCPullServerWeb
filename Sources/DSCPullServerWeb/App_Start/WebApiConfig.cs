using DSCPullServerWeb.Helpers;
using DSCPullServerWeb.Services;
using Microsoft.Practices.Unity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Routing;
using System.Net.Http;

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

            // Preload Web API settings from web.config
            container.Resolve<IOptions>();

            // Web API constraints
            //var constraintResolver = new DefaultInlineConstraintResolver();
            //constraintResolver.ConstraintMap.Add("version", typeof(VersionConstraint));

            // Web API routes
            //config.MapHttpAttributeRoutes(constraintResolver);
            config.MapHttpAttributeRoutes();

            //config.Routes.MapHttpRoute(
            //    name: "DefaultApi2",
            //    routeTemplate: "api/{controller}/{name}/{version}",
            //    defaults: new { name = RouteParameter.Optional, version = RouteParameter.Optional }
            //);
            //config.Routes.MapHttpRoute(
            //    name: "DefaultApi",
            //    routeTemplate: "api/{controller}/{name}",
            //    defaults: new { name = RouteParameter.Optional }
            //);
        }
    }

    //public class VersionConstraint : IHttpRouteConstraint
    //{
    //    public Boolean Match(HttpRequestMessage request, IHttpRoute route, String parameterName, IDictionary<String, Object> values, HttpRouteDirection routeDirection)
    //    {
    //        object value;
    //        if (values.TryGetValue(parameterName, out value) && value != null)
    //        {
    //            Version version;
    //            if (Version.TryParse((string)value, out version))
    //            {
    //                return true;
    //            }
    //            else
    //            {
    //                return false;
    //            }
    //        }
    //        return false;
    //    }
    //}
}
