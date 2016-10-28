using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DSCPullServerWeb.Services
{
    public interface IOptions
    {
        string ConfigurationPath { get; }
    }
}