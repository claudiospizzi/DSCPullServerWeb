using System.Collections.Generic;

namespace DSCPullServerWeb.Models
{
    public class NamesNode
    {
        public string AgentId
        {
            get;
            set;
        }

        public string NodeName
        {
            get;
            set;
        }

        public string LCMVersion
        {
            get;
            set;
        }

        public string IPAddress
        {
            get;
            set;
        }

        public IList<string> ConfigurationNames
        {
            get;
            set;
        }
    }
}
