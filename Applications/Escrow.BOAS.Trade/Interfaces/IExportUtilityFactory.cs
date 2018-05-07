using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Trade.Models;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.Trade.Interfaces
{
    public interface IExportUtilityFactory : IGenericFactory<ssp_ft_exp_log_list_Result>, IDisposable
    {
        List<ssp_ft_exp_log_list_Result> GetExportLogList(string file_type, decimal membership_id);
    }
}
