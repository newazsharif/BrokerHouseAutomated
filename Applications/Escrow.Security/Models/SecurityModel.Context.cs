﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class SecurityConnection : DbContext
    {
        public SecurityConnection()
            : base("name=SecurityConnection")
        {
            this.Database.CommandTimeout = this.Database.Connection.ConnectionTimeout;
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<tblModule> tblModules { get; set; }
        public virtual DbSet<tblView> tblViews { get; set; }
        public virtual DbSet<tblBrokerModuleMapping> tblBrokerModuleMappings { get; set; }
        public virtual DbSet<tblController> tblControllers { get; set; }
        public virtual DbSet<tblUIModule> tblUIModules { get; set; }
        public virtual DbSet<tblAction> tblActions { get; set; }
        public virtual DbSet<tblUserActionMapping> tblUserActionMappings { get; set; }
        public virtual DbSet<AspNetUser> AspNetUsers { get; set; }
        public virtual DbSet<tblBrokerInformation> tblBrokerInformations { get; set; }
        public virtual DbSet<tblBrokerUser> tblBrokerUsers { get; set; }
        public virtual DbSet<tblBrokerUserModule> tblBrokerUserModules { get; set; }
    }
}
