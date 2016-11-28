using DSCPullServerWeb.Helpers;
using DSCPullServerWeb.Models;
using DSCPullServerWeb.Services;
using System;
using System.IO;
using System.Threading.Tasks;
using System.Web.Http;

namespace DSCPullServerWeb.Controllers
{
    [RoutePrefix("api/v1")]
    public class ConfigurationsController : ApiController
    {
        private ILogger _logger;

        private IConfigurationRepository _repository;

        public ConfigurationsController(ILogger logger, IConfigurationRepository repository)
        {
            _logger     = logger;
            _repository = repository;
        }

        private IHttpActionResult HandleUnexpectedException(int id, Exception exception)
        {
            _logger.LogHttpRequestException(id, exception, Request, User);

#if DEBUG
            return InternalServerError(exception);
#else
            return InternalServerError();
#endif
        }

        // GET /api/v1/configurations
        [HttpGet]
        [Route("configurations")]
        public IHttpActionResult Get()
        {
            try
            {
                return Ok(_repository.GetConfigurations());
            }
            catch (Exception e)
            {
                return HandleUnexpectedException(10001, e);
            }
        }

        // GET /api/v1/configurations/MyConfig
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
            catch (Exception e)
            {
                return HandleUnexpectedException(10002, e);
            }
        }

        // GET /api/v1/configurations/MyConfig/hash
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
            catch (Exception e)
            {
                return HandleUnexpectedException(10004, e);
            }
        }

        // GET /api/v1/configurations/MyConfig/download
        // GET /api/v1/configurations/MyConfig/download/MyConfig.mof
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

                return new FileActionResult(configuration.GetFileInfo());
            }
            catch (Exception e)
            {
                return HandleUnexpectedException(10005, e);
            }
        }

        // PUT /api/v1/configurations/MyConfig
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
            catch (Exception e)
            {
                return HandleUnexpectedException(10006, e);
            }
        }

        // DELETE /api/v1/configurations/MyConfig
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
            catch (Exception e)
            {
                return HandleUnexpectedException(10007, e);
            }
        }
    }
}
