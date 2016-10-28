using Microsoft.Practices.Unity;
using System;
using System.Collections.Generic;
using System.Web.Http.Dependencies;

namespace DSCPullServerWeb.Helpers
{
    public class UnityResolver : IDependencyResolver
    {
        protected IUnityContainer _container;

        public UnityResolver(IUnityContainer container)
        {
            if (container == null)
            {
                throw new ArgumentNullException("container");
            }
            _container = container;
        }

        public Object GetService(Type serviceType)
        {
            try
            {
                return _container.Resolve(serviceType);
            }
            catch (ResolutionFailedException)
            {
                return null;
            }
        }

        public IEnumerable<Object> GetServices(Type serviceType)
        {
            try
            {
                return _container.ResolveAll(serviceType);
            }
            catch (ResolutionFailedException)
            {
                return new List<object>();
            }
        }

        public IDependencyScope BeginScope()
        {
            var child = _container.CreateChildContainer();
            return new UnityResolver(child);
        }

        public void Dispose()
        {
            _container.Dispose();
        }
    }
}