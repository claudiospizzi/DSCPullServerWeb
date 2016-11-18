using Microsoft.Practices.Unity;
using System;
using System.Collections.Generic;
using System.Web.Http.Dependencies;

namespace DSCPullServerWeb.Helpers
{
    public class UnityResolverWebApi : IDependencyResolver
    {
        bool disposed = false;

        protected IUnityContainer _container;

        public UnityResolverWebApi(IUnityContainer container)
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
            return new UnityResolverWebApi(child);
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposed)
            {
                return;
            }

            // Free all other managed objects.
            if (disposing)
            {
                _container.Dispose();
            }

            // No unmanaged objects to free up here.

            disposed = true;
        }

        ~UnityResolverWebApi()
        {
            Dispose(false);
        }
    }
}