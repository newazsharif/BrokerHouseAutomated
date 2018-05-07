using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Escrow.Utility.Interfaces;
using Escrow.BOAS.Trade.Models;

namespace Escrow.BOAS.Trade.Interfaces
{
    public interface ITradeFactory : IGenericFactory<tblNonTradingMaster>, IDisposable
    {
        void InsertNonTradingDay (tblNonTradingMaster obj);
    }
}
