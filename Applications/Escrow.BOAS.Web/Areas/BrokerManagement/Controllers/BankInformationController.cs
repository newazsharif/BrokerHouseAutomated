using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Escrow.BOAS.Web.Models;
using Escrow.BOAS.BrokerManagement.Models;
using Escrow.BOAS.BrokerManagement.Factories;
using Escrow.BOAS.Utility;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;
using System.Data.Entity;
using Escrow.BOAS.Configuration.Factories;
///=============================================================
///Created by: Rifad
///Created date: 6/5/2017
///Reason: Bank list, add, edit, delete, Branch list add new, Update, Delete
///=============================================================
namespace Escrow.BOAS.Web.Areas.BrokerManagement.Controllers
{
    public class BankInformationController : Controller
    {

        // GET: BrokerManagement/BankInformation
        private static IGenericFactory<Escrow.BOAS.AccountingManagement.Models.tblBank> bankFactory;
        private static IGenericFactory<Escrow.BOAS.AccountingManagement.Models.tblBankBranch> branchFactory;

        // private IGenericFactory
        public ActionResult BankList()
        {
            return View();
        }
        public JsonResult getBankList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                bankFactory = new Escrow.BOAS.AccountingManagement.Factories.BankFactory();

                var bankList = bankFactory.GetAll()
                    .Select(s => new
                    {
                        id = s.id,
                        short_name = s.short_name,
                        bank_name = s.bank_name
                    }).ToList();

                return Json(new { success = true, data = bankList }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult NewBankInformation()
        {
            return View();
        }
        public JsonResult AddNewBank(Escrow.BOAS.AccountingManagement.Models.tblBank bankInformation)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                bankFactory = new Escrow.BOAS.AccountingManagement.Factories.BankFactory();
                Escrow.BOAS.AccountingManagement.Models.tblBank bankTableObj = new Escrow.BOAS.AccountingManagement.Models.tblBank();
                bankTableObj = bankFactory.FindBy(a => a.short_name == bankInformation.short_name && a.bank_name == bankInformation.bank_name).FirstOrDefault();

                if (bankTableObj == null)
                {

                    bankInformation.membership_id = membership_id;
                    bankInformation.changed_user_id = User.Identity.GetUserId();
                    bankInformation.changed_date = DateTime.Now;
                    bankFactory.Add(bankInformation);
                    bankFactory.Save();

                    return Json(new { success = true, data = "Successfully Submited" }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { success = false, errorMessage = "Bank already exists!!!!" }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult GetStatus()
        {
            var data = DropDown.ddlActiveStatus();
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        public ActionResult editBankInfomation(Escrow.BOAS.AccountingManagement.Models.tblBank bankInformation)
        {
            return View();
        }
        public JsonResult GetBankById(int id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                bankFactory = new Escrow.BOAS.AccountingManagement.Factories.BankFactory();
                var bankList = bankFactory.GetAll().AsEnumerable().Where(x => x.id == id)
                    .Select(s => new
                    {
                        id = s.id,
                        short_name = s.short_name,
                        bank_name = s.bank_name,
                        active_status_id = s.active_status_id
                    }).FirstOrDefault();

                return Json(new { success = true, data = bankList }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult UpdateBank(Escrow.BOAS.AccountingManagement.Models.tblBank bankInformation)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                bankFactory = new Escrow.BOAS.AccountingManagement.Factories.BankFactory();
                Escrow.BOAS.AccountingManagement.Models.tblBank bankTableObj = new Escrow.BOAS.AccountingManagement.Models.tblBank();
                bankTableObj = bankFactory.FindBy(a => a.short_name == bankInformation.short_name && a.bank_name == bankInformation.bank_name).FirstOrDefault();
                //bankTableObj = bankFactory.FindBy(a => a.short_name == bankInformation.short_name && a.bank_name == bankInformation.bank_name).FirstOrDefault();

                if (bankTableObj == null)
                {

                    bankInformation.membership_id = membership_id;
                    bankInformation.changed_user_id = User.Identity.GetUserId();
                    bankInformation.changed_date = DateTime.Now;
                    bankFactory.Edit(bankInformation);
                    bankFactory.Save();
                    return Json(new { success = true, data = "Update Successfully" }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { success = false, errorMessage = "Bank already exists!!!!" }, JsonRequestBehavior.AllowGet);
                }

            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult DeleteBank(Escrow.BOAS.AccountingManagement.Models.tblBank bankInformation)
        {
            try
            {
                bankFactory = new Escrow.BOAS.AccountingManagement.Factories.BankFactory();
                var bank = bankFactory.GetById(bankInformation.id);
                bankFactory.Delete(bank);
                bankFactory.Save();
                return Json(new { message = "Successfully Deleted", success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        public ActionResult BranchList()
        {
            return View();
        }
        public JsonResult GetBranchByBankId(int id)
        {
            try
            {
                branchFactory = new Escrow.BOAS.AccountingManagement.Factories.BankBranchFactory();
                var branchList = branchFactory.GetAll().AsEnumerable().Where(a => a.bank_id == id)
                    .Select(b => new
                    {
                        id = b.id,
                        bank_id = b.bank_id,
                        branch_name = b.branch_name,
                        address = b.address,
                        email_address = b.email_address,
                        contact_person = b.contact_person,
                        contact_number = b.contact_number,
                        district_name = b.tblConstantObjectValue.display_value,
                        routing_no = b.routing_no
                    }).ToList();
                return Json(new { success = true, data = branchList }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult DistrictName()
        {
            var data = DropDown.ddlDistrict();

            return Json(data, JsonRequestBehavior.AllowGet);
        }

          public ActionResult editBranchInfomation(Escrow.BOAS.AccountingManagement.Models.tblBankBranch branchInformation)
        {
            return View();
        }
          public JsonResult GetBranchById(int id)
          {
              try
              {
                  decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                  branchFactory = new Escrow.BOAS.AccountingManagement.Factories.BankBranchFactory();
                  var branchList = branchFactory.GetAll().AsEnumerable().Where(x => x.id == id)
                      .Select(b => new
                      {
                          id = b.id,
                          bank_id = b.bank_id,
                          branch_name = b.branch_name,
                          address = b.address,
                          email_address = b.email_address,
                          contact_person = b.contact_person,
                          contact_number = b.contact_number,
                          routing_no = b.routing_no,
                          active_status_id = b.active_status_id,
                          district_id = b.district_id
                      }).FirstOrDefault();

                  return Json(new { success = true, data = branchList }, JsonRequestBehavior.AllowGet);
              }
              catch (Exception ex)
              {
                  return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
              }
          }
          public JsonResult UpdateBranch(Escrow.BOAS.AccountingManagement.Models.tblBankBranch branchInformation)
          {
              try
              {
                  decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                  branchFactory = new Escrow.BOAS.AccountingManagement.Factories.BankBranchFactory();
                  Escrow.BOAS.AccountingManagement.Models.tblBankBranch branchTableObj = new Escrow.BOAS.AccountingManagement.Models.tblBankBranch();
                  branchTableObj = branchFactory.FindBy(a => a.branch_name == branchInformation.branch_name && a.routing_no == branchInformation.routing_no && a.district_id == branchInformation.district_id).FirstOrDefault();
                  if (branchTableObj == null)
                  {
                      branchInformation.membership_id = membership_id;
                      branchInformation.changed_user_id = User.Identity.GetUserId();
                      branchInformation.changed_date = DateTime.Now;
                      branchFactory.Edit(branchInformation);
                      branchFactory.Save();
                      return Json(new { success = true, data = "Update Successfully" }, JsonRequestBehavior.AllowGet);
                  }
                  else
                  {
                      return Json(new { success = false, errorMessage = "Branch already exists!!!!" }, JsonRequestBehavior.AllowGet);
                  }

              }
              catch (Exception ex)
              {
                  return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
              }
          }
          public JsonResult DeleteBranch(Escrow.BOAS.AccountingManagement.Models.tblBankBranch branchInformation)
          {
              try
              {
                  branchFactory = new Escrow.BOAS.AccountingManagement.Factories.BankBranchFactory();
                  var branch = branchFactory.GetById(branchInformation.id);
                  branchFactory.Delete(branch);
                  branchFactory.Save();
                  return Json(new { message = "Successfully Deleted", success = true }, JsonRequestBehavior.AllowGet);
              }
              catch (Exception ex)
              {
                  return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
              }
          }
          public ActionResult AddBranch()
          {
              return View();
          }
          public JsonResult AddNewBranch(Escrow.BOAS.AccountingManagement.Models.tblBankBranch branchInformation)
          {
              try
              {
                  decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                  branchFactory = new Escrow.BOAS.AccountingManagement.Factories.BankBranchFactory();
                  Escrow.BOAS.AccountingManagement.Models.tblBankBranch branchTableObj = new Escrow.BOAS.AccountingManagement.Models.tblBankBranch();
                  branchTableObj = branchFactory.FindBy(a =>a.email_address==branchInformation.email_address&& a.address==branchInformation.address&&a.routing_no==branchInformation.routing_no && a.branch_name == branchInformation.branch_name && a.routing_no == branchInformation.routing_no && a.district_id == branchInformation.district_id).FirstOrDefault();

                  if (branchTableObj == null)
                  {

                      branchInformation.membership_id = membership_id;
                      branchInformation.changed_user_id = User.Identity.GetUserId();
                      branchInformation.changed_date = DateTime.Now;
                      branchFactory.Add(branchInformation);
                      branchFactory.Save();

                      return Json(new { success = true, data = "Successfully Submited" }, JsonRequestBehavior.AllowGet);
                  }
                  else
                  {
                      return Json(new { success = false, errorMessage = "Branch already exists!!!!" }, JsonRequestBehavior.AllowGet);
                  }
              }
              catch (Exception ex)
              {
                  return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
              }
          }      
    }
}