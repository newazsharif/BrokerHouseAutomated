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
///Created date: 27/8/2015
///Reason: Receive Approve Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Transaction.Controllers
{
    public class ReceiveApproveController : Controller
    {
        #region global variables

        private IGenericFactory<tblFundReceive> fundReceiveFactory;

        #endregion

        public ReceiveApproveController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ReceiveApproveController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        // GET: Transaction/ReceiveApprove
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Cash And Cheque Receive Approve view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult FundReceiveApprove()
        {
            return View();
        }

        /// <summary>
        /// Get unapproved cash and cheque receive list
        /// </summary>
        /// <param></param>
        /// <returns>cash and cheque receive list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getRecApproveList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundReceiveFactory = new FundReceiveFactory();
               

                var recApproveList = fundReceiveFactory.GetAll().Where(a => a.approve_by == null)
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
                        s.amount
                    })
                    .OrderBy(s => s.receive_dt)
                    .ToList();

                var jsonResult = Json(new { recApproveList = recApproveList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Update cash and cheque receive
        /// </summary>
        /// <param name="selected">id of selected list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult approveFundReceive(string [] selected)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundReceiveFactory = new FundReceiveFactory();

                tblFundReceive obj = null;

                string receive_id = "";

                decimal active_id = CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active");

                for (int i = 0; i < selected.Length; i++ )
                {
                    obj = new tblFundReceive();

                    decimal id = Convert.ToDecimal(selected[i]);

                    receive_id = receive_id + "," + id.ToString();

                    obj = fundReceiveFactory.FindBy(a => a.id == id).FirstOrDefault();

                    if (obj.tblInvestor.active_status_id == active_id)
                    {
                        obj.approve_by = User.Identity.GetUserId();
                        obj.approve_date = DateTimeConfig.FullDateUKtoDateKey(SessionManger.LoggedInTime(Session).ToString("dd/MM/yyyy"));
                        obj.is_dirty = 1;

                        fundReceiveFactory.Edit(obj);
                    }
                }

                decimal object_value_id = CommonUtility.getObjValByObjNameAndDisplayVal("FINANCIAL_LEDGER_TYPE", "Deposit");

                fundReceiveFactory.Save(receive_id, object_value_id, membership_id, User.Identity.GetUserId());

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