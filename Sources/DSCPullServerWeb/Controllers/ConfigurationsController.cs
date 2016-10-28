using DSCPullServerWeb.Models;
using DSCPullServerWeb.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace DSCPullServerWeb.Controllers
{
    public class ConfigurationsController : ApiController
    {
        private IFileSystemRepository _repository;

        public ConfigurationsController(IFileSystemRepository repository)
        {
            _repository = repository;
        }

        public IEnumerable<Configuration> Get()
        {
            return _repository.GetAllConfigurations();
        }

        public IHttpActionResult Get(string id)
        {
            var configuration = _repository.GetConfigurationByName(id);
            if (configuration == null)
            {
                return NotFound();
            }
            return Ok(configuration);
        }

        //public IEnumerable<Configuration> GetAllConfigurations()
        //{
        //    return _repository.GetAllConfigurations();
        //}

        //public IHttpActionResult GetConfiguration(string name)
        //{
        //    var configuration = _repository.GetConfigurationByName(name);
        //    if (configuration == null)
        //    {
        //        return NotFound();
        //    }
        //    return Ok(configuration);
        //}
    }
}
