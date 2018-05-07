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
///Reason: Cheque Dishonor Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Transaction.Controllers
{
    public class ChequeDishonorController : Controller
    {
        #region global variables

        private IGenericFactory<tblFundReceive> fundReceiveFactory;

        #endregion
        
        public ChequeDishonorController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ChequeDishonorController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        // GET: Transaction/ChequeDishonor
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Cheque Dishonor view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult CheqDishonor()
        {
            return View();
        }

        /// <summary>
        /// Get cheque Dishonor list
        /// </summary>
        /// <param></param>
        /// <returns>approved and deposited but not cleared and dishonored receive list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getCheqDishonorList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundReceiveFactory = new FundReceiveFactory();

                var cheqDishonorList = fundReceiveFactory.GetAll().Where(a => a.approve_by != null && a.deposit_by != null && a.clear_by == null && a.dishonor_by == null && a.tblConstantObjectValue.display_value != "CS")
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
                        deposit_dt = s.DimDate3.FullDateUK,
                        s.amount
                    })
                    .OrderBy(s => s.receive_dt)
                    .ToList();

                var jsonResult = Json(new { cheqDishonorList = cheqDishonorList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Update Cheque Dishonor
        /// </summary>
        /// <param name="selected">id of selected list</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult dishonorCheque(string[] selected)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                fundReceiveFactory = new FundReceiveFactory();

                tblFundReceive obj = null;

                string receive_id = "";

                decimal active_id = CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active");

                for (int i = 0; i < selected.Length; i++)
                {
                    obj = new tblFundReceive();

                    decimal id = Convert.ToDecimal(selected[i]);

                    receive_id = receive_id + "," + id.ToString();

                    obj = fundReceiveFactory.FindBy(a => a.id == id).FirstOrDefault();

                    if (obj.tblInvestor.active_status_id == active_id)
                    {
                        obj.dishonor_by = User.Identity.GetUserId();
                        obj.dishonor_date = DateTimeConfig.FullDateUKtoDateKey(SessionManger.LoggedInTime(Session).ToString("dd/MM/yyyy"));
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