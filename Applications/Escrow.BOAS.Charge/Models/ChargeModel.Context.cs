﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class ChargeEntities : DbContext
    {
        public ChargeEntities()
            : base("name=ChargeEntities")
        {
            this.Database.CommandTimeout = this.Database.Connection.ConnectionTimeout;
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<tblBranchCharge> tblBranchCharges { get; set; }
        public virtual DbSet<tblBranchChargeSlab> tblBranchChargeSlabs { get; set; }
        public virtual DbSet<tblGlobalCharge> tblGlobalCharges { get; set; }
        public virtual DbSet<tblGlobalChargeSlab> tblGlobalChargeSlabs { get; set; }
        public virtual DbSet<tblSubAccountCharge> tblSubAccountCharges { get; set; }
        public virtual DbSet<tblSubAccountChargeSlab> tblSubAccountChargeSlabs { get; set; }
        public virtual DbSet<DimDate> DimDates { get; set; }
        public virtual DbSet<tblInvestorCharge> tblInvestorCharges { get; set; }
        public virtual DbSet<tblInvestorChargeSlab> tblInvestorChargeSlabs { get; set; }
        public virtual DbSet<tblConstantObject> tblConstantObjects { get; set; }
        public virtual DbSet<tblConstantObjectValue> tblConstantObjectValues { get; set; }
        public virtual DbSet<tblBrokerBranch> tblBrokerBranches { get; set; }
        public virtual DbSet<tblExchangeCharge> tblExchangeCharges { get; set; }
        public virtual DbSet<tblExchangeChargeSlab> tblExchangeChargeSlabs { get; set; }
        public virtual DbSet<tblBranchAccountTypeSetting> tblBranchAccountTypeSettings { get; set; }
        public virtual DbSet<tblGlobalAccountTypeSetting> tblGlobalAccountTypeSettings { get; set; }
        public virtual DbSet<tblInvestorAccountTypeSetting> tblInvestorAccountTypeSettings { get; set; }
        public virtual DbSet<tblSubAccountAccountTypeSetting> tblSubAccountAccountTypeSettings { get; set; }
    }
}
