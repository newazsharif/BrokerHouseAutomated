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
    public class ConstantObjectController : Controller
    {
        #region global variables

        private IGenericFactory<tblConstantObject> constantObjectFactory;
        private IGenericFactory<tblConstantObjectValue> constantObjectValueFactory;

        #endregion

        public ConstantObjectController()
            : this(new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext())))
        {

        }

        public ConstantObjectController(UserManager<ApplicationUser> userManager)
        {
            UserManager = userManager;
        }

        public UserManager<ApplicationUser> UserManager { get; private set; }

        // GET: Configuration/ConstantObject
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Constant object List view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult ConstantObjectList()
        {
            return View();
        }

        /// <summary>
        /// Get all constant object
        /// </summary>
        /// <param></param>
        /// <returns>constant object list in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getConstantObjectList()
        {
            try
            {
                constantObjectFactory = new ConstantObjectFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var constantObjects = constantObjectFactory.GetAll()
                    .Select(a => new 
                    { 
                        a.object_id, 
                        a.object_name, 
                        a.Purpose 
                    }).ToList();

                return Json(new { constantObjects = constantObjects, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Add new constant object view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult NewConstantObject()
        {
            return View();
        }

        /// <summary>
        /// Add new constant object
        /// </summary>
        /// <param name="constantObject">constant object model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult addConstantObject(tblConstantObject constantObject)
        {
            try
            {
                constantObjectFactory = new ConstantObjectFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblConstantObject obj = new tblConstantObject();

                obj = constantObjectFactory.FindBy(a => a.object_name == constantObject.object_name).FirstOrDefault();

                if (obj == null)
                {
                    constantObjectFactory = new ConstantObjectFactory();
                    obj = new tblConstantObject();
                    obj = constantObject;
                    if (constantObject.Purpose != null && constantObject.Purpose != "")
                        obj.Purpose = constantObject.Purpose.Trim();

                    constantObjectFactory.Add(obj);
                    constantObjectFactory.Save();

                    return Json(new { success = true });
                }
                else
                {
                    return Json(new { success = false, errorMessage = "This constant object already exist!!!!" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Edit constant object view
        /// </summary>
        /// <param></param>
        /// <returns>view</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public ActionResult EditConstantObject()
        {
            return View();
        }

        /// <summary>
        /// Get single constant object by object id
        /// </summary>
        /// <param name="id">object_id</param>
        /// <returns>constant object model in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getConstantObjectById(int id)
        {
            try
            {
                constantObjectFactory = new ConstantObjectFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var constantObject = constantObjectFactory.FindBy(b => b.object_id == id)
                    .Select(a => new 
                    { 
                        a.object_id, 
                        a.object_name, 
                        a.Purpose 
                    }).FirstOrDefault(); 

                return Json(new { constantObject = constantObject, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Edit constant object
        /// </summary>
        /// <param name="editConsObject">constant object model</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult updateConstantObject(tblConstantObject editConsObject)
        {
            try
            {
                constantObjectFactory = new ConstantObjectFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                tblConstantObject obj = new tblConstantObject();

                obj = constantObjectFactory.FindBy(a => a.object_name == editConsObject.object_name && a.object_id != editConsObject.object_id).FirstOrDefault();

                if (obj == null)
                {
                    constantObjectFactory = new ConstantObjectFactory();
                    obj = new tblConstantObject();
                    obj = editConsObject;
                    if (editConsObject.Purpose != null && editConsObject.Purpose != "")
                        obj.Purpose = editConsObject.Purpose.Trim();

                    constantObjectFactory.Edit(obj);
                    constantObjectFactory.Save();

                    return Json(new { success = true });
                }
                else
                {
                    return Json(new { success = false, errorMessage = "This constant object already exist!!!!" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Delete constant object
        /// </summary>
        /// <param name="id">object_id</param>
        /// <returns>success or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        [HttpPost]
        public JsonResult deleteConstantObject(int object_id)
        {
            try
            {
                constantObjectFactory = new ConstantObjectFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var obj = constantObjectFactory.FindBy(b => b.object_id == object_id).FirstOrDefault();

                constantObjectFactory.Delete(obj);
                constantObjectFactory.Save();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        /// <summary>
        /// Get all child constant object value of constant object by object id
        /// </summary>
        /// <param name="id">object_id</param>
        /// <returns>constant object value model in json or error message</returns>
        //[Authorize]
        [CheckUserSessionAttribute]
        public JsonResult getConstantObjectValueListByObjectId(int id)
        {
            try
            {
                constantObjectValueFactory = new ConstantObjectValueFactory();
                decimal membership_id = SessionManger.BrokerOfLoggedInUser(Session).membership_id;

                var constantObjectValue = (dynamic)null;
                if (id == 0)
                {
                    constantObjectValue = constantObjectValueFactory.GetAll()
                        .Select(a => new 
                        { 
                            a.object_value_id, 
                            a.display_value, 
                            a.object_id, 
                            a.sorting_order, 
                            a.remarks, 
                            a.tblConstantObject.object_name 
                        }).OrderBy(a => new { a.object_name, a.sorting_order }).ToList();
                }
                else
                {
                    constantObjectValue = constantObjectValueFactory.FindBy(b => b.object_id == id)
                        .Select(a => new 
                        { 
                            a.object_value_id, 
                            a.display_value, 
                            a.object_id, 
                            a.sorting_order, 
                            a.remarks, 
                            a.tblConstantObject.object_name 
                        }).OrderBy(a => new { a.object_name, a.sorting_order }).ToList();
                }

                return Json(new { constantObjectValue = constantObjectValue, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, errorMessage = ex.Message });
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (constantObjectFactory != null)
            {
                constantObjectFactory.Dispose();
            }

            if (constantObjectValueFactory != null)
            {
                constantObjectValueFactory.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}