using System;

namespace DSCPullServerWeb.Models
{
    /// <summary>
    /// DTO for MOF configurations available on the DSC pull server.
    /// </summary>
    public class Configuration
    {
        public string Name { get; set; }

        public DateTime Created { get; set; }

        public string Checksum { get; set; }

        public string ChecksumStatus { get; set; }
    }
}
