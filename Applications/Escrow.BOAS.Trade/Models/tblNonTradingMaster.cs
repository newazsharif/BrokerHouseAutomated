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
    
    public partial class tblNonTradingMaster
    {
        public decimal Id { get; set; }
        public decimal from_date { get; set; }
        public decimal to_date { get; set; }
        public decimal non_trading_type_id { get; set; }
        public string input_info { get; set; }
        public string remarks { get; set; }
        public decimal active_status_id { get; set; }
        public decimal membership_id { get; set; }
        public string changed_user_id { get; set; }
        public System.DateTime changed_date { get; set; }
        public decimal is_dirty { get; set; }
    
        public virtual DimDate DimDate { get; set; }
        public virtual DimDate DimDate1 { get; set; }
        public virtual tblConstantObjectValue tblConstantObjectValue { get; set; }
    }
}
