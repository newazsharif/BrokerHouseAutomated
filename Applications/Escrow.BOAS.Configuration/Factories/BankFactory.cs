using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Configuration.Models;
using Escrow.Utility.Factories;

namespace Escrow.BOAS.Configuration.Factories
{
    public class BankFactory : GenericFactory<ConfigurationConnection, tblBank>
    {
    }
}
