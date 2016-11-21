using System;
using System.Net.Http;
using System.Security.Principal;

namespace DSCPullServerWeb.Services
{
    public enum LogLevel
    {
        Error = 1,
        Warning = 2,
        Information = 4
    }

    public interface ILogger
    {
        void Log(int id, string message, LogLevel level);

        void LogHttpRequestException(int id, Exception exception, HttpRequestMessage request, IPrincipal principal);
    }
}
