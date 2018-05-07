﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.Configuration.Models;
using Escrow.Utility.Factories;

namespace Escrow.BOAS.Configuration.Factories
{
    public class AccountMappingFactory : GenericFactory<ConfigurationConnection, accMapping>
    {
        public List<tfun_get_ledger_head_Result> AccountMappingList()
        {
            return this.Context.tfun_get_ledger_head().ToList();
        }
    }
}
