using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Transaction.Models;
using Escrow.Utility.Factories;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.Transaction.Factories
{
    public class InvestorFactory : GenericFactory<TransactionEntities, tblInvestor>
    {
    }
}
