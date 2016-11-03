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
            //response.Content = new StreamContent(File.OpenRead(_file.FullName + ".checksum"));
            response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");

            // NOTE: Here I am just setting the result on the Task and not really doing any async stuff. 
            // But let's say you do stuff like contacting a File hosting service to get the file, then you would do 'async' stuff here.

            return Task.FromResult(response);
        }
    }
}
