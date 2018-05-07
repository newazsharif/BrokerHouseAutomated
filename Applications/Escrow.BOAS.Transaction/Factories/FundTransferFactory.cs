using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Transaction.Models;
using Escrow.Utility.Factories;
using Escrow.Utility.Interfaces;
using System.Transactions;
using Escrow.BOAS.Transaction.Interfaces;

namespace Escrow.BOAS.Transaction.Factories
{
    public class FundTransferFactory : GenericFactory<TransactionEntities, tblFundTransfer>, IFundTransferFactory
    {
        public override void Save(string id, decimal financial_ledger_type_id, decimal membership_id, string changed_user_id)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    base.Save();
                    this.Context.psp_investor_financial_transaction(id, financial_ledger_type_id, membership_id, changed_user_id);
                    scope.Complete();
                }
                catch (Exception ex)
                {
                    System.Transactions.Transaction.Current.Rollback();
                    throw ex;
                }
                finally
                {
                    scope.Dispose();
                }
            }
        }

        public dynamic getFundTransferApproveList()
        {
            var obj = this.Context.ssp_transfer_approve_list().ToList();

            return obj;
        }
    }
}
