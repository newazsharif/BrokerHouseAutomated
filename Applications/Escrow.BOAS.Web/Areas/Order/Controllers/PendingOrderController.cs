using Escrow.BOAS.Service.Factories;
using Escrow.BOAS.Service.Interfaces;
using Escrow.BOAS.Service.Models;
using Escrow.BOAS.Utility;
using Escrow.BOAS.Web.Models;
using Escrow.Utility.Interfaces;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Escrow.BOAS.Web.Areas.Order.Controllers
{
    public class PendingOrderController : Controller
    {
        // GET: Order/PendingOrder

        #region global variables

        private IGenericFactory<tblPlaceOrder> placeOrderFactory;

        private IPlaceOrderFactory iPlaceOrderFactory;

        #endregion

        public PendingOrderController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public PendingOrderController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Pending Order view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        [CheckUserSessionAttribute]
        public ActionResult PendingOrderList()
        {
            return View();
        }

        /// <summary>
        /// Get pending order list
        /// </summary>
        /// <param>pending order list in json or error message</param>
        /// <returns>view</returns>
        [CheckUserSessionAttribute]
        public JsonResult getPendingOrderList()
        {
            string UserId = User.Identity.GetUserId();

            decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

            try
            {

                iPlaceOrderFactory = new PlaceOrderFactory();

                var pendingOrderList = iPlaceOrderFactory.getPendingOrderById(UserId, membership_id);

                var jsonResult = Json(new { pendingOrderList = pendingOrderList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Order Placed
        /// </summary>
        /// <param name="selected">id of selected list</param>
        /// <returns>success or error message</returns>
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult orderPlaced(string[] selected)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                placeOrderFactory = new PlaceOrderFactory();

                tblPlaceOrder obj = null;

                for (int i = 0; i < selected.Length; i++)
                {
                    obj = new tblPlaceOrder();

                    decimal id = Convert.ToDecimal(selected[i]);

                    obj = placeOrderFactory.FindBy(a => a.id == id).FirstOrDefault();

                    obj.approve_by = User.Identity.GetUserId();
                    obj.approve_date = DateTimeConfig.FullDateUKtoDateKey(SessionManger.LoggedInTime(Session).ToString("dd/MM/yyyy"));
                    obj.is_dirty = 1;

                    placeOrderFactory.Edit(obj);
                }

                placeOrderFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }


        [HttpPost]
        public JsonResult orderCancel(string[] selected)
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                placeOrderFactory = new PlaceOrderFactory();

                tblPlaceOrder obj = null;

                for (int i = 0; i < selected.Length; i++)
                {
                    obj = new tblPlaceOrder();

                    decimal id = Convert.ToDecimal(selected[i]);

                    obj = placeOrderFactory.FindBy(a => a.id == id).FirstOrDefault();

                    obj.cancel_by = User.Identity.GetUserId();
                    obj.cancel_date = DateTimeConfig.FullDateUKtoDateKey(SessionManger.LoggedInTime(Session).ToString("dd/MM/yyyy"));
                    obj.is_dirty = 1;

                    placeOrderFactory.Edit(obj);
                }

                placeOrderFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (placeOrderFactory != null)
            {
                placeOrderFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}