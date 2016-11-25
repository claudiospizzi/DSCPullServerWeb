namespace DSCPullServerWeb.Services
{
    /// <summary>
    /// Interface to access all options and settings for the DSC Pull Server
    /// website and API.
    /// </summary>
    public interface IOptions
    {
        string Name { get; }

        string Title { get; }

        string Description { get; }

        string Footer { get; }

        string ModulePath { get; }

        string ConfigurationPath { get; }

        string DatabasePath { get; }

        string RegistrationKeyPath { get; }
    }
}
