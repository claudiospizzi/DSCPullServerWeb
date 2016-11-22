namespace DSCPullServerWeb.Models
{
    public class Node
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

        public string[] ConfigurationNames
        {
            get;
            set;
        }
    }
}
