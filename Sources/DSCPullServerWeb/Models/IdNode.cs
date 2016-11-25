using System;

namespace DSCPullServerWeb.Models
{
    public class IdNode
    {
        public string ConfigurationID
        {
            get;
            set;
        }

        public string TargetName
        {
            get;
            set;
        }

        public bool NodeCompliant
        {
            get;
            set;
        }

        public bool Dirty
        {
            get;
            set;
        }

        public DateTime LastHeartbeatTime
        {
            get;
            set;
        }

        public DateTime LastComplianceTime
        {
            get;
            set;
        }

        public int StatusCode
        {
            get;
            set;
        }

        public string ServerCheckSum
        {
            get;
            set;
        }

        public string TargetCheckSum
        {
            get;
            set;
        }
    }
}
