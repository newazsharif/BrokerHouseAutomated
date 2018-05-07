using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Charge.Models;
using Escrow.Utility.Factories;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.Charge.Factories
{
    public class InvestorChargeSlabFactory : GenericFactory<ChargeEntities, tblInvestorChargeSlab>
    {
    }
}
