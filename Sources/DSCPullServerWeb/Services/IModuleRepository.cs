using DSCPullServerWeb.Models;
using System.Collections.Generic;
using System.IO;

namespace DSCPullServerWeb.Services
{
    /// <summary>
    /// Interface for the module repository. Get, create, update and
    /// remove module files with this service.
    /// </summary>
    public interface IModuleRepository
    {
        IList<Module> GetModules();

        IList<Module> GetModules(string name);

        Module GetModule(string name, string version);

        void CreateModule(string name, string version, Stream stream);

        FileInfo GetModuleFile(Module module);

        void UpdateModuleChecksum(Module module);

        void DeleteModule(Module module);
    }
}
