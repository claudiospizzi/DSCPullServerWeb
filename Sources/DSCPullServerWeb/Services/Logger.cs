using System;
using System.Diagnostics;
using System.Net.Http;
using System.Security.Principal;
using System.Text;
using System.Web;

namespace DSCPullServerWeb.Services
{
    public class Logger : ILogger
    {
        private const string LOG_NAME = "Application";

        private const string LOG_SOURCE = "DSC Pull Server Web";

        private string _source;

        public Logger()
        {
            try
            {
                if (!EventLog.SourceExists(LOG_SOURCE))
                {
                    EventLog.CreateEventSource(LOG_SOURCE, LOG_NAME);
                }
                _source = LOG_SOURCE;
            }
            catch
            {
                _source = LOG_NAME;
            }
        }

        public void Log(Int32 id, String message, LogLevel level)
        {
            EventLog.WriteEntry(_source, message, (EventLogEntryType)level, id);
        }

        public void LogHttpRequestException(Int32 id, Exception exception, HttpRequestMessage request, IPrincipal principal)
        {
            StringBuilder message = new StringBuilder();

            // Add the reequest uri and method
            message.Append("Request: ");
            message.Append(request.Method.Method);
            message.Append(" ");
            message.Append(request.RequestUri.AbsoluteUri);
            message.AppendLine();

            // Add the authenticated identity
            message.Append("User Identity: ");
            message.Append(principal.Identity.Name);
            message.AppendLine();

            // Add the source computer or IP address name
            message.Append("Host Address: ");
            if (request.Properties.ContainsKey("MS_HttpContext"))
            {
                message.Append(((HttpContextWrapper)request.Properties["MS_HttpContext"]).Request.UserHostAddress);
            }
            message.AppendLine();

            message.AppendLine();

            // Finally, the stack trace of the exception
            message.Append(exception);

            Log(id, message.ToString(), LogLevel.Error);
        }
    }
}
