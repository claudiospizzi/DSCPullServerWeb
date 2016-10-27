namespace DSCPullServerWebAPI.Models
{
    /// <summary>
    /// DTO-class representing a DSC resource module on the pull server.
    /// </summary>
    public class Module
    {
        public string Name { get; set; }

        public string Version { get; set; }
    }
}
