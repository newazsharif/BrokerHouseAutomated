using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.BOAS.Configuration.Factories;
using Escrow.BOAS.Configuration.Models;

namespace Escrow.BOAS.Web.Areas.Configuration.Controllers
{
    public class AccountMappingController : Controller
    {
        private AccountMappingFactory accountMappingFactory;
        // GET: Configuration/AccountMapping
        public ActionResult AccountMap()
        {
            return View();
        }

        public JsonResult GetAllLedgerHead()
        {
            try
            {
                accountMappingFactory = new AccountMappingFactory();
                //List<tfun_get_ledger_head_Result> ledgerHeads = new List<tfun_get_ledger_head_Result>();
                var ledgerHeads = accountMappingFactory.AccountMappingList().Select(x => new
                {
                    value = x.ledger_id,
                    text = x.ledger_name
                });
                return Json(new {success = true, data = ledgerHeads}, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new { success = false, errorMessage = exception.Message }, JsonRequestBehavior.AllowGet);
            }
            
        }

        public JsonResult UpdateAccountMapping(List<accMapping> accountMappings)
        {
            try
            {
                accountMappingFactory = new AccountMappingFactory();
                foreach (accMapping item in accountMappings)
                {
                    accountMappingFactory.Edit(item);
                }
                accountMappingFactory.Save();
                return Json(new { success = true, message = "success" }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
                return Json(new { success = false, errorMessage = exception.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult LoadAllMapping()
        {
            try
            {
                accountMappingFactory = new AccountMappingFactory();
                List<accMapping> mappings = accountMappingFactory.GetAll().ToList();
                return Json(new { success = true, data = mappings }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exception)
            {
               return Json(new { success = false, errorMessage = exception.Message }, JsonRequestBehavior.AllowGet);
            }
            
        }
    }
}