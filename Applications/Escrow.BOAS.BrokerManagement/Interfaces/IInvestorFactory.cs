using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.BrokerManagement.Models;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.BrokerManagement.Interfaces
{
    public interface IInvestorFactory : IGenericFactory<tblInvestor>, IDisposable
    {
        dynamic getInvestorinfoBySearch(string search,int trader_id);
    }
}
