﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Escrow.BOAS.CDBL.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class CDBLEntities : DbContext
    {
        public CDBLEntities()
            : base("name=CDBLEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<tblCdblIpo> tblCdblIpoes { get; set; }
    
        public virtual ObjectResult<psp_export_pay_in_pay_out_Result> psp_export_pay_in_pay_out(string is_payin_payout, Nullable<decimal> trd_dt)
        {
            var is_payin_payoutParameter = is_payin_payout != null ?
                new ObjectParameter("is_payin_payout", is_payin_payout) :
                new ObjectParameter("is_payin_payout", typeof(string));
    
            var trd_dtParameter = trd_dt.HasValue ?
                new ObjectParameter("trd_dt", trd_dt) :
                new ObjectParameter("trd_dt", typeof(decimal));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<psp_export_pay_in_pay_out_Result>("psp_export_pay_in_pay_out", is_payin_payoutParameter, trd_dtParameter);
        }
    
        public virtual ObjectResult<ssp_CDBL_invalid_data_list_Result> ssp_CDBL_invalid_data_list(string display_names)
        {
            var display_namesParameter = display_names != null ?
                new ObjectParameter("display_names", display_names) :
                new ObjectParameter("display_names", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<ssp_CDBL_invalid_data_list_Result>("ssp_CDBL_invalid_data_list", display_namesParameter);
        }
    
        public virtual int usp_rights_market_price(string from_date, string to_date, string isin, string cliend_id, string bo_code)
        {
            var from_dateParameter = from_date != null ?
                new ObjectParameter("from_date", from_date) :
                new ObjectParameter("from_date", typeof(string));
    
            var to_dateParameter = to_date != null ?
                new ObjectParameter("to_date", to_date) :
                new ObjectParameter("to_date", typeof(string));
    
            var isinParameter = isin != null ?
                new ObjectParameter("isin", isin) :
                new ObjectParameter("isin", typeof(string));
    
            var cliend_idParameter = cliend_id != null ?
                new ObjectParameter("cliend_id", cliend_id) :
                new ObjectParameter("cliend_id", typeof(string));
    
            var bo_codeParameter = bo_code != null ?
                new ObjectParameter("bo_code", bo_code) :
                new ObjectParameter("bo_code", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_rights_market_price", from_dateParameter, to_dateParameter, isinParameter, cliend_idParameter, bo_codeParameter);
        }
    
        public virtual int usp_rights_unit_price(string from_date, string to_date, string isin, string cliend_id, string bo_code, string unit_price)
        {
            var from_dateParameter = from_date != null ?
                new ObjectParameter("from_date", from_date) :
                new ObjectParameter("from_date", typeof(string));
    
            var to_dateParameter = to_date != null ?
                new ObjectParameter("to_date", to_date) :
                new ObjectParameter("to_date", typeof(string));
    
            var isinParameter = isin != null ?
                new ObjectParameter("isin", isin) :
                new ObjectParameter("isin", typeof(string));
    
            var cliend_idParameter = cliend_id != null ?
                new ObjectParameter("cliend_id", cliend_id) :
                new ObjectParameter("cliend_id", typeof(string));
    
            var bo_codeParameter = bo_code != null ?
                new ObjectParameter("bo_code", bo_code) :
                new ObjectParameter("bo_code", typeof(string));
    
            var unit_priceParameter = unit_price != null ?
                new ObjectParameter("unit_price", unit_price) :
                new ObjectParameter("unit_price", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("usp_rights_unit_price", from_dateParameter, to_dateParameter, isinParameter, cliend_idParameter, bo_codeParameter, unit_priceParameter);
        }
    
        public virtual ObjectResult<ssp_CDBL_invalid_data_list_process_Result> ssp_CDBL_invalid_data_list_process(string display_names)
        {
            var display_namesParameter = display_names != null ?
                new ObjectParameter("display_names", display_names) :
                new ObjectParameter("display_names", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<ssp_CDBL_invalid_data_list_process_Result>("ssp_CDBL_invalid_data_list_process", display_namesParameter);
        }
    }
}
