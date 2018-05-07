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
    public class ModuleController : Controller
    {
        // GET: SystemManagement/Module
        private IGenericFactory<tblUIModule> moduleFactory;
        /// <summary>
        /// UI Page for adding new Module
        /// Author : Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSession]
        public ActionResult NewModule()
        {
            return View();
        }
        /// <summary>
        /// UI Page for Edit Module
        /// Author : Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSession]
        public ActionResult EditModule()
        {
            return View();
        }
        /// <summary>
        /// UI Page for Showing Module List
        /// Author: Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSession]
        public ActionResult ModuleList()
        {
            return View();
        }
        /// <summary>
        /// Add New Module Action
        /// Author: Newaz Sharif
        /// </summary>
        /// <param name="uiModule"></param>
        /// <returns></returns>
        [CheckUserSession]
        public JsonResult AddNewModule(tblUIModule uiModule)
        {
            moduleFactory = new ModuleFactory();
            try
            {
                if (!isModuleExists(uiModule))
                {
                    moduleFactory.Add(uiModule);
                    moduleFactory.Save();
                    return Json(new {message = "Module Added Successfully", success = true},
                        JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { errorMessage = "This Module Already Exists", success = false },
                        JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception exception)
            {
                return Json(new { errorMessage = exception.Message, success = false },
                        JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Update action for update module
        /// Author: Newaz Sharif
        /// </summary>
        /// <param name="uiModule"></param>
        /// <returns></returns>
        [CheckUserSession]
        public JsonResult UpdateModule(tblUIModule uiModule)
        {
            moduleFactory = new ModuleFactory();
            try
            {
                moduleFactory.Edit(uiModule);
                moduleFactory.Save();
                return Json(new { message = "Module Updated Successfully", success = true },
                    JsonRequestBehavior.AllowGet);
               
            }
            catch (Exception exception)
            {
                return Json(new { errorMessage = exception.Message, success = false },
                        JsonRequestBehavior.AllowGet);
            }
        }
        /// <summary>
        /// Get all Modules via action
        /// Author : Newaz Sharif
        /// </summary>
        /// <returns></returns>
        
        public JsonResult GetAllModule()
        {
            moduleFactory = new ModuleFactory();
            try
            {
                var modules = moduleFactory.GetAll().Select(a => new
                {
                    a.id,
                    a.id_name,
                    a.name,
                    a.sort_id
                }).ToList();

                return Json(new {result = modules, success = true}, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {

                return Json(new {errorMessage = exception.Message, success = false}, JsonRequestBehavior.AllowGet);
            }
            
        }

        /// <summary>
        /// Get Module Inforation by id via action
        /// Author : Newaz Sharif
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public JsonResult GetModuleById(decimal id)
        {
            moduleFactory = new ModuleFactory();
            try
            {
                var uiModule = moduleFactory.GetAll().Where(a => a.id == id).Select(
                    a => new
                    {
                        a.id,
                        a.id_name,
                        a.name,
                        a.sort_id
                    }).FirstOrDefault();
                return Json(new {result = uiModule, success = true}, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }

        //private bool isModuleExistsForEdit(tblUIModule uiModule)
        //{
        //    moduleFactory = new ModuleFactory();
        //    tblUIModule _uiModule = moduleFactory.FindBy(a => a.name == uiModule.name).FirstOrDefault();
        //    if (_uiModule == null)
        //    {
        //        return false;
        //    }
        //    return true;
        //}



        private bool isModuleExists(tblUIModule uiModule)
        {
            moduleFactory = new ModuleFactory();
            tblUIModule _uiModule = moduleFactory.FindBy(a => a.name == uiModule.name).FirstOrDefault();
            if (_uiModule == null)
            {
                return false;
            }
            return true;
        }
    }
}