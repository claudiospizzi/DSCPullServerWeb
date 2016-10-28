using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DSCPullServerWeb.Models;
using System.IO;

namespace DSCPullServerWeb.Services
{
    public class FileSystemRepository : IFileSystemRepository
    {
        private IOptions _options;

        public FileSystemRepository(IOptions options)
        {
            _options = options;

            System.Diagnostics.Debug.Write("FileSystemRepository object created");
        }

        public IEnumerable<Configuration> GetAllConfigurations()
        {
            DirectoryInfo directory  = new DirectoryInfo(_options.ConfigurationPath);

            FileInfo[] files = directory.GetFiles("*.mof");

            foreach (FileInfo file in files)
            {
                Configuration configuration = new Configuration()
                {
                    Name = Path.GetFileNameWithoutExtension(file.Name)
                };

                yield return configuration;
            }
        }

        public Configuration GetConfigurationByName(String name)
        {
            return GetAllConfigurations().FirstOrDefault((c) => c.Name == name);
        }
    }
}