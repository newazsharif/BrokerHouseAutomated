using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.BOAS.Configuration.Factories;
using Escrow.BOAS.Configuration.Models;
using Escrow.BOAS.Utility;
using Escrow.Utility.Interfaces;

namespace Escrow.BOAS.Controllers
{
    public class HomeController : Controller
    {
        private IGenericFactory<tblDailyWorkList> dailyWorkListFactory; 
        public ActionResult Index()
        {
            return View();
        }

        //[Authorize]
        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        //[Authorize]
        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }


        public ActionResult HomeMaster()
        {
            return View();
        }

        public ActionResult RedirectToMain()
        {
            return View();
        }

        public JsonResult getTodayTaskStatus()
        {
            try
            {
                dailyWorkListFactory = new DailyWorkList();
                //List<tblDailyWorkList> dailyWorkList = new List<tblDailyWorkList>();
                decimal membershipId = SessionManger.BrokerOfLoggedInUser(Session).membership_id;
                var dailyWorkList = dailyWorkListFactory.FindBy(a => a.membership_id == membershipId)
                    .Select(x => new
                    {
                        x.id,
                        x.sort_order,
                        x.work_name,
                        is_done = x.is_done == 1 ? "glyphicon glyphicon-ok" : "glyphicon glyphicon-remove"
                    }).OrderBy(z=>z.sort_order).ToList();
                return Json(new {data = dailyWorkList, success = true}, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new {errorMessage = exception.Message, success = false}, JsonRequestBehavior.AllowGet);
            }
        }
    }
}