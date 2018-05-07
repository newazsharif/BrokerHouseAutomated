using Escrow.BOAS.InstrumentManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.Utility.Factories;

namespace Escrow.BOAS.InstrumentManagement.Factories
{
    public class InstrumentFactory : GenericFactory<InstrumentManagementConnection, tblInstrument>
    {
    }

    public class ConstantObjectValueFactory : GenericFactory<InstrumentManagementConnection, tblConstantObjectValue>
    {

    }
}
