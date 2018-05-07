using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Escrow.Service.Models
{
    public class ShareBalanceVM
    {
        public string instrument_name { get; set; }
        public decimal ledger_quantity { get; set; }
        public decimal salable_quantity { get; set; }
        public decimal cost_average { get; set; }
        public decimal cost_value { get; set; }
        public decimal market_price { get; set; }
        public decimal market_value { get; set; }
    }
}