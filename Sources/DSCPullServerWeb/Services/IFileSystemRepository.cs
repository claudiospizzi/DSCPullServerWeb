using DSCPullServerWeb.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DSCPullServerWeb.Services
{
    public interface IFileSystemRepository
    {
        IEnumerable<Configuration> GetAllConfigurations();

        Configuration GetConfigurationByName(string name);
    }
}
