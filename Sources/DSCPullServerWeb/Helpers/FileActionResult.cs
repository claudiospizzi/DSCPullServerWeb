using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;

namespace DSCPullServerWeb.Helpers
{
    public class FileActionResult : IHttpActionResult
    {
        private FileInfo _file;

        public FileActionResult(FileInfo file)
        {
            _file = file;
        }

        public Task<HttpResponseMessage> ExecuteAsync(CancellationToken cancellationToken)
        {
            HttpResponseMessage response = new HttpResponseMessage();
            response.Content = new StreamContent(File.OpenRead(_file.FullName));
            response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");

            return Task.FromResult(response);
        }
    }
}
