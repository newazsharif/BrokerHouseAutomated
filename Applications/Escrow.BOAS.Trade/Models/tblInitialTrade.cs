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
    
    public partial class tblInitialTrade
    {
        public string Action { get; set; }
        public string Status { get; set; }
        public string Isin { get; set; }
        public string AssetClass { get; set; }
        public string OrderId { get; set; }
        public string ReOrderId { get; set; }
        public string Side { get; set; }
        public string BoId { get; set; }
        public string SecurityCode { get; set; }
        public string Board { get; set; }
        public Nullable<decimal> Date { get; set; }
        public string Time { get; set; }
        public Nullable<decimal> Quantity { get; set; }
        public Nullable<decimal> Price { get; set; }
        public Nullable<decimal> Value { get; set; }
        public string ExecID { get; set; }
        public string Session { get; set; }
        public string FillType { get; set; }
        public string Category { get; set; }
        public string CompulsorySpot { get; set; }
        public string ClientCode { get; set; }
        public string TraderDealerID { get; set; }
        public string OwnerDealerID { get; set; }
        public string TradeReportType { get; set; }
        public decimal Id { get; set; }
        public Nullable<decimal> Comission { get; set; }
        public Nullable<decimal> membership_id { get; set; }
    }
}
