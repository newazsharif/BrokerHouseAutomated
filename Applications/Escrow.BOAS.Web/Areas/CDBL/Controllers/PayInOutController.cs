using Escrow.BOAS.CDBL.Factories;
using Escrow.BOAS.CDBL.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Escrow.BOAS.Utility;

namespace Escrow.BOAS.Web.Areas.CDBL.Controllers
{
    public class PayInOutController : Controller
    {
        // GET: CDBL/PayInOut
        [CheckUserSessionAttribute]
        //[Authorize]
        public ActionResult PayInOut()
        {
            return View();
        }
        //[Authorize]
        public JsonResult GetddlStockExchange()
        {
            var data = DropDown.ddlStockExchange();
            return Json(new { data = data, success = true }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult SetPayinOutPath()
        {
            var data = ConfigManager.payInOut_file_path;
            return Json(new { data = data, success = true }, JsonRequestBehavior.AllowGet);
        }
        [CheckUserSessionAttribute]
        //[Authorize]
        public JsonResult ExportPayInOut(string isPayinPayout,decimal trd_dt)
        {
            PayInOutFactory payInOut = new PayInOutFactory();
            try
            {
                List<psp_export_pay_in_pay_out_Result> exportList = new List<psp_export_pay_in_pay_out_Result>();

                exportList = payInOut.ExportPayInOut(isPayinPayout,trd_dt);
                if (exportList.Count == 0)
                {
                    return Json(new { message = "No data to generate file" }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    string filePath = ConfigManager.payInOut_file_path;
                    filePath = filePath + exportList[0].fName;
                    FileStream fs = new FileStream(filePath, FileMode.Create);
                    StreamWriter f1 = new StreamWriter(fs);


                    //TextWriter tw = new StreamWriter(filePath);
                    f1.WriteLine(exportList[0].head);
                    f1.Flush();

                    int i = 0;
                    foreach (var s in exportList)
                    {
                        f1.WriteLine(s.body);
                        f1.Flush();
                        i++;
                    }
                    f1.Close();
                    return Json(new { success = true, message = "File exported Successfully" }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                return Json(new { message = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}