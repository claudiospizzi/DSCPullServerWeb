using DSCPullServerWeb.Helpers;
using DSCPullServerWeb.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace DSCPullServerWeb.Services
{
    public class FileSystemRepository : IFileSystemRepository
    {
        private IOptions _options;

        public FileSystemRepository(IOptions options)
        {
            _options = options;
        }

        public IEnumerable<Configuration> GetConfigurations()
        {
            return LoadConfigurations();
        }

        public Configuration GetConfigurationByName(String name)
        {
            return LoadConfigurations(name).FirstOrDefault((c) => c.Name == name);
        }

        private IEnumerable<Configuration> LoadConfigurations(string filter = null)
        {
            if (string.IsNullOrEmpty(filter))
            {
                filter = "*.mof";
            }
            else
            {
                filter = filter + ".mof";
            }

            DirectoryInfo directory = new DirectoryInfo(_options.ConfigurationPath);
            FileInfo[] mofFiles        = directory.GetFiles(filter);

            IList<Configuration> configurations = new List<Configuration>();

            foreach (FileInfo mofFile in mofFiles)
            {
                FileInfo sumFile = new FileInfo(mofFile.FullName + ".checksum");

                Configuration configuration = new Configuration()
                {
                    Name           = Path.GetFileNameWithoutExtension(mofFile.Name),
                    Checksum       = "",
                    ChecksumStatus = "Missing"
                };

                if (sumFile.Exists)
                {
                    configuration.Checksum       = File.ReadAllText(sumFile.FullName);
                    configuration.ChecksumStatus = "Invalid";

                    if (ChecksumCalculator.Validate(mofFile.FullName, configuration.Checksum))
                    {
                        configuration.ChecksumStatus = "Valid";
                    }
                }

                configurations.Add(configuration);
            }

            return configurations;
        }
    }
}
