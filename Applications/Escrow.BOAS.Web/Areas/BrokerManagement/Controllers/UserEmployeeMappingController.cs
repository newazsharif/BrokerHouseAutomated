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
using Escrow.Security.Models;
using Escrow.Security.Factories;
using System.Text;
using System.Data;


///=============================================================
///Created by: Asif
///Created date: 21/9/2015
///Reason: User Employee Mapping Controller
///=============================================================

namespace Escrow.BOAS.Web.Areas.BrokerManagement.Controllers
{
    public class UserEmployeeMappingController : Controller
    {
        // GET: BrokerManagement/UserEmployeeMapping

        #region global variables

        private IGenericFactory<tblEmployeeUserMapping> userEmployeeMappingFactory;

        private IGenericFactory<AspNetUser> userFactory;

        #endregion

        public UserEmployeeMappingController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public UserEmployeeMappingController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region load dropdown

        /// <summary>
        /// Get all user
        /// </summary>
        /// <param></param>
        /// <returns>user list in json</returns>
        //[Authorize]
        public JsonResult getUserDdlList()
        {
            var userList = DropDown.ddlUser();

            return Json(userList, JsonRequestBehavior.AllowGet);
        }

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
        /// User Employee Mapping List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult UserEmpMapList()
        {
            return View();
        }

        /// <summary>
        /// Get all user employee mapping
        /// </summary>
        /// <param></param>
        /// <returns>user employee mapping list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getUserEmpMapList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                userFactory = new UserFactory();

                List<AspNetUser> userList = userFactory.GetAll().ToList();

                userEmployeeMappingFactory = new UserEmployeeMappingFactory();

                var userEmpMapList = (from a in userEmployeeMappingFactory.GetAll().ToList()
                                      join b in userList on a.user_id equals b.Id
                                      select new
                                      {
                                          a.id,
                                          employee = a.tblEmployee.name,
                                          user = b.UserName
                                      }
                    ).ToList();

                var jsonResult = Json(new { userEmpMapList = userEmpMapList, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Add new user employee mapping view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult NewUserEmpMap()
        {
            return View();
        }

        /// <summary>
        /// Add new user employee mapping
        /// </summary>
        /// <param name="constantObjectValue">user employee mapping model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult addUserEmpMap(tblEmployeeUserMapping userEmpMap)
        {
            try
            {
                userEmployeeMappingFactory = new UserEmployeeMappingFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblEmployeeUserMapping obj = new tblEmployeeUserMapping();
                obj = userEmpMap;

                obj.membership_id = membership_id;
                obj.changed_user_id = User.Identity.GetUserId();
                obj.changed_date = DateTime.Now;
                obj.is_dirty = 1;

                userEmployeeMappingFactory.Add(obj);
                userEmployeeMappingFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Edit user employee mapping view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditUserEmpMap()
        {
            return View();
        }

        /// <summary>
        /// Get single user employee mapping by id
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>user employee mapping model in json or error message</returns>
        [CheckUserSessionAttribute]
        public JsonResult getUserEmpMapById(int id)
        {
            try
            {
                userEmployeeMappingFactory = new UserEmployeeMappingFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var editUserEmpMap = userEmployeeMappingFactory.FindBy(b => b.id == id)
                    .Select(a => new
                    {
                        a.id,
                        a.employee_id,
                        a.user_id,
                        a.active_status_id
                    }).FirstOrDefault();

                return Json(new { editUserEmpMap = editUserEmpMap, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Edit user employee mapping
        /// </summary>
        /// <param name="editTraderInformation">user employee mapping model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult updateUserEmpMap(tblEmployeeUserMapping editUserEmpMap)
        {
            try
            {
                userEmployeeMappingFactory = new UserEmployeeMappingFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblEmployeeUserMapping obj = new tblEmployeeUserMapping();
                obj = editUserEmpMap;

                obj.membership_id = membership_id;
                obj.changed_user_id = User.Identity.GetUserId();
                obj.changed_date = DateTime.Now;
                obj.is_dirty = 1;


                userEmployeeMappingFactory.Edit(obj);
                userEmployeeMappingFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Delete user employee mapping
        /// </summary>
        /// <param name="id">id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteUserEmpMap(int id)
        {
            try
            {
                userEmployeeMappingFactory = new UserEmployeeMappingFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var obj = userEmployeeMappingFactory.FindBy(b => b.id == id).FirstOrDefault();

                userEmployeeMappingFactory.Delete(obj);
                userEmployeeMappingFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (userEmployeeMappingFactory != null)
            {
                userEmployeeMappingFactory.Dispose();
            }

            if (userFactory != null)
            {
                userFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}