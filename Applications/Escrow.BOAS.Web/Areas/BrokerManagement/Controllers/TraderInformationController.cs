using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Escrow.BOAS.Web.Models;
using Escrow.BOAS.BrokerManagement.Models;
using Escrow.BOAS.BrokerManagement.Factories;
using Escrow.BOAS.Utility;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;


///=============================================================
///Created by: Asif
///Created date: 20/9/2015
///Reason: Trader Information Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.BrokerManagement.Controllers
{
    public class TraderInformationController : Controller
    {
        // GET: BrokerManagement/TraderInformation

        #region global variables

        private IGenericFactory<tblTrader> traderFactory;

        #endregion

        public TraderInformationController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public TraderInformationController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region load dropdown

        /// <summary>
        /// Get all employee
        /// </summary>
        /// <param></param>
        /// <returns>employee list in json</returns>
        //[Authorize]
        public JsonResult getEmployeeDdlList()
        {
            var employeeList = DropDown.ddlEmployee();

            return Json(employeeList, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Get all broker branch
        /// </summary>
        /// <param></param>
        /// <returns>broker branch list in json</returns>
        //[Authorize]
        public JsonResult getBranchDdlList()
        {
            decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

            string user_id = User.Identity.GetUserId();

            var branchList = DropDown.ddlBrokerBranch(user_id, membership_id);

            return Json(branchList, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Get all active status
        /// </summary>
        /// <param></param>
        /// <returns>active status list in json</returns>
        //[Authorize]
        public JsonResult getActiveStatusDdlList()
        {
            var activeStatusList = DropDown.ddlActiveStatus();

            return Json(activeStatusList, JsonRequestBehavior.AllowGet);
        }

        #endregion

        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Trader Information List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult TraderInformationList()
        {
            return View();
        }

        /// <summary>
        /// Get all trader
        /// </summary>
        /// <param></param>
        /// <returns>trader list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getTraderList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                traderFactory = new TraderFactory();

                var traderList = traderFactory.GetAll()
                    .Select(s => new
                    {
                        s.id,
                        s.trader_code,
                        employee = s.tblEmployee.name,
                        s.ar_no,
                        s.trade_work_station,
                        license_renew_date = s.DimDate.FullDateUK
                    }).ToList();

                var jsonResult = Json(new { traderList = traderList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Add new trader view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult NewTrdaerInformation()
        {
            return View();
        }

        /// <summary>
        /// Add new trader value
        /// </summary>
        /// <param name="constantObjectValue">trader model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult addTraderInformation(tblTrader tradaerInformation)
        {
            try
            {
                traderFactory = new TraderFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblTrader obj = new tblTrader();
                obj = tradaerInformation;

                obj.membership_id = membership_id;
                obj.changed_user_id = User.Identity.GetUserId();
                obj.changed_date = DateTime.Now;
                obj.is_dirty = 1;
                traderFactory.Add(obj);
                traderFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Edit trader view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditTraderInformation()
        {
            return View();
        }

        /// <summary>
        /// Get single trader by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>trader model in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getTraderById(int id)
        {
            try
            {
                traderFactory = new TraderFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var editTraderInformation = traderFactory.FindBy(b => b.id == id)
                    .Select(a => new
                    {
                        a.id,
                        a.trader_code,
                        a.employee_id,
                        a.ar_no,
                        a.trade_work_station,
                        license_renew_date = a.DimDate.FullDateUK,
                        a.active_status_id,
                        a.branch_id,
                        a.Is_Default,
                        a.investor_range
                    }).FirstOrDefault();

                return Json(new { editTraderInformation = editTraderInformation, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Edit trader
        /// </summary>
        /// <param name="editTraderInformation">trader model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult updateTraderInformation(tblTrader editTraderInformation)
        {
            try
            {
                traderFactory = new TraderFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblTrader obj = new tblTrader();
                obj = editTraderInformation;

                obj.membership_id = membership_id;
                obj.changed_user_id = User.Identity.GetUserId();
                obj.changed_date = DateTime.Now;
                obj.is_dirty = 1;


                traderFactory.Edit(obj);
                traderFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Delete trader
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteTrader(int id)
        {
            try
            {
                traderFactory = new TraderFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var obj = traderFactory.FindBy(b => b.id == id).FirstOrDefault();

                traderFactory.Delete(obj);
                traderFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (traderFactory != null)
            {
                traderFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}