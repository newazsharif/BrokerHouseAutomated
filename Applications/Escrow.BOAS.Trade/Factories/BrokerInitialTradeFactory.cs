using Escrow.BOAS.Trade.Models;
using Escrow.Utility.Factories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.Trade.Factories
{
    public class BrokerInitialTradeFactory : GenericFactory<TradeEntities, tblInitialTrade>
    {
        
        public List<psp_upload_initial_trade_Result> getInvestorError()
        {
            List<psp_upload_initial_trade_Result> obj = this.Context.psp_upload_initial_trade().ToList();
            return obj;
        }
    }
}
