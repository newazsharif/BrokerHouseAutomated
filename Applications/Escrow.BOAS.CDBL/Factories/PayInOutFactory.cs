using Escrow.BOAS.CDBL.Models;
using Escrow.Utility.Factories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Escrow.BOAS.CDBL.Factories
{
    public class PayInOutFactory : GenericFactory<CDBLEntities, tblCdblIpo>
    {
        public  List<psp_export_pay_in_pay_out_Result> ExportPayInOut(string isPayinPayout,decimal trd_dt)
        {
            return this.Context.psp_export_pay_in_pay_out(isPayinPayout,trd_dt).ToList();
        }
    }
}
