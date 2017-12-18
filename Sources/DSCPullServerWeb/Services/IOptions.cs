namespace DSCPullServerWeb.Services
{
    /// <summary>
    /// Interface to access all options and settings for the DSC Pull Server
    /// website and API.
    /// </summary>
    public interface IOptions
    {
        /// <summary>
        /// Website short name.
        /// </summary>
        string Name { get; }

        /// <summary>
        /// Website title, will be visiable on the landing page banner.
        /// </summary>
        string Title { get; }

        /// <summary>
        /// Website description, will be visiable on the landing page banner.
        /// </summary>
        string Description { get; }

        string Footer { get; }

        string ModulePath { get; }

        string ConfigurationPath { get; }

        string DatabaseType { get; }

        string DatabasePath { get; }

        string RegistrationKeyPath { get; }
    }
}
