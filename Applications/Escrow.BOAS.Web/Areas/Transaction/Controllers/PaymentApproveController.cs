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
using Escrow.BOAS.Transaction.Interfaces;
using System.Configuration;


///=============================================================
///Created by: Asif
///Created date: 1/9/2015
///Reason: Payment Approve Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Transaction.Controllers
{
    public class PaymentApproveController : Controller
    {
        #region global variables

        private IGenericFactory<tblFundWithdraw> fundPaymentFactory;

        private IFundPaymentFactory fndPaymentFactory;

        #endregion

        public PaymentApproveController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public PaymentApproveController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        // GET: Transaction/PaymentApprove
        public ActionResult Index()
        {
            return View();
        }

        public JsonResult getBalanceCheckType()
        {
            string balance_check_type = ConfigManager.balance_check_type;

            if (balance_check_type != null)
            {
                return Json(new { success = true, balance_check_type = balance_check_type }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new { success = false, errorMessage = "Balance check type not set yet!!!!" }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Fund Payment Approve view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult FundPaymentApprove()
        {
            return View();
        }

        /// <summary>
        /// Get unapproved fund payment approve list
        /// </summary>
        /// <param></param>
        /// <returns>fund payment approve list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getPaymentApproveList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var paymentApproveList = (dynamic)null;

                fndPaymentFactory = new FundPaymentFactory();

                paymentApproveList = fndPaymentFactory.getFundPaymentApproveList();

                var jsonResult = Json(new { paymentApproveList = paymentApproveList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// approve fund payment
        /// </summary>
        /// <param name="selected">id of selected list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult approveFundPayment(string[] selected)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundPaymentFactory = new FundPaymentFactory();

                tblFundWithdraw obj = null;

                string payment_id = "";

                decimal active_id = CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active");

                string approvedId = "";
                for (int i = 0; i < selected.Length; i++)
                {
                    obj = new tblFundWithdraw();

                    decimal id = Convert.ToDecimal(selected[i]);
                    var already_approved = fundPaymentFactory.FindBy(a => a.id == id && a.approve_by != null).FirstOrDefault();
                    if (already_approved != null)
                    {
                        if (approvedId=="")
                        {
                        approvedId =  id.ToString();

                        }else{
                        approvedId = approvedId + "," + id.ToString();
                        }
                    }
                    else
                    {
                        payment_id = payment_id + "," + id.ToString();

                    }

                    if (payment_id == "" && i==selected.Length-1)
                    {
                        return Json(new { success = false, errorMessage = "Already Approved" });

                    }
                    obj = fundPaymentFactory.FindBy(a => a.id == id).FirstOrDefault();

                    if (obj.tblInvestor.active_status_id == active_id)
                    {
                        obj.approve_by = User.Identity.GetUserId();
                        obj.approve_date = DateTimeConfig.FullDateUKtoDateKey(SessionManger.LoggedInTime(Session).ToString("dd/MM/yyyy"));
                        obj.is_dirty = 1;

                        fundPaymentFactory.Edit(obj);
                    }
                }

                decimal object_value_id = CommonUtility.getObjValByObjNameAndDisplayVal("FINANCIAL_LEDGER_TYPE", "Withdraw");
                string data = "";
                fundPaymentFactory.Save(payment_id, object_value_id, membership_id, User.Identity.GetUserId());
                if (approvedId!="")
                {
                    data = approvedId + " Already Approved";
                }
                return Json(new { success = true, data = data });
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

            base.Dispose(disposing);
        }
    }
}