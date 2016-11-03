namespace DSCPullServerWeb.Models
{
    /// <summary>
    /// DTO for PowerShell modules available on the DSC pull server.
    /// </summary>
    public class Module
    {
        public string Name { get; set; }

        public string Version { get; set; }

        public string Checksum { get; set; }

        public string ChecksumStatus { get; set; }
    }
}
