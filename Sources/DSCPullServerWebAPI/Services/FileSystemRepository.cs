using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DSCPullServerWebAPI.Models;

namespace DSCPullServerWebAPI.Services
{
    public class FileSystemRepository : IFileSystemRepository
    {
        Configuration[] configurations = new Configuration[]
        {
            new Configuration { Name = "Configuration A" },
            new Configuration { Name = "Configuration B" }
        };

        Module[] modules = new Module[]
        {
            new Module { Name = "Module A", Version = "1.0.0" },
            new Module { Name = "Module B", Version = "2.0.0" }
        };

        public IEnumerable<Configuration> GetAllConfigurations()
        {
            return configurations;
        }

        public Configuration GetConfigurationByName(String name)
        {
            return configurations.FirstOrDefault((c) => c.Name == name);
        }

        public IEnumerable<Module> GetAllModules()
        {
            return modules;
        }

        public Module GetModuleByName(String name)
        {
            return modules.FirstOrDefault((m) => m.Name == name);
        }
    }
}