using DSCPullServerWeb.Services;
using System;
using System.Web.Http;

namespace DSCPullServerWeb.Controllers
{
    [RoutePrefix("api")]
    public class NodesController : ApiController
    {
        private ILogger _logger;

        private IDatabaseRepository _repository;

        public NodesController(ILogger logger, IDatabaseRepository repository)
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

        // GET /api/nodes
        [HttpGet]
        [Route("nodes")]
        public IHttpActionResult Get()
        {
            try
            {
                return Ok(_repository.GetNodes());
            }
            catch (Exception e)
            {
                return HandleUnexpectedException(10021, e);
            }
        }
    }
}
