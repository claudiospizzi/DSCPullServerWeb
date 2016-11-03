using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Configuration;

namespace DSCPullServerWeb.Services
{
    public class Options : IOptions
    {
        public Options()
        {
            LoadConfig();
        }

        private void LoadConfig()
        {
            Name              = WebConfigurationManager.AppSettings["Name"];
            ConfigurationPath = WebConfigurationManager.AppSettings["ConfigurationPath"];
            ModulePath        = WebConfigurationManager.AppSettings["ModulePath"];

#if DEBUG
            ConfigurationPath = HttpContext.Current.Server.MapPath(ConfigurationPath);
            ModulePath        = HttpContext.Current.Server.MapPath(ModulePath);
#endif

            ConfigurationPath = ConfigurationPath.TrimEnd(new char[] { '\\', '/' });
            ModulePath        = ModulePath.TrimEnd(new char[] { '\\', '/' });

            if (String.IsNullOrEmpty(ConfigurationPath))
            {
                throw new Exception("ConfigurationPath app setting not found!");
            }
            if (String.IsNullOrEmpty(ModulePath))
            {
                throw new Exception("ModulePath app setting not found!");
            }
        }

        public String Name
        {
            get;
            private set;
        }

        public String ConfigurationPath
        {
            get;
            private set;
        }

        public String ModulePath
        {
            get;
            private set;
        }
    }
}