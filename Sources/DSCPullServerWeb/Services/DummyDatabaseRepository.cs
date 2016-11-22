using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DSCPullServerWeb.Models;

namespace DSCPullServerWeb.Services
{
    public class DummyDatabaseRepository : IDatabaseRepository
    {
        public IList<Node> GetNodes()
        {
            List<Node> nodes = new List<Node>();

            nodes.Add(new Node()
            {
                AgentId            = Guid.NewGuid().ToString(),
                NodeName           = "TROMSVHV7027",
                LCMVersion         = "2.0",
                IPAddress          = "10.114.193.143;127.0.0.1;fe80::4c33:893b:9131:40ac%12;::2000:0:0:0;::1;::2000:0:0:0",
                ConfigurationNames = new string[0]
            });

            return nodes;
        }

        public IList<Report> GetReports()
        {
            List<Report> reports = new List<Report>();

            reports.Add(new Report()
            {
                Status = "Success"
            });

            return reports;
        }
    }
}
