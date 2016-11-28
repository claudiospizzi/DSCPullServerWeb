using DSCPullServerWeb.Services;
using System;
using System.Web.Http;

namespace DSCPullServerWeb.Controllers
{
    [RoutePrefix("api/v1")]
    public class NodesIdController : ApiController
    {
        private ILogger _logger;

        private IDatabaseRepository _repository;

        public NodesIdController(ILogger logger, IDatabaseRepository repository)
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

        // GET /api/v1/nodes/id
        [HttpGet]
        [Route("nodes/id")]
        public IHttpActionResult Get()
        {
            try
            {
                return Ok(_repository.GetIdNodes());
            }
            catch (Exception e)
            {
                return HandleUnexpectedException(10021, e);
            }
        }
    }
}
