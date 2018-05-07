using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.CDBL.Models;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.CDBL.Interfaces
{
    public interface ICDBLProcessFactory : IGenericFactory<ssp_CDBL_invalid_data_list_Result>, IDisposable
    {
        string ProcessCdbl(string connStr, string displayNames, string fromDate, string toDate, decimal membershipId, string changedUserId, DateTime changedDate, decimal isDirty);

        List<ssp_CDBL_invalid_data_list_Result> getInvalidDataList(string display_names);
        List<ssp_CDBL_invalid_data_list_process_Result> getInvalidDataListForProcess(string display_names);
    }
}
