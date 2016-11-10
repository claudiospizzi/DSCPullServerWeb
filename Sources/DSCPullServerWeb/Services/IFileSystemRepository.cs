using DSCPullServerWeb.Models;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace DSCPullServerWeb.Services
{
    public interface IFileSystemRepository
    {
        IList<Configuration> GetConfigurations();

        Configuration GetConfiguration(string name);

        FileInfo GetConfigurationFile(Configuration configuration);

        void CreateConfiguration(string name, Stream stream);

        void UpdateConfigurationChecksum(Configuration configuration);

        void DeleteConfiguration(Configuration configuration);

        IList<Module> GetModules();

        IList<Module> GetModules(string name);

        Module GetModule(string name, string version);

        FileInfo GetModuleFile(Module module);

        void CreateModule(string name, string version, Stream stream);

        void UpdateModuleChecksum(Module module);

        void DeleteModule(Module module);
    }
}
