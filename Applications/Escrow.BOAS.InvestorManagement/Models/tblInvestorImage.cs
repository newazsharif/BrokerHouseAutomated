//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Escrow.BOAS.InvestorManagement.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class tblInvestorImage
    {
        public string client_id { get; set; }
        public byte[] photo { get; set; }
        public byte[] signature { get; set; }
    
        public virtual tblInvestor tblInvestor { get; set; }
    }
}
