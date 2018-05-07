using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Escrow.BOAS.Web.Models;
using Escrow.BOAS.Transaction.Models;
using Escrow.BOAS.Transaction.Factories;
using Escrow.BOAS.Utility;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;


///=============================================================
///Created by: Asif
///Created date: 30/8/2015
///Reason: Cheque Deposit to Bank Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Transaction.Controllers
{
    public class ChequeDepositToBankController : Controller
    {

        #region global variables

        private IGenericFactory<tblFundReceive> fundReceiveFactory;

        #endregion
        
        public ChequeDepositToBankController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ChequeDepositToBankController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        // GET: Transaction/ChequeDepositToBank

        #region load dropdown

        /// <summary>
        /// Get all broker bank account
        /// </summary>
        /// <param></param>
        /// <returns>broker bank account list in json</returns>
        //[Authorize]
        public JsonResult getBrokerBankAccountDdlList()
        {
            decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

            var brokerBankAccountList = DropDown.ddlBrokerBankAccount(membership_id);

            return Json(brokerBankAccountList, JsonRequestBehavior.AllowGet);
        }

        #endregion
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Cheque Deposit to Bank view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult CheqDepositToBank()
        {
            return View();
        }

        /// <summary>
        /// Get approved but not deposited to bank list
        /// </summary>
        /// <param></param>
        /// <returns>approved but not deposited to bank list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getCheqDepositToBankList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundReceiveFactory = new FundReceiveFactory();

                var cheqDepositToBankList = fundReceiveFactory.GetAll().Where(a => a.approve_by != null && a.deposit_by == null && a.tblConstantObjectValue.display_value != "CS")
                    .Select(s => new
                    {
                        s.id,
                        receive_dt = s.DimDate.FullDateUK,
                        s.voucher_no,
                        branch = s.tblBrokerBranch.name,
                        s.client_id,
                        s.tblInvestor.bo_code,
                        s.tblInvestor.first_holder_name,
                        transaction_mode = s.tblConstantObjectValue.display_value,
                        s.tblBank.bank_name,
                        cheque_dt = s.DimDate6.FullDateUK,
                        s.cheque_no,
                        approve_dt = s.DimDate2.FullDateUK,
                        s.amount
                    })
                    .OrderBy(s => s.receive_dt)
                    .ToList();

                var jsonResult = Json(new { cheqDepositToBankList = cheqDepositToBankList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Update Cheque Deposit to Bank
        /// </summary>
        /// <param name="selected">id of selected list</param>
        /// <param name="deposit_bank_id">deposit bank id</param>
        /// <param name="deposit_bank_branch_id">deposit bank branch id</param>
        /// <param name="deposit_bank_account_no">deposit bank account no</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult depositToBank(string[] selected, decimal deposit_bank_branch_id)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundReceiveFactory = new FundReceiveFactory();

                tblFundReceive obj = null;

                decimal active_id = CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active");

                for (int i = 0; i < selected.Length; i++)
                {
                    obj = new tblFundReceive();

                    decimal id = Convert.ToDecimal(selected[i]);

                    obj = fundReceiveFactory.FindBy(a => a.id == id).FirstOrDefault();

                    if (obj.tblInvestor.active_status_id == active_id)
                    {
                        obj.deposit_bank_branch_id = deposit_bank_branch_id;

                        obj.deposit_by = User.Identity.GetUserId();
                        obj.deposit_date = DateTimeConfig.FullDateUKtoDateKey(SessionManger.LoggedInTime(Session).ToString("dd/MM/yyyy"));
                        obj.is_dirty = 1;

                        fundReceiveFactory.Edit(obj);
                    }
                }

                fundReceiveFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (fundReceiveFactory != null)
            {
                fundReceiveFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}