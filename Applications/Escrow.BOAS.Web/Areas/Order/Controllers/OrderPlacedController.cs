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
    public class OrderPlacedController : Controller
    {
        // GET: Order/OrderPlaced

        #region global variables

        private IGenericFactory<tblPlaceOrder> placeOrderFactory;

        private IPlaceOrderFactory iPlaceOrderFactory;

        #endregion

        public OrderPlacedController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public OrderPlacedController(UserManager<ApplicationUser> userManager)
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
        public ActionResult OrderPlacedList()
        {
            return View();
        }

        /// <summary>
        /// Get pending order list
        /// </summary>
        /// <param>pending order list in json or error message</param>
        /// <returns>view</returns>
        [CheckUserSessionAttribute]
        public JsonResult getOrderPlacedList()
        {
            string UserId = User.Identity.GetUserId();

            decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

            try
            {

                iPlaceOrderFactory = new PlaceOrderFactory();

                var orderPlacedList = iPlaceOrderFactory.getPlacedOrderById(UserId, membership_id);

                var jsonResult = Json(new { orderPlacedList = orderPlacedList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
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