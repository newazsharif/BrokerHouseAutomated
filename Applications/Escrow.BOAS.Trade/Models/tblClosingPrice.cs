//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Escrow.BOAS.Trade.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class tblClosingPrice
    {
        public int Id { get; set; }
        public string security_code { get; set; }
        public Nullable<decimal> open_price { get; set; }
        public Nullable<decimal> high_price { get; set; }
        public Nullable<decimal> low_price { get; set; }
        public decimal closing_price { get; set; }
        public Nullable<decimal> group_id { get; set; }
        public Nullable<decimal> trans_dt { get; set; }
        public decimal membership_id { get; set; }
        public string changed_user_id { get; set; }
        public System.DateTime changed_date { get; set; }
        public Nullable<decimal> var { get; set; }
        public Nullable<decimal> var_percent { get; set; }
        public decimal active_status { get; set; }
    }
}
