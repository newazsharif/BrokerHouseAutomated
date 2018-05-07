using Escrow.BOAS.Process.Factories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Escrow.BOAS.Utility;


namespace Escrow.BOAS.Web.Areas.ProcessManagement.Controllers
{
    public class DayProcessController : Controller
    {
        ProcessFactory processFactory;
        [CheckUserSessionAttribute]
        //[Authorize]
        public ActionResult DayEndProcess()
        {
            return View();
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult ExecuteDayEnd(int process_dt)
        {
            processFactory = new ProcessFactory();
            string end_by = User.Identity.GetUserId();
            try
            {
                processFactory.DayEndByCMD(process_dt, end_by, SessionManger.BrokerOfLoggedInUser(Session).membership_id);
                return Json(true, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(ex.Message,JsonRequestBehavior.AllowGet);
            }
            
            
        }
        
    }
}