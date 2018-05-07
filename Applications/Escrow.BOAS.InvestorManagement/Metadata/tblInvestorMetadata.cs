using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Escrow.BOAS.InvestorManagement.Models
{
    public partial class tblInvestor
    {
        public string active_status { get; set; }

        public decimal available_balance { get; set; }

        public decimal ledger_balance { get; set; }

        public decimal purchase_power { get; set; }

        public string withdraw_limit_on_name { get; set; }

        public decimal withdrawable_amount { get; set; }

        public byte[] photo { get; set; }

        public byte[] signature { get; set; }

        public string account_type { get; set; }

        public string operation_type { get; set; }

        public string Imagestatus { get; set; }

        public string join_holder_name { get; set; }

        public byte[] join_holders_photo { get; set; }

        public byte[] join_holders_signature { get; set; }

        public decimal charge_rate { get; set; }

        public bool is_charge_percentage { get; set; }

        public decimal minimum_charge { get; set; }

        public string password { get; set; }

        public string broker_branch { get; set; }

        public decimal broker_branch_id { get; set; }
      }
}
