using System.IO;

namespace DSCPullServerWeb.Models
{
    /// <summary>
    /// MOF configurations available on the DSC pull server.
    /// </summary>
    public class Configuration : FileBase
    {
        public Configuration(FileInfo mofFile)
            : base(mofFile)
        {
            Refresh();
        }

        protected override void LoadChildProperties()
        {
            Name = Path.GetFileNameWithoutExtension(_dscFile.Name);
        }

        public string Name
        {
            get;
            private set;
        }
    }
}
