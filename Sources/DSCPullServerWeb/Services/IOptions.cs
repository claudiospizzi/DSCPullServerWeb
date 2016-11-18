namespace DSCPullServerWeb.Services
{
    /// <summary>
    /// Interface to access all options and settings for the DSC Pull Server
    /// website and API.
    /// </summary>
    public interface IOptions
    {
        string Title { get; }

        string Description { get; }

        string ConfigurationPath { get; }

        string ModulePath { get; }
    }
}
