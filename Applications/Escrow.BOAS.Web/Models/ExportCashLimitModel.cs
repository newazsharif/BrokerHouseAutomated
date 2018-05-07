using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Escrow.BOAS.Web.Models
{
    public class ExportCashLimitModel
    {
        public decimal export_dt { get; set; }

        public string file_for { get; set; }

        public decimal is_deactive_all { get; set; }
    }
}