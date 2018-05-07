using Escrow.BOAS.InvestorManagement.Models;
using Escrow.Utility.Interfaces;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.InvestorManagement.Interfaces
{
    public interface IPortStatementFactory : IGenericFactory<tblInvestor>, IDisposable
    {
        DataTable getPortfolioStatement(decimal membership_id, string changed_user_id, string client_id, DateTime date, string connStr);
    }
}
