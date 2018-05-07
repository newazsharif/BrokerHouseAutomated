using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Escrow.Utility.Interfaces;
using Escrow.BOAS.Trade.Models;

namespace Escrow.BOAS.Trade.Interfaces
{
    public interface IOmnibusImportLogFactory : IGenericFactory<tblFTOmnibusImportLog>, IDisposable
    {
        dynamic getImportLogListByType(string file_type, decimal membership_id, bool is_for_import);
    }
}
