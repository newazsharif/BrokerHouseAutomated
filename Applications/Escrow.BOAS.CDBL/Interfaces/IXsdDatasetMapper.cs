using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using Escrow.BOAS.CDBL.Models;

namespace Escrow.BOAS.CDBL.Interfaces
{
    public interface IXsdDatasetMapper
    {
        DataSet GetDataSet();

        List<CDBLFileModel> GetTableDisplayNames();

        string GetFileName(string displayName, bool WithExtension = false);

        string GetTableName(string displayName);

        DataTable GetTable(string displayName);

        DataTable GetTableForDB(string displayName);
    }
}
