//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Escrow.Security.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class tblUserActionMapping
    {
        public string user_id { get; set; }
        public decimal action_id { get; set; }
        public decimal is_permitted { get; set; }
        public decimal membership_id { get; set; }
    
        public virtual tblAction tblAction { get; set; }
        public virtual AspNetUser AspNetUser { get; set; }
    }
}
