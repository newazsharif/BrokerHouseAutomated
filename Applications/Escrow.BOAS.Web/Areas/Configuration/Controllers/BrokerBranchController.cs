using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Escrow.BOAS.Web.Models;
using Escrow.BOAS.Configuration.Models;
using Escrow.BOAS.Configuration.Factories;
using Escrow.BOAS.Utility;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security.DataProtection;
using Escrow.Utility.Interfaces;


///=============================================================
///Created by: Asif
///Created date: 17/8/2015
///Reason: Broker Branch Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.Configuration.Controllers
{
    public class BrokerBranchController : Controller
    {
        #region global variables

        private IGenericFactory<tblBrokerBranch> brokerBranchFactory;

        #endregion

        public BrokerBranchController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public BrokerBranchController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region load dropdown

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

        // GET: Configuration/BrokerBranch
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Broker Branch List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult BrokerBranchList()
        {
            return View();
        }

        /// <summary>
        /// Get all broker branch
        /// </summary>
        /// <param></param>
        /// <returns>broker branch list in json or error message</returns>
        
        public JsonResult getBrokerBranchList()
        {
            try
            {
                brokerBranchFactory = new BrokerBranchFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var brokerBranches = brokerBranchFactory.GetAll()
                    .Select(a => new 
                    { 
                        a.id, 
                        a.name, 
                        a.address, 
                        a.contact_person, 
                        a.contact_no, 
                        a.email, 
                        regis_dt = a.DimDate.FullDateUK 
                    }).ToList();

                return Json(new { brokerBranches = brokerBranches, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Edit broker branch view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditBrokerBranch()
        {
            return View();
        }

        /// <summary>
        /// Get single broker branch by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>broker branch model in json or error message</returns>
        
        public JsonResult getBrokerBranchById(int id)
        {
            try
            {
                brokerBranchFactory = new BrokerBranchFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var brokerBranch = brokerBranchFactory.FindBy(b => b.id == id)
                    .Select(a => new 
                    { 
                        a.id, 
                        a.name, 
                        a.ipo_branch_code,
                        a.address, 
                        a.contact_person, 
                        a.contact_no, 
                        a.email, 
                        regis_dt = a.DimDate.FullDateUK, 
                        a.active_status_id 
                    }).FirstOrDefault();

                return Json(new { brokerBranch = brokerBranch, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Edit broker branch
        /// </summary>
        /// <param name="editBroker">broker branch model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult updateBrokerBranch(tblBrokerBranch editBroker)
        {
            try
            {
                brokerBranchFactory = new BrokerBranchFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblBrokerBranch obj = new tblBrokerBranch();
                obj = editBroker;
                if (editBroker.address != null && editBroker.address != "")
                    obj.address = editBroker.address.Trim();

                obj.membership_id = membership_id;
                obj.changed_user_id = User.Identity.GetUserId();
                obj.changed_date = DateTime.Now;
                obj.is_dirty = 1;


                brokerBranchFactory.Edit(obj);
                brokerBranchFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (brokerBranchFactory != null)
            {
                brokerBranchFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}