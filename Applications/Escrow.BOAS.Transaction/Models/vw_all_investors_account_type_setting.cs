//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Escrow.BOAS.Transaction.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class vw_all_investors_account_type_setting
    {
        public string client_id { get; set; }
        public Nullable<decimal> account_type_id { get; set; }
        public string account_type_name { get; set; }
        public decimal initial_deposit { get; set; }
        public decimal minimum_balance_on { get; set; }
        public string minimun_balance_on_name { get; set; }
        public decimal minimum_balance { get; set; }
        public decimal minimum_balance_is_percentage { get; set; }
        public decimal withdraw_limit_on { get; set; }
        public string withdraw_limit_on_name { get; set; }
        public decimal withdraw_limit { get; set; }
        public decimal withdraw_limit_percentage { get; set; }
        public decimal loan_ratio { get; set; }
        public decimal loan_max { get; set; }
        public decimal loan_on { get; set; }
        public string loan_on_name { get; set; }
        public decimal profit_on { get; set; }
        public string profit_on_name { get; set; }
        public decimal available_balance { get; set; }
        public decimal ledger_balance { get; set; }
        public decimal purchase_power { get; set; }
        public decimal withdrawable_amount { get; set; }
    }
}
