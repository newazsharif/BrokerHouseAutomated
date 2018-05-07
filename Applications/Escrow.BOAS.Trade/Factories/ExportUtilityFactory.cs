using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Trade.Models;
using Escrow.Utility.Factories;
using Escrow.BOAS.Trade.Interfaces;

namespace Escrow.BOAS.Trade.Factories
{
    public class ExportUtilityFactory : GenericFactory<TradeEntities , ssp_ft_exp_log_list_Result>, IExportUtilityFactory
    {
        public List<ssp_ft_exp_log_list_Result> GetExportLogList(string file_type, decimal membership_id)
        {
            List<ssp_ft_exp_log_list_Result> obj = this.Context.ssp_ft_exp_log_list(file_type, membership_id).ToList();

            return obj;
        }
    }
}
