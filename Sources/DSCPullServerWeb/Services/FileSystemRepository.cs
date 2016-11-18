using DSCPullServerWeb.Helpers;
using DSCPullServerWeb.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace DSCPullServerWeb.Services
{
    public class FileSystemRepository : IConfigurationRepository, IModuleRepository
    {
        private IOptions _options;

        public FileSystemRepository(IOptions options)
        {
            _options = options;
        }

        #region Implement IConfigurationRepository inferface

        public IList<Configuration> GetConfigurations()
        {
            return LoadConfigurations("*.mof");
        }

        public Configuration GetConfiguration(String name)
        {
            return LoadConfigurations(name + ".mof").FirstOrDefault();
        }

        public void CreateConfiguration(string name, Stream stream)
        {
            FileInfo mofFile = new FileInfo(_options.ConfigurationPath + "\\" + name + ".mof");

            CreateDscFile(mofFile, stream);
            CreateSumFile(mofFile);
        }

        public void UpdateConfigurationChecksum(Configuration configuration)
        {
            CreateSumFile(configuration.GetFileInfo());
        }

        public void DeleteConfiguration(Configuration configuration)
        {
            DeleteDscFile(configuration.GetFileInfo());
            DeleteSumFile(configuration.GetFileInfo());
        }

        #endregion

        #region Implement IModuleRepository inferface

        public IList<Module> GetModules()
        {
            return LoadModules("*_*.zip");
        }

        public IList<Module> GetModules(String name)
        {
            return LoadModules(name + "_*.zip");
        }

        public Module GetModule(String name, String version)
        {
            return LoadModules(name + "_" + version + ".zip").FirstOrDefault();
        }

        public void CreateModule(string name, string version, Stream stream)
        {
            FileInfo zipFile = new FileInfo(_options.ModulePath + "\\" + name + "_" + version + ".zip");

            CreateDscFile(zipFile, stream);
            CreateSumFile(zipFile);
        }

        public void UpdateModuleChecksum(Module module)
        {
            CreateSumFile(module.GetFileInfo());
        }

        public void DeleteModule(Module module)
        {
            DeleteDscFile(module.GetFileInfo());
            DeleteSumFile(module.GetFileInfo());
        }

        #endregion

        #region Internal functions

        private IList<FileInfo> LoadFiles(string path, string filter)
        {
            DirectoryInfo mofDirectory = new DirectoryInfo(path);

            FileInfo[] mofFiles = mofDirectory.GetFiles(filter);

            return new List<FileInfo>(mofFiles);
        }

        private void CreateDscFile(FileInfo dscFile, Stream stream)
        {
            using (FileStream writer = dscFile.Create())
            {
                stream.Seek(0, SeekOrigin.Begin);
                stream.CopyTo(writer);
            }
        }

        private void CreateSumFile(FileInfo dscFile)
        {
            FileInfo sumFile = new FileInfo(dscFile.FullName + ".checksum");

            string sumFileContent = ChecksumCalculator.Create(dscFile.FullName);

            File.WriteAllText(sumFile.FullName, sumFileContent);
        }

        private void DeleteDscFile(FileInfo dscFile)
        {
            if (dscFile.Exists)
            {
                dscFile.Delete();
            }
        }

        private void DeleteSumFile(FileInfo dscFile)
        {
            FileInfo sumFile = new FileInfo(dscFile.FullName + ".checksum");

            if (sumFile.Exists)
            {
                sumFile.Delete();
            }
        }

        private IList<Configuration> LoadConfigurations(string filter)
        {
            IList<Configuration> configurations = new List<Configuration>();

            foreach (FileInfo mofFile in LoadFiles(_options.ConfigurationPath, filter))
            {
                configurations.Add(new Configuration(mofFile));
            }

            return configurations;
        }

        private IList<Module> LoadModules(string filter)
        {
            IList<Module> modules = new List<Module>();

            foreach (FileInfo zipFile in LoadFiles(_options.ModulePath, filter))
            {
                modules.Add(new Module(zipFile));
            }

            return modules;
        }

        #endregion
    }
}
