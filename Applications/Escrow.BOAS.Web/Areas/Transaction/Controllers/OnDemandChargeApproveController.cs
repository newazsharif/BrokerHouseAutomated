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
using Escrow.BOAS.Transaction.Interfaces;
using Escrow.BOAS.Utility;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;


///=============================================================
///Created by: Asif
///Created date: 19/9/2015
///Reason: On Demand Charge Approve Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Transaction.Controllers
{
    public class OnDemandChargeApproveController : Controller
    {
        // GET: Transaction/OnDemandChargeApprove
        
        #region global variables

        private IForceChargeApplyFactory forceChargeApplyFactory;

        #endregion

        public OnDemandChargeApproveController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public OnDemandChargeApproveController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// On Demand Charge Approve view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult OnDemCharApprove()
        {
            return View();
        }

        /// <summary>
        /// Get unapproved on demand charge list
        /// </summary>
        /// <param></param>
        /// <returns>on demand charge approve list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getOnDemCharApproveList()
        {
            try
            {
                forceChargeApplyFactory = new ForceChargeApplyFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var onDemCharApproveList = forceChargeApplyFactory.getOnDemandApproveList();

                var jsonResult = Json(new { onDemCharApproveList = onDemCharApproveList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// approve on demand charge
        /// </summary>
        /// <param name="selected">id of selected list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult approveOnDemChar(string transaction_dates, string charge_ids, string transaction_type_ids)
        {
            try
            {
                forceChargeApplyFactory = new ForceChargeApplyFactory();

                decimal object_value_id = CommonUtility.getObjValByObjNameAndDisplayVal("FINANCIAL_LEDGER_TYPE", "Charge Apply");

                forceChargeApplyFactory.approveOnDemCharge(transaction_dates, charge_ids, transaction_type_ids, DateTimeConfig.FullDateUKtoDateKey(SessionManger.LoggedInTime(Session).ToString("dd/MM/yyyy")), User.Identity.GetUserId(), object_value_id, SessionManger.BrokerOfLoggedInUser(Session).membership_id);

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (forceChargeApplyFactory != null)
            {
                forceChargeApplyFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}