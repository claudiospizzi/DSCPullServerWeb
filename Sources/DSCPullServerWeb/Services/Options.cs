using System;
using System.Web;
using System.Web.Configuration;

namespace DSCPullServerWeb.Services
{
    public class Options : IOptions
    {
        private const string TITLE = "DSC Pull Server Web";

        private const string DESCRIPTION = "Website with a REST API to manage the PowerShell DSC web pull server.";

        public Options()
        {
            LoadConfig();
        }

        private void LoadConfig()
        {
            Title             = WebConfigurationManager.AppSettings["Title"];
            Description       = WebConfigurationManager.AppSettings["Description"];
            ConfigurationPath = WebConfigurationManager.AppSettings["ConfigurationPath"];
            ModulePath        = WebConfigurationManager.AppSettings["ModulePath"];

#if DEBUG
            // For debugging, change the path to the App_Data folder, where the
            // test files and databases are stored.
            ConfigurationPath = HttpContext.Current.Server.MapPath(ConfigurationPath);
            ModulePath        = HttpContext.Current.Server.MapPath(ModulePath);
#endif

            ConfigurationPath = ConfigurationPath.TrimEnd(new char[] { '\\', '/' });
            ModulePath        = ModulePath.TrimEnd(new char[] { '\\', '/' });

        }

        private void VerifyConfig()
        {
            if (String.IsNullOrEmpty(Title))
            {
                Title = TITLE;
            }
            if (String.IsNullOrEmpty(Description))
            {
                Description = DESCRIPTION;
            }
            if (String.IsNullOrEmpty(ConfigurationPath))
            {
                throw new Exception("ConfigurationPath app setting not found!");
            }
            if (String.IsNullOrEmpty(ModulePath))
            {
                throw new Exception("ModulePath app setting not found!");
            }
        }

        public String Title
        {
            get;
            private set;
        }

        public String Description
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