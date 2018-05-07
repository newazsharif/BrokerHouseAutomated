﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.BrokerManagement.Models;
using Escrow.Utility.Factories;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.BrokerManagement.Factories
{
    public class EmployeeInformationFactory : GenericFactory<BrokerManagementEntities, tblEmployee>
    {
    }
}
