//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Escrow.BOAS.Transaction.Models
{
    using System;
    
    public partial class ssp_on_dem_char_approve_list_Result
    {
        public Nullable<long> id { get; set; }
        public decimal transaction_date { get; set; }
        public string transaction_dt { get; set; }
        public decimal charge_id { get; set; }
        public string charge_name { get; set; }
        public Nullable<int> investor_no { get; set; }
        public decimal transaction_type_id { get; set; }
        public string transaction_type { get; set; }
        public Nullable<decimal> amount { get; set; }
    }
}