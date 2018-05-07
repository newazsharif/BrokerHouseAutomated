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
    public class ActionController : Controller
    {
        // GET: SystemManagement/Action
        private IGenericFactory<tblAction> actionFactory;
        private IGenericFactory<tblController> controllerFactory;

        /// <summary>
        /// Action UI for Creating new Action
        /// Author : Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public ActionResult NewAction()
        {
            return View();
        }

        /// <summary>
        /// Action UI for Action List
        /// Author ; Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public ActionResult ActionList()
        {
            return View();
        }

        /// <summary>
        /// Action UI for editing an Action
        /// Author : Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public ActionResult EditAction()
        {
            return View();
        }
        /// <summary>
        /// Add New Report UI
        /// Author : Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public ActionResult NewReport()
        {
            return View();
        }
        /// <summary>
        /// Report List UI
        /// Author : Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public ActionResult ReportList()
        {
            return View();
        }

        /// <summary>
        /// Edit a report Information UI
        /// Author Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public ActionResult EditReport()
        {
            return View();
        }
        /// <summary>
        /// Action for saving new action
        /// Author :  Newaz Sharif
        /// </summary>
        /// <param name="actionModel"></param>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public JsonResult AddNewAction(tblAction actionModel)
        {
            actionFactory = new ActionFactory();
            try
            {
                actionFactory.Add(actionModel);
                actionFactory.Save();
                return Json(new {message = "Saved Successfully", success = true}, JsonRequestBehavior.AllowGet);

            }
            catch (Exception exception)
            {

                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Action for saving new action
        /// Author :  Newaz Sharif
        /// </summary>
        /// <param name="actionModel"></param>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public JsonResult AddNewReport(tblAction actionModel)
        {
            actionFactory = new ActionFactory();
            controllerFactory = new ControllerFactory();
            try
            {
                actionModel.is_view = 1;
                actionModel.is_in_menu = 1;
                actionModel.class_name = actionModel.name;
                actionModel.url = "/#Report/" + actionModel.name;
                decimal controllerId = controllerFactory.FindBy(a => a.name.ToUpper() == "REPORTCONTROLLER").Select(a => a.id).FirstOrDefault();
                actionModel.controller_id = controllerId;
                actionFactory.Add(actionModel);
                actionFactory.Save();
                return Json(new { message = "Saved Successfully", success = true }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception exception)
            {

                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Action for getting action list
        /// Author :  Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public JsonResult GetActionsList()
        {
            actionFactory =  new ActionFactory();
            try
            {
                var actions = actionFactory.GetAll().Where(a=>!a.tblUIModule.id_name.EndsWith("Reports")).Select(a => new
                {
                    a.id,
                    a.name,
                    a.class_name,
                    a.display_name,
                    is_in_menu = a.is_in_menu == 1 ? "Yes" : "No",
                    is_view = a.is_view == 1 ? "Yes" : "No",
                    module = a.tblUIModule.name,
                    controller = a.tblController.name,
                    a.url
                }).ToList();
                return Json(new {result = actions, success = true}, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {

                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }


        /// <summary>
        /// Action for getting report list
        /// Author :  Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public JsonResult GetReportsList()
        {
            actionFactory = new ActionFactory();
            try
            {
                var actions = actionFactory.GetAll().Where(a=>a.tblUIModule.id_name.EndsWith("Reports")).Select(a => new
                {
                    a.id,
                    a.name,
                    a.class_name,
                    a.display_name,
                    is_in_menu = a.is_in_menu == 1 ? "Yes" : "No",
                    is_view = a.is_view == 1 ? "Yes" : "No",
                    module = a.tblUIModule.name,
                    controller = a.tblController.name,
                    a.url
                }).ToList();
                return Json(new { result = actions, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {

                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }
        /// <summary>
        /// Get action by using id
        /// Author : Newaz Sharif
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        
        public JsonResult GetActionById(decimal id)
        {
            actionFactory = new ActionFactory();
            try
            {
                var actionModel = actionFactory.FindBy(a => a.id == id).Select(
                    a => new
                    {
                        a.id,
                        a.class_name,
                        a.display_name,
                        a.is_in_menu,
                        a.url,
                        a.controller_id,
                        a.is_view,
                        a.name,
                        a.ui_module_id
                    }).FirstOrDefault();
                return Json(new { result = actionModel, success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }


        /// <summary>
        /// Action for Update an existing action
        /// Author : Newaz Sharif
        /// </summary>
        /// <param name="actionModel"></param>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public JsonResult UpdateAction(tblAction actionModel)
        {
            actionFactory = new ActionFactory();
            try
            {
                
                actionFactory.Edit(actionModel);
                actionFactory.Save();
                return Json(new { message = "Updated Successfully", success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Action for Update an existing Report
        /// Author : Newaz Sharif
        /// </summary>
        /// <param name="actionModel"></param>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public JsonResult UpdateReport(tblAction actionModel)
        {
            actionFactory = new ActionFactory();
            controllerFactory = new ControllerFactory();
            try
            {
                actionModel.is_view = 1;
                actionModel.is_in_menu = 1;
                actionModel.class_name = actionModel.name;
                actionModel.url = "/#Report/" + actionModel.name;
                decimal controllerId = controllerFactory.FindBy(a => a.name.ToUpper() == "REPORTCONTROLLER").Select(a => a.id).FirstOrDefault();
                actionModel.controller_id = controllerId;
                actionFactory.Edit(actionModel);
                actionFactory.Save();
                return Json(new { message = "Updated Successfully", success = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult GetDdlModule()
        {
            var result = DropDown.ddlModule();
            return Json(new { result, success = true }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetDdlModuleForReport()
        {
            var result = DropDown.ddlModuleForReport();
            return Json(new { result, success = true }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetDdlController(decimal module_id)
        {
            var result = DropDown.ddlController(module_id);
            return Json(new { result, success = true }, JsonRequestBehavior.AllowGet);
        }

    }
}