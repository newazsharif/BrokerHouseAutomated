using Escrow.BOAS.Trade.Models;
using Escrow.Utility.Factories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.Trade.Factories
{
    public class TmpTradeFactory : GenericFactory<TradeEntities, tmpTradeData>
    {
        public List<psp_upload_trade_Result> getInvestorError()
        {
            List<psp_upload_trade_Result> obj = this.Context.psp_upload_trade().ToList();
            return obj;
        } 
    }
}
