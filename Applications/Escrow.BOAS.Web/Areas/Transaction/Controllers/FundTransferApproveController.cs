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
///Created date: 07/02/2016
///Reason: Fund Transfer Approve Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Transaction.Controllers
{
    public class FundTransferApproveController : Controller
    {
        // GET: Transaction/FundTransferApprove
        
        #region global variables

        private IGenericFactory<tblFundTransfer> fundTransferFactory;

        private IFundTransferFactory fndTransferFactory;

        #endregion

        public FundTransferApproveController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public FundTransferApproveController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Fund Transfer Approve view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult FndTransferApprove()
        {
            return View();
        }

        /// <summary>
        /// Get unapproved fund transfer approve list
        /// </summary>
        /// <param></param>
        /// <returns>fund transfer approve list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getFndTransferApproveList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var fndTransferApproveList = (dynamic)null;

                fndTransferFactory = new FundTransferFactory();

                fndTransferApproveList = fndTransferFactory.getFundTransferApproveList();

                var jsonResult = Json(new { fndTransferApproveList = fndTransferApproveList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// approve fund transfer
        /// </summary>
        /// <param name="selected">id of selected list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult approveFndTransfer(string[] selected)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundTransferFactory = new FundTransferFactory();

                tblFundTransfer obj = null;

                string transfer_id = "";

                decimal active_id = CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active");

                for (int i = 0; i < selected.Length; i++)
                {
                    obj = new tblFundTransfer();

                    decimal id = Convert.ToDecimal(selected[i]);

                    transfer_id = transfer_id + "," + id.ToString();

                    obj = fundTransferFactory.FindBy(a => a.id == id).FirstOrDefault();

                    if (obj.tblInvestor.active_status_id == active_id)
                    {
                        obj.approve_by = User.Identity.GetUserId();
                        obj.approve_date = DateTimeConfig.FullDateUKtoDateKey(SessionManger.LoggedInTime(Session).ToString("dd/MM/yyyy"));
                        obj.is_dirty = 1;

                        fundTransferFactory.Edit(obj);
                    }
                }

                decimal object_value_id = CommonUtility.getObjValByObjNameAndDisplayVal("FINANCIAL_LEDGER_TYPE", "TRANSFER IN OUT");

                fundTransferFactory.Save(transfer_id, object_value_id, membership_id, User.Identity.GetUserId());

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (fundTransferFactory != null)
            {
                fundTransferFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}