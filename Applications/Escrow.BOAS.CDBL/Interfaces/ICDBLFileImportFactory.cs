using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.CDBL.Models;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.CDBL.Interfaces
{
    public interface ICDBLFileImportFactory : IGenericFactory<ssp_CDBL_invalid_data_list_Result>, IDisposable
    {
        List<ssp_CDBL_invalid_data_list_Result> getInvalidDataList(string display_names);
    }
}
