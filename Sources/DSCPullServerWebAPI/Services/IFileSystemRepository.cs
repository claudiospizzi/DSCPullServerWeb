using DSCPullServerWebAPI.Models;
using System.Collections.Generic;

namespace DSCPullServerWebAPI.Services
{
    public interface IFileSystemRepository
    {
        IEnumerable<Configuration> GetAllConfigurations();

        Configuration GetConfigurationByName(string name);

        IEnumerable<Module> GetAllModules();

        Module GetModuleByName(string name);
    }
}
