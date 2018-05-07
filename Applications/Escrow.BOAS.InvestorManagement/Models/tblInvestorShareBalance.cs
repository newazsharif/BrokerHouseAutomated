//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Escrow.BOAS.InvestorManagement.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class tblInvestorShareBalance
    {
        public decimal transaction_date { get; set; }
        public string client_id { get; set; }
        public decimal instrument_id { get; set; }
        public decimal ledger_quantity { get; set; }
        public decimal salable_quantity { get; set; }
        public decimal ipo_receivable_quantity { get; set; }
        public decimal bonus_receivable_quantity { get; set; }
        public decimal lock_quantity { get; set; }
        public decimal pledge_quantity { get; set; }
        public decimal cost_average { get; set; }
        public decimal cost_value { get; set; }
        public decimal market_price { get; set; }
        public decimal market_value { get; set; }
        public int active_status_id { get; set; }
        public decimal membership_id { get; set; }
        public string changed_user_id { get; set; }
        public System.DateTime changed_date { get; set; }
        public decimal is_dirty { get; set; }
    
        public virtual DimDate DimDate { get; set; }
        public virtual tblInvestor tblInvestor { get; set; }
    }
}
