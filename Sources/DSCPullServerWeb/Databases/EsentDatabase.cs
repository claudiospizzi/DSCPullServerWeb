using Microsoft.Isam.Esent.Interop;
using System;
using System.IO;

namespace DSCPullServerWeb.Databases
{
    public class EsentDatabase : IDisposable
    {
        private bool _Disposed = false;

        internal string Name
        {
            get;
            private set;
        }

        internal Instance Instance
        {
            get;
            private set;
        }

        internal string Filename
        {
            get;
            private set;
        }

        internal string Directory
        {
            get;
            private set;
        }

        public EsentDatabase(string name, string filename)
        {
            Name      = "DSCPullServerWeb" + name;
            Filename  = filename;
            Directory = Path.GetDirectoryName(filename) + Path.DirectorySeparatorChar;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (_Disposed)
            {
                return;
            }

            if (disposing)
            {
                // Free any other managed objects here.
                Close();
            }

            // Free any unmanaged objects here.

            _Disposed = true;
        }

        ~EsentDatabase()
        {
            Dispose(false);
        }

        public void Open()
        {
            int pageSize;
            Api.JetGetDatabaseFileInfo(Filename, out pageSize, JET_DbInfo.PageSize);

            Api.JetSetSystemParameter(JET_INSTANCE.Nil, JET_SESID.Nil, JET_param.DatabasePageSize, pageSize, null);
            Api.JetSetSystemParameter(JET_INSTANCE.Nil, JET_SESID.Nil, JET_param.LogFilePath, 0, Directory);
            Api.JetSetSystemParameter(JET_INSTANCE.Nil, JET_SESID.Nil, JET_param.SystemPath, 0, Directory);
            Api.JetSetSystemParameter(JET_INSTANCE.Nil, JET_SESID.Nil, JET_param.TempPath, 0, Directory);  // ToDo: Dedicated path for temp file?
            Api.JetSetSystemParameter(JET_INSTANCE.Nil, JET_SESID.Nil, JET_param.Recovery, 0, "Off");

            Instance = new Instance(Name);
            Instance.Init();
        }

        public void Close()
        {
            if ((Instance != null) && !Instance.Equals(JET_INSTANCE.Nil))
            {
                Instance.Close();
            }
        }
    }
}
