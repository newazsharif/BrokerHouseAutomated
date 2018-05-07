using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using Escrow.BOAS.CDBL.Models;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.CDBL.Interfaces
{
    public interface ICDBLFileSearchFactory : IGenericFactory<psp_export_pay_in_pay_out_Result>, IDisposable
    {
        DataTable GetCDBLFileSearch(string connStr, string tableName, string displayName, string fromDate, string toDate, string isin, string clientId, string boCode);

        void UpdateRightsMarketPrice(string fromDate, string toDate, string isin, string clientId, string boCode);

        void UpdateRightsUnitPrice(string fromDate, string toDate, string isin, string clientId, string boCode, string unitPrice);
    }
}
