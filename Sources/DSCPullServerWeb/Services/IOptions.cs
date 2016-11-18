using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DSCPullServerWeb.Services
{
    public interface IOptions
    {
        string Title { get; }

        string Description { get; }

        string ConfigurationPath { get; }

        string ModulePath { get; }
    }
}