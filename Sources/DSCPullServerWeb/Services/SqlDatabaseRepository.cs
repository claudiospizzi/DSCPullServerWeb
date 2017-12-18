using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DSCPullServerWeb.Models;

namespace DSCPullServerWeb.Services
{
    public class SqlDatabaseRepository : IDatabaseRepository
    {
        public IList<IdNode> GetIdNodes()
        {
            throw new NotImplementedException();
        }

        public IList<NamesNode> GetNamesNodes()
        {
            throw new NotImplementedException();
        }

        public IList<Report> GetReports()
        {
            throw new NotImplementedException();
        }
    }
}