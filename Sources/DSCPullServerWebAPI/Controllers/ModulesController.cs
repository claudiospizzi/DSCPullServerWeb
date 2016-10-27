using DSCPullServerWebAPI.Models;
using DSCPullServerWebAPI.Services;
using System.Collections.Generic;
using System.Web.Http;

namespace DSCPullServerWebAPI.Controllers
{
    public class ModulesController : ApiController
    {
        private IFileSystemRepository _repository;

        public ModulesController(IFileSystemRepository repository)
        {
            _repository = repository;
        }

        public IEnumerable<Module> GetAllModules()
        {
            return _repository.GetAllModules();
        }

        public IHttpActionResult GetModule(string name)
        {
            var module = _repository.GetModuleByName(name);
            if (module == null)
            {
                return NotFound();
            }
            return Ok(module);
        }
    }
}
