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
    
    public partial class ssp_transfer_approve_list_Result
    {
        public decimal id { get; set; }
        public string transferor_id { get; set; }
        public decimal transferor_balance { get; set; }
        public string tranferee_id { get; set; }
        public decimal transferee_balance { get; set; }
        public string transfer_dt { get; set; }
        public string value_dt { get; set; }
        public decimal amount { get; set; }
        public Nullable<decimal> charge_amount { get; set; }
        public string remarks { get; set; }
        public decimal available_balance { get; set; }
        public decimal ledger_balance { get; set; }
        public decimal purchase_power { get; set; }
        public string withdraw_limit_on_name { get; set; }
        public decimal withdrawable_amount { get; set; }
    }
}