using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DSCPullServerWeb.Models;
using DSCPullServerWeb.Databases;
using System.IO;
using Microsoft.Isam.Esent.Interop;

namespace DSCPullServerWeb.Services
{
    public class EsentDatabaseRepository : IDatabaseRepository
    {
        private const string DATABASE_NAME = "Devices.edb";

        private const string TABLE_DEVICES = "Devices";

        private const string TABLE_REGISTRATION_DATA = "RegistrationData";

        private const string TABLE_STATUS_REPORT = "StatusReport";

        private ILogger _logger;

        private IOptions _options;

        private EsentDatabase _database;

        public EsentDatabaseRepository(ILogger logger, IOptions options)
        {
            _logger  = logger;
            _options = options;

            _database = new EsentDatabase(_options.Name, Path.Combine(_options.DatabasePath, DATABASE_NAME));
            _database.Open();
        }

        #region Id Nodes Interface

        public IList<IdNode> GetIdNodes()
        {
            IList<IdNode> nodes = new List<IdNode>();

            using (EsentSession session = new EsentSession(_database))
            {
                session.Open();

                JET_SESID sessionId = session.GetSessionId();
                JET_DBID databaseId = session.GetDatabaseId();
                JET_TABLEID tableId;

                if (DatabaseExists(sessionId, databaseId, TABLE_DEVICES))
                {
                    Api.OpenTable(sessionId, databaseId, TABLE_DEVICES, OpenTableGrbit.ReadOnly, out tableId);

                    Api.MoveBeforeFirst(session.GetSessionId(), tableId);

                    while (Api.TryMoveNext(sessionId, tableId))
                    {
                        IDictionary<string, JET_COLUMNID> columnDictionary = Api.GetColumnDictionary(sessionId, tableId);

                        IdNode node = new IdNode()
                        {
                            ConfigurationID    = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["ConfigurationID"]),
                            TargetName         = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["TargetName"]),
                            NodeCompliant      = Api.RetrieveColumnAsBoolean(sessionId, tableId, columnDictionary["NodeCompliant"]).GetValueOrDefault(),
                            Dirty              = Api.RetrieveColumnAsBoolean(sessionId, tableId, columnDictionary["Dirty"]).GetValueOrDefault(),
                            LastHeartbeatTime  = Api.RetrieveColumnAsDateTime(sessionId, tableId, columnDictionary["LastHeartbeatTime"]).GetValueOrDefault(),
                            LastComplianceTime = Api.RetrieveColumnAsDateTime(sessionId, tableId, columnDictionary["LastComplianceTime"]).GetValueOrDefault(),
                            StatusCode         = Api.RetrieveColumnAsInt32(sessionId, tableId, columnDictionary["StatusCode"]).GetValueOrDefault(),
                            ServerCheckSum     = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["ServerCheckSum"]),
                            TargetCheckSum     = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["TargetCheckSum"])
                        };

                        nodes.Add(node);
                    }

                    Api.JetCloseTable(sessionId, tableId);
                }
                else
                {
                    _logger.Log(10091, String.Format("Database table {0} not found!", TABLE_DEVICES), LogLevel.Warning);
                }
            }

            return nodes;
        }

        #endregion

        #region Names Nodes Interface

        public IList<NamesNode> GetNamesNodes()
        {
            IList<NamesNode> nodes = new List<NamesNode>();

            using (EsentSession session = new EsentSession(_database))
            {
                session.Open();

                JET_SESID sessionId = session.GetSessionId();
                JET_DBID databaseId = session.GetDatabaseId();
                JET_TABLEID tableId;

                if (DatabaseExists(sessionId, databaseId, TABLE_REGISTRATION_DATA))
                {
                    Api.OpenTable(sessionId, databaseId, TABLE_REGISTRATION_DATA, OpenTableGrbit.ReadOnly, out tableId);

                    Api.MoveBeforeFirst(session.GetSessionId(), tableId);

                    while (Api.TryMoveNext(sessionId, tableId))
                    {
                        IDictionary<string, JET_COLUMNID> columnDictionary = Api.GetColumnDictionary(sessionId, tableId);

                        NamesNode node = new NamesNode()
                        {
                            AgentId            = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["AgentId"]),
                            NodeName           = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["NodeName"]),
                            LCMVersion         = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["LCMVersion"]),
                            IPAddress          = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["IPAddress"]),
                            ConfigurationNames = ((List<string>)Api.DeserializeObjectFromColumn(sessionId, tableId, columnDictionary["ConfigurationNames"]))
                        };

                        nodes.Add(node);
                    }

                    Api.JetCloseTable(sessionId, tableId);
                }
                else
                {
                    _logger.Log(10091, String.Format("Database table {0} not found!", TABLE_REGISTRATION_DATA), LogLevel.Warning);
                }
            }

            return nodes;
        }

        #endregion

        #region Report Interface

        public IList<Report> GetReports()
        {
            List<Report> reports = new List<Report>();

            using (EsentSession session = new EsentSession(_database))
            {
                session.Open();

                JET_SESID sessionId = session.GetSessionId();
                JET_DBID databaseId = session.GetDatabaseId();
                JET_TABLEID tableId;

                if (DatabaseExists(sessionId, databaseId, TABLE_STATUS_REPORT))
                {
                    Api.OpenTable(sessionId, databaseId, TABLE_STATUS_REPORT, OpenTableGrbit.ReadOnly, out tableId);

                    Api.MoveBeforeFirst(session.GetSessionId(), tableId);

                    while (Api.TryMoveNext(sessionId, tableId))
                    {
                        IDictionary<string, JET_COLUMNID> columnDictionary = Api.GetColumnDictionary(sessionId, tableId);

                        Report report = new Report()
                        {
                            Id                   = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["Id"]),
                            JobId                = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["JobId"]),
                            NodeName             = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["NodeName"]),
                            IPAddress            = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["IPAddress"]),
                            RerfreshMode         = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["RefreshMode"]),
                            OperationType        = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["OperationType"]),
                            Status               = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["Status"]),
                            RebootRequested      = Api.RetrieveColumnAsBoolean(sessionId, tableId, columnDictionary["RebootRequested"]).GetValueOrDefault(),
                            StartTime            = Api.RetrieveColumnAsDateTime(sessionId, tableId, columnDictionary["StartTime"]).GetValueOrDefault(),
                            EndTime              = Api.RetrieveColumnAsDateTime(sessionId, tableId, columnDictionary["EndTime"]).GetValueOrDefault(),
                            LastModifiedTime     = Api.RetrieveColumnAsDateTime(sessionId, tableId, columnDictionary["LastModifiedTime"]).GetValueOrDefault(),
                            LCMVersion           = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["LCMVersion"]),
                            ConfigurationVersion = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["ConfigurationVersion"]),
                            ReportFormatVersion  = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["ReportFormatVersion"]),
                            Errors               = (List<string>)Api.DeserializeObjectFromColumn(sessionId, tableId, columnDictionary["Errors"]),
                            StatusData           = (List<string>)Api.DeserializeObjectFromColumn(sessionId, tableId, columnDictionary["StatusData"])
                        };

                        // Field AdditionalData is only available on WS2016 and WMF 5.1
                        if (columnDictionary.Keys.Contains("AdditionalData"))
                        {
                            report.AdditionalData = Api.RetrieveColumnAsString(sessionId, tableId, columnDictionary["AdditionalData"]);
                        }

                        reports.Add(report);
                    }

                    Api.JetCloseTable(sessionId, tableId);
                }
                else
                {
                    _logger.Log(10091, String.Format("Database table {0} not found!", TABLE_STATUS_REPORT), LogLevel.Warning);
                }
            }

            return reports.OrderBy(r => r.StartTime).ToList();
        }

        #endregion

        private Boolean DatabaseExists(JET_SESID sessionId, JET_DBID databaseId, String tableName)
        {
            return Api.GetTableNames(sessionId, databaseId).Select(t => t == tableName).Count() == 1;
        }
    }
}
