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
            ConfigurationPath = WebConfigurationManager.AppSettings["ConfigurationPath"];

            if (String.IsNullOrEmpty(ConfigurationPath))
            {
                throw new Exception("ConfigurationPath app setting not found!");
            }
            if (!Directory.Exists(ConfigurationPath))
            {
                throw new Exception("ConfigurationPath not found on file system!");
            }
        }

        public String ConfigurationPath
        {
            get;
            private set;
        }
    }
}