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
    public interface IForceChargeApplyFactory : IGenericFactory<tblForceChargeApply>, IDisposable
    {
        void insertAllInvestorOnDemandCharge(tblForceChargeApply obj);

        List<ssp_on_dem_char_xl_upl_err_Result> getOnDemandChargeExcelUploadError();

        dynamic getOnDemandApproveList();

        void approveOnDemCharge(string transaction_dates, string charge_ids, string transaction_type_ids, decimal approve_date, string approve_by, decimal financial_ledger_type_id, decimal membership_id);

        List<ssp_on_dem_char_upl_Result> getOnDemandChargeUploadList();

        List<ssp_already_processed_on_dem_char_Result> getOnDemandChargeProcessedListFormExcel(decimal charge_id, decimal transaction_type_id, decimal transaction_date);

        void insertOnDemandChargeFromExcel(tblForceChargeApply obj, decimal is_upd_processed_client);
    }
}
