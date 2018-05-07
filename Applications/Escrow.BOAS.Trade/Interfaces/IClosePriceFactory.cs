
using Escrow.BOAS.Trade.Models;
using Escrow.Utility.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.Trade.Interfaces
{
    public interface IClosePriceFactory : IGenericFactory<tblClosingPrice>, IDisposable
    {
        void ClosePriceExecute(tblClosingPrice obj);
    }
}
