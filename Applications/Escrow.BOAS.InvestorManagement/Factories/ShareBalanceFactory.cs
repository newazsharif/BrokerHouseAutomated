using Escrow.BOAS.InvestorManagement.Interfaces;
using Escrow.BOAS.InvestorManagement.Models;
using Escrow.Utility.Factories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.InvestorManagement.Factories
{
    public class ShareBalanceFactory : GenericFactory<InvestorEntities, tblInvestorShareBalance>
    {
        //public List<rsp_client_portfolio_statement_as_on_Result> getProtfolioStatement(decimal membership_id, string UserID, string client_id, DateTime date)
        //{
        //    List<rsp_client_portfolio_statement_as_on_Result> obj = Context.rsp_client_portfolio_statement_as_on(membership_id, UserID, client_id,date).ToList();

        //    return obj;
        //}
    }


}
