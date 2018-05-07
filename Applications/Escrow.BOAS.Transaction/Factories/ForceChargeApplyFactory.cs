using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Transaction.Models;
using Escrow.Utility.Factories;
using Escrow.Utility.Interfaces;
using Escrow.BOAS.Transaction.Interfaces;
using System.Transactions;

namespace Escrow.BOAS.Transaction.Factories
{
    public class ForceChargeApplyFactory : GenericFactory<TransactionEntities, tblForceChargeApply>, IForceChargeApplyFactory
    {
        public void insertAllInvestorOnDemandCharge(tblForceChargeApply obj)
        {
            this.Context.isp_on_dem_char_all_inv(obj.charge_id, obj.transaction_type_id, obj.amount, obj.transaction_date, obj.value_date, obj.remarks, obj.membership_id, obj.changed_user_id, obj.changed_date, obj.is_dirty);
        }


        public List<ssp_on_dem_char_xl_upl_err_Result> getOnDemandChargeExcelUploadError()
        {
            List<ssp_on_dem_char_xl_upl_err_Result> obj = this.Context.ssp_on_dem_char_xl_upl_err().ToList();
            return obj;
        }


        public dynamic getOnDemandApproveList()
        {
            var obj = this.Context.ssp_on_dem_char_approve_list().ToList();
            return obj;
        }

        public void approveOnDemCharge(string transaction_dates, string charge_ids, string transaction_type_ids, decimal approve_date, string approve_by, decimal financial_ledger_type_id, decimal membership_id)
        {
            try
            {
                this.Context.psp_approve_on_dem_char(transaction_dates, charge_ids, transaction_type_ids, approve_date, approve_by, financial_ledger_type_id, membership_id);
            }
            catch (Exception)
            {
                
                throw;
            }
        }

        public List<ssp_on_dem_char_upl_Result> getOnDemandChargeUploadList()
        {
            List<ssp_on_dem_char_upl_Result> obj = this.Context.ssp_on_dem_char_upl().ToList();
            return obj;
        }

        public List<ssp_already_processed_on_dem_char_Result> getOnDemandChargeProcessedListFormExcel(decimal charge_id, decimal transaction_type_id, decimal transaction_date)
        {
            List<ssp_already_processed_on_dem_char_Result> obj = this.Context.ssp_already_processed_on_dem_char(charge_id, transaction_type_id, transaction_date).ToList();
            return obj;
        }

        public void insertOnDemandChargeFromExcel(tblForceChargeApply obj, decimal is_upd_processed_client)
        {
            this.Context.psp_on_dem_char_xl_dt(obj.charge_id, obj.transaction_type_id, obj.transaction_date, obj.value_date, obj.membership_id, obj.changed_user_id, obj.changed_date, obj.is_dirty, is_upd_processed_client);
        }
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
    }
}
