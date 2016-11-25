using System;
using System.Collections.Generic;

namespace DSCPullServerWeb.Models
{
    public class Report
    {
        public string Id
        {
            get;
            set;
        }

        public string JobId
        {
            get;
            set;
        }

        public string NodeName
        {
            get;
            set;
        }

        public string IPAddress
        {
            get;
            set;
        }

        public string RerfreshMode
        {
            get;
            set;
        }

        public string OperationType
        {
            get;
            set;
        }

        public string Status
        {
            get;
            set;
        }

        public bool RebootRequested
        {
            get;
            set;
        }

        public DateTime StartTime
        {
            get;
            set;
        }

        public DateTime EndTime
        {
            get;
            set;
        }

        public DateTime LastModifiedTime
        {
            get;
            set;
        }

        public string LCMVersion
        {
            get;
            set;
        }

        public string ConfigurationVersion
        {
            get;
            set;
        }

        public string ReportFormatVersion
        {
            get;
            set;
        }

        public IList<string> Errors
        {
            get;
            set;
        }

        public IList<string> StatusData
        {
            get;
            set;
        }

        public string AdditionalData
        {
            get;
            set;
        }
    }
}
