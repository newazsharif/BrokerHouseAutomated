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
    
    public partial class tblJoinHolder
    {
        public string client_id { get; set; }
        public string join_holder_name { get; set; }
        public string father_name { get; set; }
        public string mother_name { get; set; }
        public Nullable<System.DateTime> birth_date { get; set; }
        public Nullable<decimal> gender_id { get; set; }
        public byte[] photo { get; set; }
        public byte[] signature { get; set; }
        public decimal active_status_id { get; set; }
        public decimal membership_id { get; set; }
        public string changed_user_id { get; set; }
        public System.DateTime changed_date { get; set; }
        public decimal is_dirty { get; set; }
    
        public virtual tblConstantObjectValue tblConstantObjectValue { get; set; }
        public virtual tblConstantObjectValue tblConstantObjectValue1 { get; set; }
        public virtual tblInvestor tblInvestor { get; set; }
    }
}