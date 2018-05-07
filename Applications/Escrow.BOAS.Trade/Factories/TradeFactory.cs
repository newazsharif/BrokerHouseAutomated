using Escrow.BOAS.Trade.Models;
using Escrow.Utility.Factories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.Trade.Factories
{
    public class TradeFactory : GenericFactory<TradeEntities, tblTradeData>
    {
        public void ExecuteTradeFile(tblTradeData tradeData)
        {
            this.Context.psp_execute_trade_file(tradeData.membership_id, tradeData.changed_user_id,tradeData.stock_exchange_id);
        }
        public void ReveseTradeFile(decimal date,decimal stock_exchange_id, decimal membership_id, string changed_user_id)
        {
            this.Context.psp_reverse_trade_file(date,stock_exchange_id,membership_id,changed_user_id);
        }

        public List<string> ExportOmnibusTrade(decimal stock_exchange_id,decimal trd_dt,string omnibus_master_id,string  isTxtOrXml)
        {
            return this.Context.psp_export_omnibus_trade(stock_exchange_id, trd_dt,omnibus_master_id, isTxtOrXml).ToList();
        }
    }
}
