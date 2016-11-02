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

        // GET api/configurations
        public IHttpActionResult Get()
        {
            try
            {
                return Ok(_repository.GetConfigurations());
            }
            catch
            {
                return InternalServerError();
            }
        }

        // GET api/configurations/MyConfig
        public IHttpActionResult Get(string id)
        {
            try
            {
                var configuration = _repository.GetConfigurationByName(id);
                if (configuration == null)
                {
                    return NotFound();
                }
                return Ok(configuration);
            }
            catch
            {
                return InternalServerError();
            }
        }
    }
}
