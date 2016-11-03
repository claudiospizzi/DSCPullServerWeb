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
    [RoutePrefix("api")]
    public class ModulesController : ApiController
    {
        private IFileSystemRepository _repository;

        public ModulesController(IFileSystemRepository repository)
        {
            _repository = repository;
        }

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

        [HttpGet]
        [Route("modules/{name}/{version}/asset")]
        public IHttpActionResult Download(string name, string version)
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
