using Escrow.BOAS.InstrumentManagement.Models;
using Escrow.Utility.Factories;
using Escrow.Utility.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace Escrow.BOAS.InstrumentManagement.Factories
{
    public class InstrumentReceiveDeliveryFactory : GenericFactory<InstrumentManagementConnection, tblInstrumentManualInOut>, IDisposable
    {
       public override void Save(string id, decimal share_ledger_type_id, decimal membership_id, string changed_user_id)
       {
           using (TransactionScope scope = new TransactionScope(TransactionScopeOption.Required, TimeSpan.FromMinutes(5)))
           {
               try
               {
                   base.Save();
                   this.Context.psp_investor_share_transaction(id, share_ledger_type_id, membership_id, changed_user_id);
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
    }
}
