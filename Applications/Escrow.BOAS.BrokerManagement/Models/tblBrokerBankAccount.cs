//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Escrow.BOAS.BrokerManagement.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class tblBrokerBankAccount
    {
        public decimal id { get; set; }
        public decimal bank_branch_id { get; set; }
        public string account_no { get; set; }
        public int active_status_id { get; set; }
        public decimal membership_id { get; set; }
        public string changed_user_id { get; set; }
        public System.DateTime changed_date { get; set; }
        public decimal is_dirty { get; set; }
        public decimal is_default { get; set; }
    
        public virtual tblBankBranch tblBankBranch { get; set; }
    }
}
