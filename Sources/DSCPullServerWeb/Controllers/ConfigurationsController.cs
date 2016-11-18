using DSCPullServerWeb.Helpers;
using DSCPullServerWeb.Models;
using DSCPullServerWeb.Services;
using System.IO;
using System.Threading.Tasks;
using System.Web.Http;

namespace DSCPullServerWeb.Controllers
{
    [RoutePrefix("api")]
    public class ConfigurationsController : ApiController
    {
        private IConfigurationRepository _repository;

        public ConfigurationsController(IConfigurationRepository repository)
        {
            _repository = repository;
        }

        // GET /api/configurations
        [HttpGet]
        [Route("configurations")]
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

        // GET /api/configurations/MyConfig
        [HttpGet]
        [Route("configurations/{name}")]
        public IHttpActionResult Get(string name)
        {
            try
            {
                var configuration = _repository.GetConfiguration(name);

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

        // GET /api/configurations/MyConfig/hash
        [HttpGet]
        [Route("configurations/{name}/hash")]
        public IHttpActionResult Hash(string name)
        {
            try
            {
                var configuration = _repository.GetConfiguration(name);

                if (configuration == null)
                {
                    return NotFound();
                }

                _repository.UpdateConfigurationChecksum(configuration);

                configuration = _repository.GetConfiguration(name);

                return Ok(configuration);
            }
            catch
            {
                return InternalServerError();
            }
        }

        // GET /api/configurations/MyConfig/download
        // GET /api/configurations/MyConfig/download/MyConfig.mof
        [HttpGet]
        [Route("configurations/{name}/download")]
        [Route("configurations/{name}/download/{file}")]
        public IHttpActionResult Download(string name, string file = "")
        {
            try
            {
                var configuration = _repository.GetConfiguration(name);

                if (configuration == null)
                {
                    return NotFound();
                }

                return new FileActionResult(_repository.GetConfigurationFile(configuration));
            }
            catch
            {
                return InternalServerError();
            }
        }

        // PUT /api/configurations/MyConfig
        [HttpPut]
        [Route("configurations/{name}")]
        public async Task<IHttpActionResult> Upload(string name)
        {
            try
            {
                Stream stream = await Request.Content.ReadAsStreamAsync();

                _repository.CreateConfiguration(name, stream);

                Configuration configuration = _repository.GetConfiguration(name);

                return Ok(configuration);
            }
            catch
            {
                return InternalServerError();
            }
        }

        // DELETE /api/configurations/MyConfig
        [HttpDelete]
        [Route("configurations/{name}")]
        public IHttpActionResult Delete(string name)
        {
            try
            {
                var configuration = _repository.GetConfiguration(name);

                if (configuration == null)
                {
                    return NotFound();
                }

                _repository.DeleteConfiguration(configuration);

                return Ok();
            }
            catch
            {
                return InternalServerError();
            }
        }
    }
}
