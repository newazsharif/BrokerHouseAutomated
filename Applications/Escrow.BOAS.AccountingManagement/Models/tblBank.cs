//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Escrow.BOAS.AccountingManagement.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class tblBank
    {
        public tblBank()
        {
            this.tblBankBranches = new HashSet<tblBankBranch>();
        }
    
        public decimal id { get; set; }
        public string short_name { get; set; }
        public string bank_name { get; set; }
        public int active_status_id { get; set; }
        public decimal membership_id { get; set; }
        public string changed_user_id { get; set; }
        public System.DateTime changed_date { get; set; }
        public decimal is_dirty { get; set; }
    
        public virtual ICollection<tblBankBranch> tblBankBranches { get; set; }
    }
}
