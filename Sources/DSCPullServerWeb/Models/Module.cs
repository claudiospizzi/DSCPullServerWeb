using System.IO;

namespace DSCPullServerWeb.Models
{
    /// <summary>
    /// PowerShell modules available on the DSC pull server.
    /// </summary>
    public class Module : FileBase
    {
        public Module(FileInfo zipFile)
            : base(zipFile)
        {
            Refresh();
        }

        protected override void LoadChildProperties()
        {
            Name    = Path.GetFileNameWithoutExtension(_dscFile.Name).Split(new char[] { '_' }, 2)[0];
            Version = Path.GetFileNameWithoutExtension(_dscFile.Name).Split(new char[] { '_' }, 2)[1];
        }

        public string Name
        {
            get;
            private set;
        }
        
        public string Version
        {
            get;
            private set;
        }
    }
}
