using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.Security.Models;
using Escrow.Utility.Factories;
using Escrow.Utility.Interfaces;

namespace Escrow.Security.Factories
{
    public class ControllerFactory : GenericFactory<SecurityConnection,tblController>
    {
    }
}
