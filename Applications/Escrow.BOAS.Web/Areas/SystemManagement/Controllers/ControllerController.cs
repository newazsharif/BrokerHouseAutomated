using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.BOAS.Utility;
using Escrow.Security.Factories;
using Escrow.Security.Models;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.Web.Areas.SystemManagement.Controllers
{
    public class ControllerController : Controller
    {

        private IGenericFactory<tblController> controllerFactory;
        private IGenericFactory<tblUIModule> uiModuleFactory; 
        // GET: SystemManagement/Controller
        /// <summary>
        /// Action for new Controller UI
        /// Author : Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSession]
        public ActionResult NewController()
        {
            return View();
        }
        /// <summary>
        /// Action for edit Controller UI
        /// Author : Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSession]
        public ActionResult EditController()
        {
            return View();
        }
        /// <summary>
        /// Action for Controller List UI
        /// Author : Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSession]
        public ActionResult ControllerList()
        {
            return View();
        }

        /// <summary>
        /// Action for getting controller list
        /// Author : Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSession]
        public JsonResult GetControllerList()
        {
            try
            {
                controllerFactory = new ControllerFactory();
                var controllerList = controllerFactory.GetAll().Select(a => new
                {
                    a.id,
                    controllerName = a.name,
                    moduleName = a.tblUIModule.name
                }).ToList();
                return Json(new {result = controllerList, success = true}, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new {errorMessage = exception.Message, success = false}, JsonRequestBehavior.AllowGet);
            }
        }

        
        /// <summary>
        /// Action for adding new controller
        /// Author : Newaz Sharif
        /// </summary>
        /// <param name="_controller"></param>
        /// <returns></returns>
        [HttpPost]
        [CheckUserSession]
        public JsonResult SaveNewController(tblController _controller)
        {
            try
            {
                controllerFactory = new ControllerFactory();
                controllerFactory.Add(_controller);
                controllerFactory.Save();
                return Json(new {message = "Saved Successfully", success = true}, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new {errorMessage = exception.Message, success = false}, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Action for get controller information by id
        /// Author : Newaz Sharif
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public JsonResult GetControllerById(decimal id)
        {
            try
            {
                controllerFactory = new ControllerFactory();
                var controller = controllerFactory.GetAll().Where(a=>a.id == id).Select(
                    a=> new
                    {
                        a.id,
                        a.name,
                        a.ui_module_id,
                    }).FirstOrDefault();
                return Json(new {result = controller, success = true}, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }
        /// <summary>
        /// Update action for controller
        /// Author : Newaz Sharif
        /// </summary>
        /// <param name="controller"></param>
        /// <returns></returns>
        [CheckUserSession]
        public JsonResult UpdateController(tblController _controller)
        {
            try
            {
                controllerFactory = new ControllerFactory();
                controllerFactory.Edit(_controller);
                controllerFactory.Save();
                return Json(new { message = "Updated Successfully", success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Get data for loading dropdown fo module
        /// Author : Newaz Sharif
        /// </summary>
        /// <returns></returns>
        public JsonResult GetDdlModule()
        {
            var result = DropDown.ddlModule();
            return Json(new {result, success = true}, JsonRequestBehavior.AllowGet);
        }
    }
}