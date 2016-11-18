using DSCPullServerWeb.Models;
using System.Collections.Generic;
using System.IO;

namespace DSCPullServerWeb.Services
{
    /// <summary>
    /// Interface for the configuration repository. Get, create, update and
    /// remove configuration files with this service.
    /// </summary>
    public interface IConfigurationRepository
    {
        IList<Configuration> GetConfigurations();

        Configuration GetConfiguration(string name);

        void CreateConfiguration(string name, Stream stream);

        void UpdateConfigurationChecksum(Configuration configuration);

        void DeleteConfiguration(Configuration configuration);
    }
}
