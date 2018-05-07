using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;
using Escrow.BOAS.Transaction.Factories;
using Escrow.BOAS.Transaction.Models;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.Transaction.Interfaces
{
    public interface IFundReceivePayment : IDisposable
    {
        void investorFinancialTransaction(string id, decimal financial_ledger_type_id, decimal membership_id, string changed_user_id);
    }
}
