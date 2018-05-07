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
    
    public partial class DimDate
    {
        public DimDate()
        {
            this.tblBrokerBranches = new HashSet<tblBrokerBranch>();
            this.tblTraders = new HashSet<tblTrader>();
            this.tblAccountClosings = new HashSet<tblAccountClosing>();
            this.tblInvestors = new HashSet<tblInvestor>();
            this.tblInvestorFinancialLedgers = new HashSet<tblInvestorFinancialLedger>();
            this.tblInvestorFundBalances = new HashSet<tblInvestorFundBalance>();
            this.tblInvestorShareBalances = new HashSet<tblInvestorShareBalance>();
            this.tblInvestorShareLedgers = new HashSet<tblInvestorShareLedger>();
            this.tblNominees = new HashSet<tblNominee>();
            this.tblNominees1 = new HashSet<tblNominee>();
            this.tblPowerOfAtornees = new HashSet<tblPowerOfAtornee>();
            this.tblPowerOfAtornees1 = new HashSet<tblPowerOfAtornee>();
            this.tblPowerOfAtornees2 = new HashSet<tblPowerOfAtornee>();
            this.tblPowerOfAtornees3 = new HashSet<tblPowerOfAtornee>();
            this.tblIntroducers = new HashSet<tblIntroducer>();
            this.tblIntroducers1 = new HashSet<tblIntroducer>();
        }
    
        public decimal DateKey { get; set; }
        public Nullable<System.DateTime> Date { get; set; }
        public string FullDateUK { get; set; }
        public string FullDateUSA { get; set; }
        public string DayOfMonth { get; set; }
        public string DaySuffix { get; set; }
        public string DayName { get; set; }
        public string DayOfWeekUSA { get; set; }
        public string DayOfWeekUK { get; set; }
        public string DayOfWeekInMonth { get; set; }
        public string DayOfWeekInYear { get; set; }
        public string DayOfQuarter { get; set; }
        public string DayOfYear { get; set; }
        public string WeekOfMonth { get; set; }
        public string WeekOfQuarter { get; set; }
        public string WeekOfYear { get; set; }
        public string Month { get; set; }
        public string MonthName { get; set; }
        public string MonthOfQuarter { get; set; }
        public string Quarter { get; set; }
        public string QuarterName { get; set; }
        public string Year { get; set; }
        public string YearName { get; set; }
        public string MonthYear { get; set; }
        public string MMYYYY { get; set; }
        public Nullable<System.DateTime> FirstDayOfMonth { get; set; }
        public Nullable<System.DateTime> LastDayOfMonth { get; set; }
        public Nullable<System.DateTime> FirstDayOfQuarter { get; set; }
        public Nullable<System.DateTime> LastDayOfQuarter { get; set; }
        public Nullable<System.DateTime> FirstDayOfYear { get; set; }
        public Nullable<System.DateTime> LastDayOfYear { get; set; }
        public Nullable<bool> IsHolidayUSA { get; set; }
        public Nullable<bool> IsWeekday { get; set; }
        public string HolidayUSA { get; set; }
        public Nullable<bool> IsHolidayUK { get; set; }
        public string HolidayUK { get; set; }
        public Nullable<bool> IsHoliday { get; set; }
        public string Holiday { get; set; }
        public string FiscalDayOfYear { get; set; }
        public string FiscalWeekOfYear { get; set; }
        public string FiscalMonth { get; set; }
        public string FiscalQuarter { get; set; }
        public string FiscalQuarterName { get; set; }
        public string FiscalYear { get; set; }
        public string FiscalYearName { get; set; }
        public string FiscalMonthYear { get; set; }
        public string FiscalMMYYYY { get; set; }
        public Nullable<System.DateTime> FiscalFirstDayOfMonth { get; set; }
        public Nullable<System.DateTime> FiscalLastDayOfMonth { get; set; }
        public Nullable<System.DateTime> FiscalFirstDayOfQuarter { get; set; }
        public Nullable<System.DateTime> FiscalLastDayOfQuarter { get; set; }
        public Nullable<System.DateTime> FiscalFirstDayOfYear { get; set; }
        public Nullable<System.DateTime> FiscalLastDayOfYear { get; set; }
        public string FullDateCDBL { get; set; }
    
        public virtual ICollection<tblBrokerBranch> tblBrokerBranches { get; set; }
        public virtual ICollection<tblTrader> tblTraders { get; set; }
        public virtual ICollection<tblAccountClosing> tblAccountClosings { get; set; }
        public virtual tblDayProcess tblDayProcess { get; set; }
        public virtual ICollection<tblInvestor> tblInvestors { get; set; }
        public virtual ICollection<tblInvestorFinancialLedger> tblInvestorFinancialLedgers { get; set; }
        public virtual ICollection<tblInvestorFundBalance> tblInvestorFundBalances { get; set; }
        public virtual ICollection<tblInvestorShareBalance> tblInvestorShareBalances { get; set; }
        public virtual ICollection<tblInvestorShareLedger> tblInvestorShareLedgers { get; set; }
        public virtual ICollection<tblNominee> tblNominees { get; set; }
        public virtual ICollection<tblNominee> tblNominees1 { get; set; }
        public virtual ICollection<tblPowerOfAtornee> tblPowerOfAtornees { get; set; }
        public virtual ICollection<tblPowerOfAtornee> tblPowerOfAtornees1 { get; set; }
        public virtual ICollection<tblPowerOfAtornee> tblPowerOfAtornees2 { get; set; }
        public virtual ICollection<tblPowerOfAtornee> tblPowerOfAtornees3 { get; set; }
        public virtual ICollection<tblIntroducer> tblIntroducers { get; set; }
        public virtual ICollection<tblIntroducer> tblIntroducers1 { get; set; }
    }
}