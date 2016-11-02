using DSCPullServerWeb.Models;
using System.Collections.Generic;

namespace DSCPullServerWeb.Services
{
    public interface IFileSystemRepository
    {
        IEnumerable<Configuration> GetConfigurations();

        Configuration GetConfigurationByName(string name);
    }
}
