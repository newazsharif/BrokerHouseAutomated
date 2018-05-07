using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;
using Escrow.BOAS.InvestorManagement.Factories;
using Escrow.BOAS.InvestorManagement.Models;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.InvestorManagement.Interfaces
{
    public interface IInvestorFactory : IGenericFactory<tblInvestor>, IDisposable
    {
        tblInvestor getInvestorInfoByClientId(string client_id);

        tblInvestor getInvestorInfoByClientId(string id, decimal branch);

        List<string> GetInvestorByRange(string cds);
    }
}
