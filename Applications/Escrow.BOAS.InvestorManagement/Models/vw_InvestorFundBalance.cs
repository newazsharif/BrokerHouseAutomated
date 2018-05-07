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
    
    public partial class vw_InvestorFundBalance
    {
        public string client_id { get; set; }
        public decimal transaction_date { get; set; }
        public Nullable<decimal> account_type_id { get; set; }
        public decimal available_balance { get; set; }
        public decimal sale_receivable { get; set; }
        public decimal un_clear_cheque { get; set; }
        public decimal ledger_balance { get; set; }
        public decimal total_deposit { get; set; }
        public decimal share_transfer_in { get; set; }
        public decimal total_withdraw { get; set; }
        public decimal share_transfer_out { get; set; }
        public decimal realized_interest { get; set; }
        public decimal realized_charge { get; set; }
        public decimal accured_interest { get; set; }
        public decimal fund_withdrawal_request { get; set; }
        public decimal cost_value { get; set; }
        public decimal market_value { get; set; }
        public decimal equity { get; set; }
        public decimal marginable_equity { get; set; }
        public decimal sanction_amount { get; set; }
        public decimal loan_ratio { get; set; }
        public decimal purchase_power { get; set; }
        public decimal max_withdraw_limit { get; set; }
        public decimal excess_over_limit { get; set; }
        public decimal realized_gain { get; set; }
        public decimal unrealized_gain { get; set; }
        public int active_status_id { get; set; }
        public decimal membership_id { get; set; }
        public string changed_user_id { get; set; }
        public System.DateTime changed_date { get; set; }
        public decimal is_dirty { get; set; }
    }
}