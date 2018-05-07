using Escrow.BOAS.Trade.Interfaces;
using Escrow.BOAS.Trade.Models;
using Escrow.Utility.Factories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.Trade.Factories
{
    public class TradeMasterFactory : GenericFactory<TradeEntities, tblNonTradingMaster>,ITradeFactory
    {
        public void InsertNonTradingDay(tblNonTradingMaster obj)
        {
            this.Context.isp_non_trading_day(obj.from_date, obj.to_date,obj.non_trading_type_id, obj.input_info, obj.remarks, obj.active_status_id, obj.membership_id, obj.changed_user_id);
        }
    }
}
