using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.BOAS.Utility;
using Escrow.Security.Factories;
using Escrow.Security.Models;
using Escrow.Utility.Factories;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.Web.Areas.SystemManagement.Controllers
{
    public class BrokerModuleMappingController : Controller
    {
        private IGenericFactory<tblBrokerModuleMapping> brokerModuleMappingFactory;
        private IGenericFactory<tblUIModule> moduleFactory;

        /// <summary>
        /// UI for Broker Module  Mapping
        /// Author : Newaz Sharif
        /// </summary>
        /// <returns></returns>
        [CheckUserSessionAttribute]
        public ActionResult BrokerModuleMapping()
        {
            return View();
        }

        public JsonResult getDdlBroker()
        {
            try
            {
                var brokers = DropDown.ddlBroker();
                return Json(new {result = brokers, success = true}, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Get Module list by membership_id
        /// Author :Newaz Sharif
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        
        public JsonResult GetModuleListByBroker(decimal id)
        {
            brokerModuleMappingFactory = new BrokerModuleMappingFactory();
            moduleFactory = new ModuleFactory();
            try
            {
                var allModule = moduleFactory.GetAll().ToList();
                var modules = (from m in allModule
                    join b in brokerModuleMappingFactory.GetAll().Where(a => a.membership_id == id) on m.id equals
                        b.ui_module_id into mb
                    from x in mb.DefaultIfEmpty()
                    select new
                    {
                        m.id,
                        m.name,
                        m.id_name,
                        selected = x != null
                    }).ToList();
                return Json(new {result = modules, success = true}, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new { errorMessage = exception.Message, success = false }, JsonRequestBehavior.AllowGet);
            }
        }

        [CheckUserSessionAttribute]
        public JsonResult SaveBrokerModuleMapping(decimal[] id, decimal membership_id)
        {
            brokerModuleMappingFactory = new BrokerModuleMappingFactory();
            try
            {
                List<tblBrokerModuleMapping> brokerModuleMapping =
                    brokerModuleMappingFactory.GetAll().Where(a => a.membership_id == membership_id).ToList();
                foreach (var item in brokerModuleMapping)
                {
                    brokerModuleMappingFactory.Delete(item);
                }
                foreach (var item in id)
                {
                    tblBrokerModuleMapping tempBrokerModuleMapping = new tblBrokerModuleMapping();
                    
                    tempBrokerModuleMapping.ui_module_id = item;
                    tempBrokerModuleMapping.membership_id = membership_id;
                    brokerModuleMappingFactory.Add(tempBrokerModuleMapping);
                }
                brokerModuleMappingFactory.Save();
                return Json(new {message = "Saved Successfully", success = true}, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new {errorMessage = exception.Message, success = false}, JsonRequestBehavior.AllowGet);
            }
        }
    }
}