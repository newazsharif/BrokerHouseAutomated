using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace Escrow.BOAS.Trade.Interfaces
{
    public interface IImportShareLimitFactory
    {
        string UploadShareLimitsFile(string connStr, decimal membership_id, decimal import_dt, string file_name, string omnibus_master_id);

        void importShareLimits(string connStr, decimal membership_id, decimal import_dt, string file_name, string omnibus_master_id);
    }
}
