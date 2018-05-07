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
///Created date: 14/6/2015
///Reason: Constant Object Controller
///=============================================================

///=============================================================
///Edit by: Asif
///Edit date: 16/8/2015
///Reason: organising code
///=============================================================

///=============================================================
///Edit by: Asif
///Edit date: 17/8/2015
///Reason: organising code
///=============================================================


namespace Escrow.BOAS.Web.Areas.Configuration.Controllers
{
    public class ConstantObjectValueController : Controller
    {
        #region global variables

        private IGenericFactory<tblConstantObjectValue> constantObjectValueFactory;

        #endregion

        public ConstantObjectValueController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ConstantObjectValueController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        #region load dropdown

        /// <summary>
        /// Get all constant object
        /// </summary>
        /// <param></param>
        /// <returns>constant object list in json</returns>
        //[Authorize]
        public JsonResult getConstantObjectDdlList()
        {
            var constantObjects = DropDown.ddlConsObj();

            return Json(constantObjects, JsonRequestBehavior.AllowGet);
        }

        #endregion

        // GET: Configuration/ConstantObjectValue
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Constant object value List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult ConstantObjectValueList()
        {
            return View();
        }

        /// <summary>
        /// Get all constant object value
        /// </summary>
        /// <param></param>
        /// <returns>constant object value list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getConstantObjectValueList()
        {
            try
            {
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                constantObjectValueFactory = new ConstantObjectValueFactory();

                var constantObjectValues = constantObjectValueFactory.GetAll()
                    .Select(a => new 
                    { 
                        a.object_value_id, 
                        a.display_value, 
                        a.object_id, 
                        a.sorting_order, 
                        a.remarks, 
                        a.tblConstantObject.object_name 
                    }).OrderBy(a => new { a.object_name, a.sorting_order }).ToList();

                var jsonResult = Json(new { constantObjectValues = constantObjectValues, success = true }, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Add new constant object value view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult NewConstantObjectValue()
        {
            return View();
        }

        /// <summary>
        /// Add new constant object value
        /// </summary>
        /// <param name="constantObjectValue">constant object value model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult addConstantObjectValue(tblConstantObjectValue constantObjectValue)
        {
            try
            {
                constantObjectValueFactory = new ConstantObjectValueFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblConstantObjectValue obj = new tblConstantObjectValue();

                obj = constantObjectValueFactory.FindBy(a => a.object_id == constantObjectValue.object_id && a.display_value == constantObjectValue.display_value).FirstOrDefault();

                if (obj == null)
                {
                    if (constantObjectValue.is_default == 1)
                    {
                        tblConstantObjectValue tempObj = new tblConstantObjectValue();

                        tempObj = constantObjectValueFactory.FindBy(a => a.object_id == constantObjectValue.object_id && a.is_default == 1).FirstOrDefault();

                        if(tempObj != null)
                        {
                            tempObj.is_default = 0;

                            constantObjectValueFactory.Edit(tempObj);
                        }
                    }
                    obj = new tblConstantObjectValue();

                    obj = constantObjectValue;
                    if (constantObjectValue.remarks != null && constantObjectValue.remarks != "")
                        obj.remarks = constantObjectValue.remarks.Trim();

                    constantObjectValueFactory.Add(obj);
                    constantObjectValueFactory.Save();

                    return Json(new { success = true });
                }
                else
                {
                    return Json(new { success = false, errorMessage = "this object value of " + obj.tblConstantObject.object_name + " already exists!!!!" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Edit constant object value view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditConstantObjectValue()
        {
            return View();
        }

        /// <summary>
        /// Get single constant object value by object value id
        /// </summary>
        /// <param name="id">object_value_id</param>
        /// <returns>constant object value model in json or error message</returns>
        
        public JsonResult getDefaultValueByObjectId(int id)
        {
            try
            {
                constantObjectValueFactory = new ConstantObjectValueFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                string default_value = constantObjectValueFactory.FindBy(b => b.object_id == id && b.is_default == 1)
                    .Select(a => a.display_value).FirstOrDefault();

                if(default_value == null || string.IsNullOrEmpty(default_value))
                {
                    default_value = "Default: Not set yet";
                }
                else
                {
                    default_value = "Default: " + default_value;
                }

                return Json(new { default_value = default_value, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Get single constant object value by object value id
        /// </summary>
        /// <param name="id">object_value_id</param>
        /// <returns>constant object value model in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getConstantObjectValueById(int id)
        {
            try
            {
                constantObjectValueFactory = new ConstantObjectValueFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var constantObjectValue = constantObjectValueFactory.FindBy(b => b.object_value_id == id)
                    .Select(a => new 
                    { 
                        a.object_value_id, 
                        a.display_value, 
                        a.object_id, 
                        a.sorting_order, 
                        a.remarks,
                        a.is_default
                    }).FirstOrDefault();

                return Json(new { constantObjectValue = constantObjectValue, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Edit constant object value
        /// </summary>
        /// <param name="editConsObjVal">constant object value model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult updateConstantObjectValue(tblConstantObjectValue editConsObjVal)
        {
            try
            {
                constantObjectValueFactory = new ConstantObjectValueFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblConstantObjectValue obj = new tblConstantObjectValue();

                obj = constantObjectValueFactory.FindBy(a => a.object_id == editConsObjVal.object_id && a.display_value == editConsObjVal.display_value && a.object_value_id != editConsObjVal.object_value_id).FirstOrDefault();

                if (obj == null)
                {
                    if (editConsObjVal.is_default == 1)
                    {
                        tblConstantObjectValue tempObj = new tblConstantObjectValue();

                        tempObj = constantObjectValueFactory.FindBy(a => a.object_id == editConsObjVal.object_id && a.is_default == 1 && a.object_value_id != editConsObjVal.object_value_id).FirstOrDefault();

                        if (tempObj != null)
                        {
                            tempObj.is_default = 0;

                            constantObjectValueFactory.Edit(tempObj);
                        }
                    }
                    obj = new tblConstantObjectValue();

                    obj = editConsObjVal;
                    if (editConsObjVal.remarks != null && editConsObjVal.remarks != "")
                        obj.remarks = editConsObjVal.remarks.Trim();

                    constantObjectValueFactory.Edit(obj);
                    constantObjectValueFactory.Save();

                    return Json(new { success = true });
                }
                else
                {
                    return Json(new { success = false, errorMessage = "this object value of " + obj.tblConstantObject.object_name + " already exists!!!!" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Delete constant object value
        /// </summary>
        /// <param name="id">object_value_id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteConstantObjectValue(int object_value_id)
        {
            try
            {
                constantObjectValueFactory = new ConstantObjectValueFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblConstantObjectValue obj = new tblConstantObjectValue();
                obj = constantObjectValueFactory.FindBy(b => b.object_value_id == object_value_id).FirstOrDefault();

                constantObjectValueFactory.Delete(obj);
                constantObjectValueFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (constantObjectValueFactory != null)
            {
                constantObjectValueFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}