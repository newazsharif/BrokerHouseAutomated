using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Escrow.BOAS.CDBL.Interfaces;
using Escrow.BOAS.CDBL.Models;
using Escrow.Utility.Factories;

namespace Escrow.BOAS.CDBL.Factories
{
    public class CDBLFileImportFactory : GenericFactory<CDBLEntities, ssp_CDBL_invalid_data_list_Result>, ICDBLFileImportFactory
    {
        public List<ssp_CDBL_invalid_data_list_Result> getInvalidDataList(string display_names)
        {
            List<ssp_CDBL_invalid_data_list_Result> obj = Context.ssp_CDBL_invalid_data_list(display_names).ToList();

            return obj;
        }
    }
}
