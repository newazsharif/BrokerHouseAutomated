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
///Created date: 7/9/2015
///Reason: Fund Withdrawal Request Approve Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Transaction.Controllers
{
    public class FundWithdrawalRequestApproveController : Controller
    {
        // GET: Transaction/FundWithdrawalRequestApprove

        #region global variables

        private IGenericFactory<tblFundWithdraw> fundPaymentFactory;

        private IGenericFactory<tblFundWithdrawalRequest> fndWithdrawalReqFactory;

        #endregion

        public FundWithdrawalRequestApproveController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public FundWithdrawalRequestApproveController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        private string getCurrentDateWiseVoucherNo()
        {
            DateTime MyDate = DateTime.Now;

            string Year = MyDate.Year.ToString();
            string Month = MyDate.Month.ToString().PadLeft(2, '0');
            string Day = MyDate.Day.ToString().PadLeft(2, '0');

            return Year + Month + Day;
        }

        /// <summary>
        /// get maximum voucher no
        /// </summary>
        /// <param></param>
        /// <returns>voucher_no or fail message</returns>
        //[Authorize]
        private string getMaxVoucherNo()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundPaymentFactory = new FundPaymentFactory();

                decimal id = fundPaymentFactory.GetAll().Any() ? fundPaymentFactory.GetAll().Max(a => a.id) : 0;

                string prev_voucher_no = "00000";
                if (id != 0)
                {
                    prev_voucher_no = fundPaymentFactory.GetAll().Where(a => a.id == id).Select(a => a.voucher_no).FirstOrDefault();
                }

                return prev_voucher_no;
            }
            catch (Exception ex)
            {
                return "fail";
            }
        }

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Fund Withdrawal Request Approve view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult FndWithdrawalReqApprove()
        {
            return View();
        }

        /// <summary>
        /// Get unapproved fund withdrawal request approve list
        /// </summary>
        /// <param></param>
        /// <returns>fund withdrawal request approve list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getWithdrawalReqApproveList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fndWithdrawalReqFactory = new FundWithdrawalRequestFactory();

                var withdrawalReqApproveList = fndWithdrawalReqFactory.GetAll().Where(a => a.approve_by == null && a.is_dirty == 1)
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

                var jsonResult = Json(new { withdrawalReqApproveList = withdrawalReqApproveList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// approve fund withdrawal request
        /// </summary>
        /// <param name="selected">id of selected list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult approveFndWithdrawalReq(string[] selected)
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
                        obj.approve_by = User.Identity.GetUserId();
                        obj.approve_date = DateTimeConfig.FullDateUKtoDateKey(SessionManger.LoggedInTime(Session).ToString("dd/MM/yyyy"));
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
            if (fundPaymentFactory != null)
            {
                fundPaymentFactory.Dispose();
            }
            if (fndWithdrawalReqFactory != null)
            {
                fndWithdrawalReqFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}