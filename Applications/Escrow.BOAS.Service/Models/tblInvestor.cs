//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Escrow.BOAS.Service.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class tblInvestor
    {
        public tblInvestor()
        {
            this.tblPlaceOrders = new HashSet<tblPlaceOrder>();
        }
    
        public string client_id { get; set; }
        public Nullable<decimal> bo_refernce_id { get; set; }
        public string bo_code { get; set; }
        public string first_holder_name { get; set; }
        public Nullable<System.DateTime> birth_date { get; set; }
        public Nullable<decimal> gender_id { get; set; }
        public string national_id { get; set; }
        public string passport_no { get; set; }
        public string nibondhon_no { get; set; }
        public string father_name { get; set; }
        public string mother_name { get; set; }
        public Nullable<decimal> account_type_id { get; set; }
        public decimal operation_type_id { get; set; }
        public Nullable<decimal> sub_account_type_id { get; set; }
        public string mailing_address { get; set; }
        public string permanent_address { get; set; }
        public Nullable<decimal> thana_id { get; set; }
        public Nullable<decimal> district_id { get; set; }
        public string phone_no { get; set; }
        public string mobile_no { get; set; }
        public string email_address { get; set; }
        public Nullable<decimal> bank_id { get; set; }
        public Nullable<decimal> bank_branch_id { get; set; }
        public string banc_account_no { get; set; }
        public decimal beftn_enabled { get; set; }
        public decimal email_enabled { get; set; }
        public decimal internet_enabled { get; set; }
        public decimal sms_enabled { get; set; }
        public decimal branch_id { get; set; }
        public Nullable<decimal> opening_date { get; set; }
        public string passport_issue_place { get; set; }
        public Nullable<System.DateTime> passport_issue_date { get; set; }
        public Nullable<System.DateTime> passport_valid_to_date { get; set; }
        public decimal trader_id { get; set; }
        public Nullable<decimal> introducer_id { get; set; }
        public decimal ipo_type_id { get; set; }
        public decimal trade_type_id { get; set; }
        public string omnibus_master_id { get; set; }
        public int active_status_id { get; set; }
        public decimal membership_id { get; set; }
        public string changed_user_id { get; set; }
        public System.DateTime changed_date { get; set; }
        public decimal is_dirty { get; set; }
        public Nullable<decimal> export_st { get; set; }
        public Nullable<decimal> export_log_id { get; set; }
    
        public virtual DimDate DimDate { get; set; }
        public virtual ICollection<tblPlaceOrder> tblPlaceOrders { get; set; }
    }
}
