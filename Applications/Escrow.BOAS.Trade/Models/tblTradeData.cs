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
    
    public partial class tblTradeData
    {
        public decimal trade_id { get; set; }
        public decimal instrument_id { get; set; }
        public string AssetClass { get; set; }
        public string OrderId { get; set; }
        public string transaction_type { get; set; }
        public string client_id { get; set; }
        public Nullable<decimal> stock_exchange_id { get; set; }
        public decimal market_type_id { get; set; }
        public decimal Date { get; set; }
        public string Time { get; set; }
        public Nullable<decimal> Quantity { get; set; }
        public Nullable<decimal> Unit_Price { get; set; }
        public string ExecID { get; set; }
        public string FillType { get; set; }
        public Nullable<decimal> group_id { get; set; }
        public string CompulsorySpot { get; set; }
        public string TraderDealerID { get; set; }
        public string OwnerDealerID { get; set; }
        public Nullable<decimal> commission_rate { get; set; }
        public Nullable<decimal> commission_amount { get; set; }
        public Nullable<decimal> transaction_fee { get; set; }
        public Nullable<decimal> ait { get; set; }
        public Nullable<decimal> trader_branch_id { get; set; }
        public decimal client_branch_id { get; set; }
        public Nullable<decimal> membership_id { get; set; }
        public string changed_user_id { get; set; }
        public Nullable<System.DateTime> changed_date { get; set; }
        public Nullable<decimal> settled_date { get; set; }
        public decimal is_settled { get; set; }
    
        public virtual tblConstantObjectValue tblConstantObjectValue { get; set; }
        public virtual DimDate DimDate { get; set; }
        public virtual tblConstantObjectValue tblConstantObjectValue1 { get; set; }
    }
}
