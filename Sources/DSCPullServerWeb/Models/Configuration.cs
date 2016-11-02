using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DSCPullServerWeb.Models
{
    public class Configuration
    {
        public string Name { get; set; }

        public string Checksum { get; set; }

        public string ChecksumStatus { get; set; }
    }
}
