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

        public IList<Configuration> GetConfigurations()
        {
            return LoadConfigurations();
        }

        public Configuration GetConfiguration(String name)
        {
            //return LoadConfigurations(name).FirstOrDefault((c) => c.Name == name);
            return LoadConfigurations(name).FirstOrDefault();
        }

        public FileInfo GetConfigurationFile(Configuration configuration)
        {
            return new FileInfo(_options.ConfigurationPath + "\\" + configuration.Name + ".mof");
        }

        public void CreateConfiguration(string name, Stream stream)
        {
            FileInfo mofFile = new FileInfo(_options.ConfigurationPath + "\\" + name + ".mof");
            FileInfo sumFile = new FileInfo(_options.ConfigurationPath + "\\" + name + ".mof.checksum");

            using (FileStream mofFileWriter = mofFile.Create())
            {
                stream.Seek(0, SeekOrigin.Begin);
                stream.CopyTo(mofFileWriter);
            }

            UpdateChecksum(mofFile, sumFile);
        }

        public void UpdateConfigurationChecksum(Configuration configuration)
        {
            FileInfo mofFile = new FileInfo(_options.ConfigurationPath + "\\" + configuration.Name + ".mof");
            FileInfo sumFile = new FileInfo(_options.ConfigurationPath + "\\" + configuration.Name + ".mof.checksum");

            UpdateChecksum(mofFile, sumFile);
        }

        public void DeleteConfiguration(Configuration configuration)
        {
            FileInfo mofFile = new FileInfo(_options.ConfigurationPath + "\\" + configuration.Name + ".mof");
            FileInfo sumFile = new FileInfo(_options.ConfigurationPath + "\\" + configuration.Name + ".mof.checksum");

            if (mofFile.Exists)
            {
                mofFile.Delete();
            }

            if (sumFile.Exists)
            {
                sumFile.Delete();
            }
        }

        IList<Module> IFileSystemRepository.GetModules()
        {
            return LoadModules();
        }

        public IList<Module> GetModules(String name)
        {
            return LoadModules(name);
        }

        public Module GetModule(String name, String version)
        {
            //return LoadModules(name, version).FirstOrDefault((m) => m.Name == name && m.Version == version);
            return LoadModules(name, version).FirstOrDefault();
        }

        public FileInfo GetModuleFile(Module module)
        {
            return new FileInfo(_options.ModulePath + "\\" + module.Name + "_" + module.Version + ".zip");
        }

        public void CreateModule(String name, String version, Stream stream)
        {
            FileInfo zipFile = new FileInfo(_options.ModulePath + "\\" + name + "_" + version + ".zip");
            FileInfo sumFile = new FileInfo(_options.ModulePath + "\\" + name + "_" + version + ".zip.checksum");

            using (FileStream zipFileWriter = zipFile.Create())
            {
                stream.Seek(0, SeekOrigin.Begin);
                stream.CopyTo(zipFileWriter);
            }

            UpdateChecksum(zipFile, sumFile);
        }

        public void UpdateModuleChecksum(Module module)
        {
            FileInfo zipFile = new FileInfo(_options.ModulePath + "\\" + module.Name + "_" + module.Version + ".zip");
            FileInfo sumFile = new FileInfo(_options.ModulePath + "\\" + module.Name + "_" + module.Version + ".zip.checksum");

            UpdateChecksum(zipFile, sumFile);
        }

        public void DeleteModule(Module module)
        {
            FileInfo zipFile = new FileInfo(_options.ModulePath + "\\" + module.Name + "_" + module.Version + ".zip");
            FileInfo sumFile = new FileInfo(_options.ModulePath + "\\" + module.Name + "_" + module.Version + ".zip.checksum");

            if (zipFile.Exists)
            {
                zipFile.Delete();
            }

            if (sumFile.Exists)
            {
                sumFile.Delete();
            }
        }

        private IList<Configuration> LoadConfigurations(string filter = null)
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
            FileInfo[] mofFiles = directory.GetFiles(filter);

            IList<Configuration> configurations = new List<Configuration>();

            foreach (FileInfo mofFile in mofFiles)
            {
                FileInfo sumFile = new FileInfo(mofFile.FullName + ".checksum");

                Configuration configuration = new Configuration()
                {
                    Name           = Path.GetFileNameWithoutExtension(mofFile.Name),
                    Size           = mofFile.Length,
                    Created        = mofFile.CreationTime,
                    Checksum       = "",
                    ChecksumStatus = "Missing"
                };

                if (sumFile.Exists)
                {
                    configuration.Checksum = File.ReadAllText(sumFile.FullName);
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

        private IList<Module> LoadModules(string name = "*", string version = "*")
        {
            string filter = name + "_" + version + ".zip";

            IEnumerable<FileInfo> zipFiles = GetFiles(_options.ModulePath, filter);

            IList<Module> modules = new List<Module>();

            foreach (FileInfo zipFile in zipFiles)
            {
                FileInfo sumFile = new FileInfo(zipFile.FullName + ".checksum");

                Module module = new Module()
                {
                    Name           = Path.GetFileNameWithoutExtension(zipFile.Name).Split(new char[] { '_' }, 2)[0],
                    Version        = Path.GetFileNameWithoutExtension(zipFile.Name).Split(new char[] { '_' }, 2)[1],
                    Size           = zipFile.Length,
                    Created        = zipFile.CreationTime,
                    Checksum       = "",
                    ChecksumStatus = "Missing"
                };

                if (sumFile.Exists)
                {
                    module.Checksum       = File.ReadAllText(sumFile.FullName);
                    module.ChecksumStatus = "Invalid";

                    if (ChecksumCalculator.Validate(zipFile.FullName, module.Checksum))
                    {
                        module.ChecksumStatus = "Valid";
                    }
                }

                modules.Add(module);
            }

            return modules;
        }

        private IList<FileInfo> GetFiles(string path, string filter)
        {
            DirectoryInfo directory = new DirectoryInfo(path);

            return directory.GetFiles(filter);
        }

        private void UpdateChecksum(FileInfo targetFile, FileInfo checksumFile)
        {
            string sumFileContent = ChecksumCalculator.Create(targetFile.FullName);

            File.WriteAllText(checksumFile.FullName, sumFileContent);
        }
    }
}
