using DSCPullServerWeb.Helpers;
using DSCPullServerWeb.Models;
using DSCPullServerWeb.Services;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using System.Web.Http;

namespace DSCPullServerWeb.Controllers
{
    [RoutePrefix("api")]
    public class ModulesController : ApiController
    {
        private IFileSystemRepository _repository;

        public ModulesController(IFileSystemRepository repository)
        {
            _repository = repository;
        }

        // GET /api/modules
        [HttpGet]
        [Route("modules")]
        public IHttpActionResult Get()
        {
            try
            {
                return Ok(_repository.GetModules());
            }
            catch
            {
                return InternalServerError();
            }
        }

        // GET /api/modules/MyModule
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
            catch
            {
                return InternalServerError();
            }
        }

        // GET /api/modules/MyModule/1.0.0.0
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
            catch
            {
                return InternalServerError();
            }
        }

        // GET /api/modules/MyModule/1.0.0.0/hash
        [HttpGet]
        [Route("modules/{name}/{version}/hash")]
        public IHttpActionResult Hash(string name, string version)
        {
            try
            {
                Module module = _repository.GetModule(name, version);

                if (module == null)
                {
                    return NotFound();
                }

                _repository.UpdateModuleChecksum(module);

                return Ok(module);
            }
            catch
            {
                return InternalServerError();
            }
        }

        // GET /api/modules/MyModule/1.0.0.0/download
        // GET /api/modules/MyModule/1.0.0.0/download/MyModule_1.0.0.0.zip
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

                return new FileActionResult(_repository.GetModuleFile(module));
            }
            catch
            {
                return InternalServerError();
            }
        }

        // PUT /api/modules/MyModule/1.0.0.0
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
            catch
            {
                return InternalServerError();
            }
        }

        // DELETE /api/modules/MyModule/1.0.0.0
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
            catch
            {
                return InternalServerError();
            }
        }
    }
}
