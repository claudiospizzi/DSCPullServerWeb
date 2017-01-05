using DSCPullServerWeb.Helpers;
using DSCPullServerWeb.Models;
using DSCPullServerWeb.Services;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using System.Web.Http;

namespace DSCPullServerWeb.Controllers
{
    [RoutePrefix("api/v1")]
    public class ModulesController : ApiController
    {
        private ILogger _logger;

        private IModuleRepository _repository;

        public ModulesController(ILogger logger, IModuleRepository repository)
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

        // GET /api/v1/modules
        [HttpGet]
        [Route("modules")]
        public IHttpActionResult Get()
        {
            try
            {
                return Ok(_repository.GetModules());
            }
            catch (Exception e)
            {
                return HandleUnexpectedException(10011, e);
            }
        }

        // GET /api/v1/modules/MyModule
        [HttpGet]
        [Route("modules/{name}")]
        public IHttpActionResult Get(string name)
        {
            try
            {
                IList<Module> modules = _repository.GetModules(name);

                if (modules.Count == 0)
                {
                    return NotFound();
                }

                return Ok(modules);
            }
            catch (Exception e)
            {
                return HandleUnexpectedException(10012, e);
            }
        }

        // GET /api/v1/modules/MyModule/1.0.0.0
        [HttpGet]
        [Route("modules/{name}/{version}")]
        public IHttpActionResult Get(string name, string version)
        {
            try
            {
                Module module = _repository.GetModule(name, version);

                if (module == null)
                {
                    return NotFound();
                }

                return Ok(module);
            }
            catch (Exception e)
            {
                return HandleUnexpectedException(10013, e);
            }
        }

        // PATCH /api/v1/modules/MyModule/1.0.0.0/checksum
        [HttpPatch]
        [Route("modules/{name}/{version}/checksum")]
        public IHttpActionResult Checksum(string name, string version)
        {
            try
            {
                Module module = _repository.GetModule(name, version);

                if (module == null)
                {
                    return NotFound();
                }

                _repository.UpdateModuleChecksum(module);

                module = _repository.GetModule(name, version);

                return Ok(module);
            }
            catch (Exception e)
            {
                return HandleUnexpectedException(10014, e);
            }
        }

        // GET /api/v1/modules/MyModule/1.0.0.0/download
        // GET /api/v1/modules/MyModule/1.0.0.0/download/MyModule_1.0.0.0.zip
        [HttpGet]
        [Route("modules/{name}/{version}/download")]
        [Route("modules/{name}/{version}/download/{file}")]
        public IHttpActionResult Download(string name, string version, string file = "")
        {
            try
            {
                var module = _repository.GetModule(name, version);

                if (module == null)
                {
                    return NotFound();
                }

                return new FileActionResult(module.GetFileInfo());
            }
            catch (Exception e)
            {
                return HandleUnexpectedException(10015, e);
            }
        }

        // PUT /api/v1/modules/MyModule/1.0.0.0
        [HttpPut]
        [Route("modules/{name}/{version}")]
        public async Task<IHttpActionResult> Upload(string name, string version)
        {
            try
            {
                Stream stream = await Request.Content.ReadAsStreamAsync();

                _repository.CreateModule(name, version, stream);

                Module module = _repository.GetModule(name, version);

                return Ok(module);
            }
            catch (Exception e)
            {
                return HandleUnexpectedException(10016, e);
            }
        }

        // DELETE /api/v1/modules/MyModule/1.0.0.0
        [HttpDelete]
        [Route("modules/{name}/{version}")]
        public IHttpActionResult Delete(string name, string version)
        {
            try
            {
                var module = _repository.GetModule(name, version);

                if (module == null)
                {
                    return NotFound();
                }

                _repository.DeleteModule(module);

                return Ok();
            }
            catch (Exception e)
            {
                return HandleUnexpectedException(10017, e);
            }
        }
    }
}
