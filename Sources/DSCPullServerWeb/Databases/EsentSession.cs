using Microsoft.Isam.Esent.Interop;
using System;

namespace DSCPullServerWeb.Databases
{
    public class EsentSession : IDisposable
    {
        private bool _Disposed = false;

        private readonly EsentDatabase _EsentDatabase;

        internal Session Session
        {
            get;
            private set;
        }

        internal JET_DBID DatabaseId
        {
            get;
            private set;
        }

        public EsentSession(EsentDatabase esentDatabase)
        {
            _EsentDatabase = esentDatabase;
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

        ~EsentSession()
        {
            Dispose(false);
        }

        public void Open()
        {
            Session = new Session(_EsentDatabase.Instance);

            Api.JetAttachDatabase(Session, _EsentDatabase.Filename, AttachDatabaseGrbit.ReadOnly);

            JET_DBID databaseId;
            Api.JetOpenDatabase(Session, _EsentDatabase.Filename, null, out databaseId, OpenDatabaseGrbit.ReadOnly);

            DatabaseId = databaseId;
        }

        public void Close()
        {
            if ((Session != null) && (Session.JetSesid != JET_SESID.Nil))
            {
                if (!DatabaseId.Equals(JET_DBID.Nil))
                {
                    Api.JetCloseDatabase(Session, DatabaseId, CloseDatabaseGrbit.None);
                }
                Session.End();
            }
        }

        public JET_SESID GetSessionId()
        {
            return Session.JetSesid;
        }

        public JET_DBID GetDatabaseId()
        {
            return DatabaseId;
        }
    }
}
