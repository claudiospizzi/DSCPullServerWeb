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
        private IFileSystemRepository _repository;

        public ConfigurationsController(IFileSystemRepository repository)
        {
            _repository = repository;
        }

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

        [HttpGet]
        [Route("configurations/{name}/asset")]
        public IHttpActionResult Download(string name)
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
