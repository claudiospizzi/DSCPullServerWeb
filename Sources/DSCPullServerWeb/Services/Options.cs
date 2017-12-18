using System;
using System.Web;
using System.Web.Configuration;

namespace DSCPullServerWeb.Services
{
    /// <summary>
    /// Class to access all options and settings for the DSC Pull Server
    /// website and API.
    /// </summary>
    public class Options : IOptions
    {
        private const string TITLE = "DSC Pull Server Web";

        private const string DESCRIPTION = "Website with a REST API to manage the PowerShell DSC web pull server.";

        private const string FOOTER = "Open-source on <a href=\"https://github.com/claudiospizzi/DSCPullServerWeb\">GitHub</a> by <a href=\"https://github.com/claudiospizzi\" > Claudio Spizzi</a>. Licensed under <a href=\"https://github.com/claudiospizzi/DSCPullServerWeb/blob/dev/LICENSE\" > MIT license</a>.";

        /// <summary>
        /// Create a new options class and load the configuration.
        /// </summary>
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
            DatabaseType        = WebConfigurationManager.AppSettings["DatabaseType"];
            DatabasePath        = WebConfigurationManager.AppSettings["DatabasePath"];
            RegistrationKeyPath = WebConfigurationManager.AppSettings["RegistrationKeyPath"];

#if DEBUG
            // For debugging, change the path to the App_Data folder, where the
            // test files and databases are stored.
            ModulePath          = HttpContext.Current.Server.MapPath(ModulePath);
            ConfigurationPath   = HttpContext.Current.Server.MapPath(ConfigurationPath);
            DatabaseType        = "ESENT";
            DatabasePath        = HttpContext.Current.Server.MapPath(DatabasePath);
            RegistrationKeyPath = HttpContext.Current.Server.MapPath(RegistrationKeyPath);
#endif

            // Trim path
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
                throw new Exception("Name app setting not found! Please verify the appSetting node in the Web.config.");
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
                throw new Exception("ModulePath app setting not found! Please verify the appSetting node in the Web.config.");
            }
            if (String.IsNullOrEmpty(ConfigurationPath))
            {
                throw new Exception("ConfigurationPath app setting not found! Please verify the appSetting node in the Web.config.");
            }
            if (DatabaseType != "ESENT" && DatabaseType != "SQL")
            {
                throw new Exception("DatabaseType app setting not supported! Please verify the appSetting node in the Web.config. Supported values are ESENT and SQL.");
            }
            if (String.IsNullOrEmpty(DatabasePath))
            {
                throw new Exception("DatabasePath app setting not found! Please verify the appSetting node in the Web.config.");
            }
            if (String.IsNullOrEmpty(RegistrationKeyPath))
            {
                throw new Exception("RegistrationKeyPath app setting not found! Please verify the appSetting node in the Web.config.");
            }
        }

        /// <summary>
        /// <see cref="IOptions.Name"/>
        /// </summary>
        public String Name
        {
            get;
            private set;
        }

        /// <summary>
        /// <see cref="IOptions.Title"/>
        /// </summary>
        public String Title
        {
            get;
            private set;
        }

        /// <summary>
        /// <see cref="IOptions.Description"/>
        /// </summary>
        public String Description
        {
            get;
            private set;
        }

        /// <summary>
        /// Website footer, will be visiable on any page.
        /// </summary>
        public String Footer
        {
            get;
            private set;
        }

        /// <summary>
        /// Local path to the PowerShell module location.
        /// </summary>
        public String ModulePath
        {
            get;
            private set;
        }

        /// <summary>
        /// Local path to the DSC configuration files.
        /// </summary>
        public String ConfigurationPath
        {
            get;
            private set;
        }

        /// <summary>
        /// Type of the database, ESENT or SQL.
        /// </summary>
        public String DatabaseType
        {
            get;
            private set;
        }

        /// <summary>
        /// Local path to the ESENT database or connection string to the SQL server database.
        /// </summary>
        public String DatabasePath
        {
            get;
            private set;
        }

        /// <summary>
        /// Path to the registration key file.
        /// </summary>
        public String RegistrationKeyPath
        {
            get;
            private set;
        }
    }
}
