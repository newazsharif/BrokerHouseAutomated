﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class AccountingConnection : DbContext
    {
        public AccountingConnection()
            : base("name=AccountingConnection")
        {
        } 
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<tblBank> tblBanks { get; set; }
        public virtual DbSet<tblBankBranch> tblBankBranches { get; set; }
        public virtual DbSet<tblConstantObject> tblConstantObjects { get; set; }
        public virtual DbSet<tblConstantObjectValue> tblConstantObjectValues { get; set; }
    }
}