using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.Trade.Interfaces
{
    public interface IExportShareLimitFactory
    {
        DataSet getShareLimits(decimal export_dt, bool isMorning, string omb_ids, string fileName, string branch_ids, decimal membership_id, string connStr);

        string ConvertToShareLimitXMLString(DataSet ds, bool isMorning);

        string ValidateXmlWithXsd(string xmlString, string xsdFile);

        void RollbackExporting(decimal logId, string connStr);
    }
}
