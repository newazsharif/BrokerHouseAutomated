﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Escrow.BOAS.BrokerManagement.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class BrokerManagementEntities : DbContext
    {
        public BrokerManagementEntities()
            : base("name=BrokerManagementEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<tblDepositoryPerticipant> tblDepositoryPerticipants { get; set; }
        public virtual DbSet<tblEmployeeUserMapping> tblEmployeeUserMappings { get; set; }
        public virtual DbSet<tblTrader> tblTraders { get; set; }
        public virtual DbSet<DimDate> DimDates { get; set; }
        public virtual DbSet<tblConstantObject> tblConstantObjects { get; set; }
        public virtual DbSet<tblConstantObjectValue> tblConstantObjectValues { get; set; }
        public virtual DbSet<tblEmployee> tblEmployees { get; set; }
        public virtual DbSet<tblBank> tblBanks { get; set; }
        public virtual DbSet<tblBankBranch> tblBankBranches { get; set; }
        public virtual DbSet<tblBrokerBankAccount> tblBrokerBankAccounts { get; set; }
        public virtual DbSet<tblBrokerBranch> tblBrokerBranches { get; set; }
        public virtual DbSet<tblInvestor> tblInvestors { get; set; }
        public virtual DbSet<tblBrokerImage> tblBrokerImages { get; set; }
    
        public virtual ObjectResult<ssp_branches_by_user_id_Result> ssp_branches_by_user_id(string user_id, Nullable<decimal> membership_id)
        {
            var user_idParameter = user_id != null ?
                new ObjectParameter("user_id", user_id) :
                new ObjectParameter("user_id", typeof(string));
    
            var membership_idParameter = membership_id.HasValue ?
                new ObjectParameter("membership_id", membership_id) :
                new ObjectParameter("membership_id", typeof(decimal));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<ssp_branches_by_user_id_Result>("ssp_branches_by_user_id", user_idParameter, membership_idParameter);
        }
    
        public virtual ObjectResult<ssp_get_investor_info_Result2> ssp_get_investor_info(string investor_ids, Nullable<int> trader_id)
        {
            var investor_idsParameter = investor_ids != null ?
                new ObjectParameter("investor_ids", investor_ids) :
                new ObjectParameter("investor_ids", typeof(string));
    
            var trader_idParameter = trader_id.HasValue ?
                new ObjectParameter("trader_id", trader_id) :
                new ObjectParameter("trader_id", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<ssp_get_investor_info_Result2>("ssp_get_investor_info", investor_idsParameter, trader_idParameter);
        }
    }
}