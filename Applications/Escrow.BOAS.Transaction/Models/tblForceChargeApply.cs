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
    
    public partial class tblForceChargeApply
    {
        public decimal id { get; set; }
        public string client_id { get; set; }
        public decimal charge_id { get; set; }
        public decimal transaction_type_id { get; set; }
        public decimal amount { get; set; }
        public decimal transaction_date { get; set; }
        public decimal value_date { get; set; }
        public string remarks { get; set; }
        public int active_status_id { get; set; }
        public decimal membership_id { get; set; }
        public string changed_user_id { get; set; }
        public System.DateTime changed_date { get; set; }
        public decimal is_dirty { get; set; }
        public string approve_by { get; set; }
        public Nullable<decimal> approve_date { get; set; }
    
        public virtual tblGlobalCharge tblGlobalCharge { get; set; }
        public virtual DimDate DimDate { get; set; }
        public virtual DimDate DimDate1 { get; set; }
        public virtual DimDate DimDate2 { get; set; }
        public virtual tblConstantObjectValue tblConstantObjectValue { get; set; }
        public virtual tblInvestor tblInvestor { get; set; }
    }
}
