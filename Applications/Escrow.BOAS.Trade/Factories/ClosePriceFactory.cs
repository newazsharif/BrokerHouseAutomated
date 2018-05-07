using Escrow.BOAS.Trade.Models;
using Escrow.Utility.Factories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.Trade.Factories
{
    public class ClosePriceFactory : GenericFactory<TradeEntities, tblClosingPrice>
    {
        public void ClosePriceExecute(tblClosingPrice obj)
        {
            this.Context.psp_execute_close_price_file(obj.changed_user_id, obj.membership_id);
        }
    }
}
