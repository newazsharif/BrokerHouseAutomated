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
    
    public partial class tblInvestorCharge
    {
        public tblInvestorCharge()
        {
            this.tblInvestorChargeSlabs = new HashSet<tblInvestorChargeSlab>();
        }
    
        public decimal id { get; set; }
        public string client_id { get; set; }
        public decimal global_charge_id { get; set; }
        public decimal charge_amount { get; set; }
        public decimal is_percentage { get; set; }
        public decimal is_slab { get; set; }
        public decimal minimum_charge { get; set; }
        public int active_status_id { get; set; }
        public decimal membership_id { get; set; }
        public string changed_user_id { get; set; }
        public System.DateTime changed_date { get; set; }
        public decimal is_dirty { get; set; }
    
        public virtual tblGlobalCharge tblGlobalCharge { get; set; }
        public virtual ICollection<tblInvestorChargeSlab> tblInvestorChargeSlabs { get; set; }
    }
}
