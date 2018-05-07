using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Transaction.Models;
using Escrow.Utility.Interfaces;
using System.Data;

namespace Escrow.BOAS.Transaction.Interfaces
{
    public interface IFundReceiveFactory : IGenericFactory<tblFundReceive>, IDisposable
    {
        DataTable getMoneyReceipt(string voucher_no, decimal membership_id, string changed_user_id, string connStr);
    }
}
