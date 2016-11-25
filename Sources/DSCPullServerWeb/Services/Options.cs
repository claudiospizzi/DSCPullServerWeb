using System;
using System.Web;
using System.Web.Configuration;

namespace DSCPullServerWeb.Services
{
    public class Options : IOptions
    {
        private const string TITLE = "DSC Pull Server Web";

        private const string DESCRIPTION = "Website with a REST API to manage the PowerShell DSC web pull server.";

        private const string FOOTER = "Open-source on <a href=\"https://github.com/claudiospizzi/DSCPullServerWeb\">GitHub</a> by <a href=\"https://github.com/claudiospizzi\" > Claudio Spizzi</a>. Licensed under <a href=\"https://github.com/claudiospizzi/DSCPullServerWeb/blob/dev/LICENSE\" > MIT license</a>.";

        public Options()
        {
            LoadConfig();
        }

        private void LoadConfig()
        {
            Name                = WebConfigurationManager.AppSettings["Name"];
            Title               = WebConfigurationManager.AppSettings["Title"];
            Description         = WebConfigurationManager.AppSettings["Description"];
            Footer              = WebConfigurationManager.AppSettings["Footer"];
            ModulePath          = WebConfigurationManager.AppSettings["ModulePath"];
            ConfigurationPath   = WebConfigurationManager.AppSettings["ConfigurationPath"];
            DatabasePath        = WebConfigurationManager.AppSettings["DatabasePath"];
            RegistrationKeyPath = WebConfigurationManager.AppSettings["RegistrationKeyPath"];

#if DEBUG
            // For debugging, change the path to the App_Data folder, where the
            // test files and databases are stored.
            ModulePath          = HttpContext.Current.Server.MapPath(ModulePath);
            ConfigurationPath   = HttpContext.Current.Server.MapPath(ConfigurationPath);
            DatabasePath        = HttpContext.Current.Server.MapPath(DatabasePath);
            RegistrationKeyPath = HttpContext.Current.Server.MapPath(RegistrationKeyPath);
#endif

            ModulePath          = ModulePath.TrimEnd(new char[] { '\\', '/' });
            ConfigurationPath   = ConfigurationPath.TrimEnd(new char[] { '\\', '/' });
            DatabasePath        = DatabasePath.TrimEnd(new char[] { '\\', '/' });
            RegistrationKeyPath = RegistrationKeyPath.TrimEnd(new char[] { '\\', '/' });

            VerifyConfig();
        }

        private void VerifyConfig()
        {
            if (String.IsNullOrEmpty(Name))
            {
                throw new Exception("Name app setting not found!");
            }
            if (String.IsNullOrEmpty(Title))
            {
                Title = TITLE;
            }
            if (String.IsNullOrEmpty(Description))
            {
                Description = DESCRIPTION;
            }
            if (String.IsNullOrEmpty(Footer))
            {
                Footer = FOOTER;
            }
            if (String.IsNullOrEmpty(ModulePath))
            {
                throw new Exception("ModulePath app setting not found!");
            }
            if (String.IsNullOrEmpty(ConfigurationPath))
            {
                throw new Exception("ConfigurationPath app setting not found!");
            }
            if (String.IsNullOrEmpty(DatabasePath))
            {
                throw new Exception("DatabasePath app setting not found!");
            }
            if (String.IsNullOrEmpty(RegistrationKeyPath))
            {
                throw new Exception("RegistrationKeyPath app setting not found!");
            }
        }

        public String Name
        {
            get;
            private set;
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

        public String Footer
        {
            get;
            private set;
        }

        public String ModulePath
        {
            get;
            private set;
        }

        public String ConfigurationPath
        {
            get;
            private set;
        }

        public String DatabasePath
        {
            get;
            private set;
        }

        public String RegistrationKeyPath
        {
            get;
            private set;
        }
    }
}
