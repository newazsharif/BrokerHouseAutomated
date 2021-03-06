//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Escrow.BOAS.InstrumentManagement.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class tblInstrumentFundamentalInfo
    {
        public decimal id { get; set; }
        public decimal instrument_id { get; set; }
        public decimal effective_dt { get; set; }
        public decimal eps { get; set; }
        public decimal pe { get; set; }
        public decimal nav { get; set; }
        public decimal total_asset { get; set; }
        public decimal total_liability { get; set; }
        public decimal total_share { get; set; }
        public int active_status_id { get; set; }
        public decimal membership_id { get; set; }
        public string changed_user_id { get; set; }
        public System.DateTime changed_date { get; set; }
        public decimal is_dirty { get; set; }
    
        public virtual DimDate DimDate { get; set; }
        public virtual tblInstrument tblInstrument { get; set; }
    }
}
