//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Escrow.BOAS.Charge.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class tblGlobalAccountTypeSetting
    {
        public decimal account_type_id { get; set; }
        public decimal initial_deposit { get; set; }
        public decimal minimum_balance_on { get; set; }
        public decimal minimum_balance { get; set; }
        public decimal minimum_balance_is_percentage { get; set; }
        public decimal withdraw_limit_on { get; set; }
        public decimal withdraw_limit { get; set; }
        public decimal withdraw_limit_percentage { get; set; }
        public decimal loan_ratio { get; set; }
        public decimal loan_max { get; set; }
        public decimal loan_on { get; set; }
        public decimal profit_on { get; set; }
        public int active_status_id { get; set; }
        public decimal membership_id { get; set; }
        public string changed_user_id { get; set; }
        public System.DateTime changed_date { get; set; }
        public decimal is_dirty { get; set; }
    
        public virtual tblConstantObjectValue tblConstantObjectValue { get; set; }
        public virtual tblConstantObjectValue tblConstantObjectValue1 { get; set; }
        public virtual tblConstantObjectValue tblConstantObjectValue2 { get; set; }
        public virtual tblConstantObjectValue tblConstantObjectValue3 { get; set; }
        public virtual tblConstantObjectValue tblConstantObjectValue4 { get; set; }
    }
}
