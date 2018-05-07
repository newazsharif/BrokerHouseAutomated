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
using Escrow.BOAS.InstrumentManagement.Models;
using Escrow.BOAS.InstrumentManagement.Factories;

///=============================================================
///Created by: Shohid
///Created date: 07/02/2016
///Reason: Instrument Receive Delivery Approve Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Instrument.Controllers
{
    public class InstrumentReceiveDeliveryApproveController : Controller
    {

        // GET: Instrument/InstrumentReceiveDeliveryApprove
        #region global variables
        private IGenericFactory<tblInstrumentManualInOut> instrumentReceiveDeliveryFactory;
        #endregion


        public InstrumentReceiveDeliveryApproveController():
            this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {
          
        }

        public InstrumentReceiveDeliveryApproveController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; set; }

        public ActionResult Index()
        {
            return View();
        }


        /// <summary>
        /// Instrument Receive Delivery Approve view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        [CheckUserSessionAttribute]
        public ActionResult InstrumentReceiveDeliveryApprove()
        {
            return View();
        }


        /// <summary>
        /// Get unapproved Instrument Receive Delivery approve list
        /// </summary>
        /// <param></param>
        /// <returns>fund transfer approve list in json or error message</returns>
       // [CheckUserSessionAttribute]
        public JsonResult getInstrumentReceiveDeliveryApproveList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                instrumentReceiveDeliveryFactory = new InstrumentReceiveDeliveryFactory();

                var insRecDelApproveList = instrumentReceiveDeliveryFactory.GetAll().Where(a => a.approve_by == null).
                    Select(a => new
                    {
                        a.id,
                        a.client_id,
                        a.quantity,
                        a.rate,
                        instrument_name = a.tblInstrument.security_code,
                        transection_type = a.tblConstantObjectValue.display_value,
                        transection_date = a.DimDate.FullDateUK
                    });
                return Json(new { insRecDelApproveList = insRecDelApproveList, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// approveed Instrument Receive Delivery
        /// </summary>
        /// <param name="selected">id of selected list</param>
        /// <returns>success or error message</returns>
       // [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult approveInstrumentReceiveDelivery(string[] selected)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                instrumentReceiveDeliveryFactory = new InstrumentReceiveDeliveryFactory();

                tblInstrumentManualInOut obj = null;

                string transfer_id = "";

                decimal active_id = CommonUtility.getObjValByObjNameAndDisplayVal("ACTIVE_STATUS", "Active");

                for (int i = 0; i < selected.Length; i++)
                {
                    obj = new tblInstrumentManualInOut();

                    decimal id = Convert.ToDecimal(selected[i]);

                    transfer_id = transfer_id + "," + id.ToString();

                    obj = instrumentReceiveDeliveryFactory.FindBy(a => a.id == id).FirstOrDefault();


                    if (obj.tblInstrument.active_status_id == active_id)
                    {
                        obj.approve_by = User.Identity.GetUserId();
                        obj.approve_date = DateTimeConfig.FullDateUKtoDateKey(SessionManger.LoggedInTime(Session).ToString("dd/MM/yyyy"));
                        obj.is_dirty = 1;

                        instrumentReceiveDeliveryFactory.Edit(obj);
                    }
                }

                decimal object_value_id = CommonUtility.getObjValByObjNameAndDisplayVal("SHARE_LEDGER_TYPE", "MANUAL IN/OUT");

                instrumentReceiveDeliveryFactory.Save(transfer_id, object_value_id, membership_id, User.Identity.GetUserId());

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (instrumentReceiveDeliveryFactory != null)
            {
                instrumentReceiveDeliveryFactory.Dispose();
            }

            base.Dispose(disposing);
        }

    }
}