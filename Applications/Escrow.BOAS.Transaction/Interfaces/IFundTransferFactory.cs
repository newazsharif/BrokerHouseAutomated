using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Transaction.Models;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.Transaction.Interfaces
{
    public interface IFundTransferFactory : IGenericFactory<tblFundTransfer>, IDisposable
    {
        dynamic getFundTransferApproveList();
    }
}
