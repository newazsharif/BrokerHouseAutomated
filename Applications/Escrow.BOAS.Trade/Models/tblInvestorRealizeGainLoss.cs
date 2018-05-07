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
    
    public partial class tblInvestorRealizeGainLoss
    {
        public tblInvestorRealizeGainLoss()
        {
            this.tblRealizedGainLossModifications = new HashSet<tblRealizedGainLossModification>();
        }
    
        public decimal id { get; set; }
        public string client_id { get; set; }
        public decimal instrument_id { get; set; }
        public decimal gain_date { get; set; }
        public decimal prev_qty { get; set; }
        public decimal prev_cost { get; set; }
        public decimal sale_qty { get; set; }
        public decimal sale_cost { get; set; }
        public decimal remaining_qty { get; set; }
        public decimal gain { get; set; }
        public int active_status_id { get; set; }
        public decimal membership_id { get; set; }
        public string changed_user_id { get; set; }
        public System.DateTime changed_date { get; set; }
        public decimal is_dirty { get; set; }
    
        public virtual DimDate DimDate { get; set; }
        public virtual ICollection<tblRealizedGainLossModification> tblRealizedGainLossModifications { get; set; }
    }
}
