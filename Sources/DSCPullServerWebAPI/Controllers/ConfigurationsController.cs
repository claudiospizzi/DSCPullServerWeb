using DSCPullServerWebAPI.Models;
using DSCPullServerWebAPI.Services;
using System.Collections.Generic;
using System.Web.Http;

namespace DSCPullServerWebAPI.Controllers
{
    public class ConfigurationsController : ApiController
    {
        private IFileSystemRepository _repository;

        public ConfigurationsController(IFileSystemRepository repository)
        {
            _repository = repository;
        }

        public IEnumerable<Configuration> GetAllConfigurations()
        {
            return _repository.GetAllConfigurations();
        }

        public IHttpActionResult GetConfiguration(string name)
        {
            var configuration = _repository.GetConfigurationByName(name);
            if (configuration == null)
            {
                return NotFound();
            }
            return Ok(configuration);
        }
    }
}
