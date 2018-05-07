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
///Created date: 2/12/2015
///Reason: Fund Withdrawal Request Cancel Controller
///=============================================================
namespace Escrow.BOAS.Web.Areas.Transaction.Controllers
{
    public class FundWithdrawalRequestCancelController : Controller
    {
        // GET: Transaction/FundWithdrawalRequestCancel

        #region global variables

        private IGenericFactory<tblFundWithdrawalRequest> fndWithdrawalReqFactory;

        #endregion

        public FundWithdrawalRequestCancelController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public FundWithdrawalRequestCancelController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Fund Withdrawal Request Cancel view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult FndWithdrawalCancel()
        {
            return View();
        }

        /// <summary>
        /// Get approved fund withdrawal request cancel list
        /// </summary>
        /// <param></param>
        /// <returns>fund withdrawal request cancel list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getWithdrawalReqCancelList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                var withdrawalReqCancelList = fndWithdrawalReqFactory.GetAll().Where(a => a.approve_by != null && a.is_dirty == 1)
                    .Select(s => new
                    {
                        s.id,
                        request_dt = s.DimDate1.FullDateUK,
                        effective_dt = s.DimDate2.FullDateUK,
                        s.voucher_no,
                        branch = s.tblBrokerBranch.name,
                        s.client_id,
                        s.tblInvestor.bo_code,
                        s.tblInvestor.first_holder_name,
                        transaction_mode = s.tblConstantObjectValue.display_value,
                        //s.tblBankBranch.tblBank.bank_name,
                        bank_name = s.bank_branch_id != null ? ("Bank: " + s.tblBrokerBankAccount.tblBankBranch.tblBank.bank_name + ", Bank Branch: " + s.tblBrokerBankAccount.tblBankBranch.branch_name + ", Account No: " + s.tblBrokerBankAccount.account_no) : "",
                        cheque_dt = s.DimDate.FullDateUK,
                        s.cheque_no,
                        s.amount
                    })
                    .OrderBy(s => s.request_dt)
                    .ToList();

                var jsonResult = Json(new { withdrawalReqCancelList = withdrawalReqCancelList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// cancel fund withdrawal request
        /// </summary>
        /// <param name="selected">id of selected list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult cancelFndWithdrawalReq(string[] selected)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                tblFundWithdrawalRequest obj = null;

                string withdraw_request_id = "";

                decimal active_id = CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active");

                for (int i = 0; i < selected.Length; i++)
                {
                    obj = new tblFundWithdrawalRequest();

                    decimal id = Convert.ToDecimal(selected[i]);

                    withdraw_request_id = withdraw_request_id + "," + id.ToString();

                    obj = fndWithdrawalReqFactory.FindBy(a => a.id == id).FirstOrDefault();

                    if (obj.tblInvestor.active_status_id == active_id)
                    {
                        obj.approve_by = null;
                        obj.approve_date = null;
                        obj.is_dirty = 1;

                        fndWithdrawalReqFactory.Edit(obj);
                    }
                }

                decimal object_value_id = CommonUtility.getObjValByObjNameAndDisplayVal("FINANCIAL_LEDGER_TYPE", "Withdraw Request");

                fndWithdrawalReqFactory.Save(withdraw_request_id, object_value_id, membership_id, User.Identity.GetUserId());

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (fndWithdrawalReqFactory != null)
            {
                fndWithdrawalReqFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}