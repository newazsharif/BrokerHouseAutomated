using Escrow.BOAS.BrokerManagement.Interfaces;
using Escrow.BOAS.BrokerManagement.Models;
using Escrow.Utility.Factories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.BrokerManagement.Factories
{
    public class InvestorFactory : GenericFactory<BrokerManagementEntities, tblInvestor>,IInvestorFactory
    {
        public dynamic getInvestorinfoBySearch(string search, int trader_id)
        {
            var obj = this.Context.ssp_get_investor_info(search, trader_id).ToList();
            return obj;
        }
      }    
}
