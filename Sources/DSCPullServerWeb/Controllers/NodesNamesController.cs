using DSCPullServerWeb.Services;
using System;
using System.Web.Http;

namespace DSCPullServerWeb.Controllers
{
    [RoutePrefix("api/v1")]
    public class NodesNamesController : ApiController
    {
        private ILogger _logger;

        private IDatabaseRepository _repository;

        public NodesNamesController(ILogger logger, IDatabaseRepository repository)
        {
            _logger = logger;
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

        // GET /api/v1/nodes/names
        [HttpGet]
        [Route("nodes/names")]
        public IHttpActionResult Get()
        {
            try
            {
                return Ok(_repository.GetNamesNodes());
            }
            catch (Exception e)
            {
                return HandleUnexpectedException(10031, e);
            }
        }
    }
}
