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
    
    public partial class tblConstantObject
    {
        public tblConstantObject()
        {
            this.tblConstantObjectValues = new HashSet<tblConstantObjectValue>();
        }
    
        public decimal object_id { get; set; }
        public string object_name { get; set; }
        public string Purpose { get; set; }
    
        public virtual ICollection<tblConstantObjectValue> tblConstantObjectValues { get; set; }
    }
}
