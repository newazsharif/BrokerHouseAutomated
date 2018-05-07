using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace Escrow.BOAS.Trade.Interfaces
{
    public interface IImportCashLimitFactory
    {
        string UploadCashLimitsFile(string connStr, decimal membership_id, decimal import_dt, string omnibus_master_id);

        void importCashLimits(string connStr, decimal membership_id, decimal import_dt, string file_name, string omnibus_master_id, string changed_user_id, DateTime changed_date);
    }
}
