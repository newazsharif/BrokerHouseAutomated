using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.CDBL.Interfaces;
using Escrow.BOAS.CDBL.Models;

namespace Escrow.BOAS.CDBL.Factories
{
    public class XsdDatasetMapper : IXsdDatasetMapper
    {
        private string _SchemaFilePath;
        private DataSet ds;

        public XsdDatasetMapper(string SchemaFilePath)
        {
            _SchemaFilePath = SchemaFilePath;
            ds = new DataSet();
            ds.ReadXmlSchema(_SchemaFilePath);
        }

        public DataSet GetDataSet()
        {
            return ds;
        }

        public List<CDBLFileModel> GetTableDisplayNames()
        {
            List<CDBLFileModel> tableNames = new List<CDBLFileModel>();

            CDBLFileModel cdblFileModel = null;

            string tableName = "";

            foreach (DataTable dt in ds.Tables)
            {
                cdblFileModel = new CDBLFileModel();

                tableName = GetDisplayName(dt.TableName);

                cdblFileModel.id = tableName;
                cdblFileModel.name = tableName;

                tableNames.Add(cdblFileModel);
            }
            return tableNames;
        }

        private string GetDisplayName(string tableFullName)
        {
            string displayName = string.Empty;
            displayName = tableFullName.Substring(0, tableFullName.LastIndexOf('_'));
            displayName = displayName.Replace('_', ' ');
            return displayName;
        }

        public string GetFileName(string displayName, bool WithExtension = false)
        {
            string fileName = string.Empty;
            DataTable dt = GetTable(displayName);

            fileName = dt.TableName.Substring(dt.TableName.LastIndexOf('_') + 1);
            if (WithExtension) fileName += ".txt";

            return fileName;
        }

        public string GetTableName(string displayName)
        {
            string fileName = GetFileName(displayName);
            return fileName;
        }

        public DataTable GetTable(string displayName)
        {
            displayName = displayName.Replace(' ', '_');

            foreach (DataTable dt in ds.Tables)
            {
                if (dt.TableName.Contains(displayName))
                {
                    return dt;
                }
            }
            return null;
        }

        public DataTable GetTableForDB(string displayName)
        {
            DataTable dt = GetTable(displayName);

            dt.TableName = "[Escrow.BOAS].[CDBL].[" + dt.TableName.Substring(dt.TableName.LastIndexOf('_') + 1) + "]";

            return dt;
        }
    }
}
